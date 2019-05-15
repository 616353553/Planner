//
//  MyCourseTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyCourseTVC: UITableViewController {

    var db: Firestore!
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CourseTVCell", bundle: nil), forCellReuseIdentifier: "courseCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.refreshCourseData(_:)), for: .valueChanged)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .groupTableViewBackground
        db = Firestore.firestore()
        reloadCourses(completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        reloadCourses(completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func reloadCourses(completion: (() -> Void)?) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        db.collection("courses").whereField("owner", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            } else {
                self.courses.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data() as [String: AnyObject]
                    self.courses.append(Course(id: document.documentID, data: data))
                }
                self.tableView.reloadData()
            }
            completion?()
        }
    }
    
    
    @objc private func refreshCourseData(_ sender: Any) {
        reloadCourses(completion: {() in
            self.refreshControl?.endRefreshing()
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MyCourseTaskTVC
        vc.courseID = courses[(sender as! IndexPath).row].getID()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = courses[indexPath[1]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTVCell
        cell.initialize(name: course.getName(),
                        semester: course.getSemester(),
                        description: course.getDescription(),
                        date: course.getCreateDateString(),
                        indexPath: indexPath,
                        delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        self.performSegue(withIdentifier: "toTasks", sender: indexPath)
        
    }

}


extension MyCourseTVC: CourseTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: "Options", message: "What do you want to do with your course", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler:{ (action) -> Void in
            let editCourseController = EditCourseViewController(isCreate: false, parent: self, course: self.courses[indexPath.row])
            editCourseController.present(animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are your sure you want to delete this course?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                self.db.collection("courses").document(self.courses[indexPath.row].getID()).delete() { err in
                    if err != nil {
                        let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        self.courses.remove(at: indexPath.row)
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
