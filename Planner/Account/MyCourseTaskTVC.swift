//
//  MyCourseTaskTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyCourseTaskTVC: UITableViewController {
    
    var db: Firestore!
    let numQuery = 20
    var courseID: String!
    var tasks = [CourseTask]()
    
    @IBAction func addIsPushed(_ sender: UIBarButtonItem) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let current = Date()
        let duration = Duration(day: 0, hour: 0, minute: 0, second: 0)
        let task = CourseTask(courseID: courseID,
                              owner: uid,
                              name: "",
                              deadline: current,
                              durationEstimate: duration,
                              description: "",
                              createDate: current)
        let controller = EditTaskViewController(isCreate: true,
                                                isDisplayable: false,
                                                parent: self,
                                                task: task)
        controller.present(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "CourseTaskTVCell", bundle: nil), forCellReuseIdentifier: "courseTaskCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = .groupTableViewBackground
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        loadTasks(completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func loadTasks(completion: (() -> Void)?) {
        db.collection("course_tasks").whereField("course_id", isEqualTo: courseID).limit(to: numQuery).getDocuments { (querySnapshot, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            } else {
                self.tasks.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data() as [String: AnyObject]
                    do {
                        let task = try CourseTask(id: document.documentID, data: data)
                        self.tasks.append(task)
                    } catch {
                        // duration cannot be parsed
                    }
                }
                self.tableView.reloadData()
            }
            completion?()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = tasks[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseTaskCell") as! CourseTaskTVCell
        
        cell.initialize(name: task.getName(),
                        deadline: formatter.string(from: task.getDeadline()),
                        duration: task.getDurationEstimate().toString(),
                        description: task.getDescription(),
                        createDate: formatter.string(from: task.getCreateDate()),
                        delegate: self,
                        indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }

}

extension MyCourseTaskTVC: TaskTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath) {
        let task = self.tasks[indexPath.row]
        let optionMenu = UIAlertController(title: "Options", message: "What do you want to do with your task", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler:{ (action) -> Void in
            let vc = EditTaskViewController(isCreate: false, isDisplayable: false, parent: self, task: task)
            vc.present(animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are your sure you want to delete this task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                self.db.collection("course_tasks").document(task.getID()!).delete() { err in
                    if err != nil {
                        let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        self.tasks.remove(at: indexPath.row)
                        self.tableView.performBatchUpdates({
                            self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        }, completion: nil)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(editAction)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
