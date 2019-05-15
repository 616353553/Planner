//
//  FollowingCourseTaskTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/28/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FollowingCourseTaskTVC: UITableViewController {

    var db: Firestore!
    var courseIDs = [String]()
    var courses = [Course?]()
    var tasks = [[CourseTask]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CourseTaskTVCell", bundle: nil), forCellReuseIdentifier: "courseTaskCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .groupTableViewBackground
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadCourses()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func loadCourses() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("follows").whereField("uid", isEqualTo: uid).getDocuments { (snapshot, error) in
            if error == nil {
                self.courseIDs.removeAll()
                for document in snapshot!.documents {
                    let data = document.data() as [String: AnyObject]
                    self.courseIDs.append(data["course_id"] as! String)
                }
                
                self.courses = [Course?](repeating: nil, count: self.courseIDs.count)
                self.tasks.removeAll()
                
                let dispatchGroup = DispatchGroup()
                for (idx, courseID) in self.courseIDs.enumerated() {
                    self.tasks.append([CourseTask]())
                    dispatchGroup.enter()
                    // load course data
                    self.db.collection("courses").document(courseID).getDocument(completion: { (snapshot, error) in
                        if error == nil {
                            let data = snapshot!.data()! as [String : AnyObject]
                            self.courses[idx] = Course(id: snapshot!.documentID, data: data)
                            // load course tasks
                            self.db.collection("course_tasks").whereField("course_id", isEqualTo: courseID).getDocuments(completion: { (snapshot, error) in
                                if error == nil {
                                    for document in snapshot!.documents {
                                        let data = document.data() as [String: AnyObject]
                                        print(data)
                                        do {
                                            let task = try CourseTask(id: document.documentID, data: data)
                                            self.tasks[idx].append(task)
                                        } catch {
                                            // duration cannot be parsed
                                        }
                                    }
                                }
                                dispatchGroup.leave()
                            })
                        } else {
                            dispatchGroup.leave()
                        }
                    })
                }
                dispatchGroup.notify(queue: .main, execute: {
                    self.tableView.reloadData()
                })
//                let _ = dispatchGroup.wait(timeout: .distantFuture)
                
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return courseIDs.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.section][indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "courseTaskCell") as! CourseTaskTVCell
        cell.initialize(name: task.getName(),
                        deadline: task.getDeadlineString(),
                        duration: task.getDurationEstimate().toString(),
                        description: task.getDescription(),
                        createDate: task.getCreateDateString(),
                        delegate: self,
                        indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let uid = Auth.auth().currentUser?.uid ?? ""
        let courseTask = self.tasks[indexPath.section][indexPath.row]
        let task = DisplayableTask(type: .course,
                                   owner: uid,
                                   name: courseTask.getName(),
                                   deadline: courseTask.getDeadline(),
                                   durationEstimate: courseTask.getDurationEstimate(),
                                   description: courseTask.getDescription(),
                                   createDate: courseTask.getCreateDate(),
                                   priority: 0,
                                   color: .black,
                                   originalID: courseIDs[indexPath.section])
        let vc = EditTaskViewController(isCreate: true, isDisplayable: true, parent: self, task: task)
        vc.present(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return courses[section]!.getName()
    }
}

extension FollowingCourseTaskTVC: TaskTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath) {
        print(indexPath)
    }
    
 
}
