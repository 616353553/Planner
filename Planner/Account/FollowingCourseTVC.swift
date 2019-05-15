//
//  FollowingCourseTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/21/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FollowingCourseTVC: UITableViewController {
    
    var followingIDs = [String?]()
    var courses = [Course?]()
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CourseTVCell", bundle: nil), forCellReuseIdentifier: "courseCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.refreshCourseData(_:)), for: .valueChanged)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .groupTableViewBackground
        db = Firestore.firestore()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        db.collection("follows").whereField("uid", isEqualTo: uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive))
                self.present(alert, animated: true)
            } else {
                self.followingIDs = [String?](repeating: nil, count: querySnapshot!.documents.count)
                self.courses = [Course?](repeating: nil, count: querySnapshot!.documents.count)
                self.tableView.reloadData()
                for (idx, document) in querySnapshot!.documents.enumerated() {
                    self.followingIDs[idx] = document.documentID
                    let data = document.data() as [String: AnyObject]
                    let courseID = data["course_id"] as! String
                    // retrieve course data
                    self.db.collection("courses").document(courseID).getDocument { (documentSnapshot, error) in
                        if error != nil {
                            // do nothing
                        } else {
                            let courseData = documentSnapshot!.data()! as [String: AnyObject]
                            self.courses[idx] = Course(id: courseID, data: courseData)
                            self.tableView.reloadRows(at: [[0, idx]], with: .automatic)
                        }
                    }
                }
            }
            completion?()
        }
    }
    
    @objc private func refreshCourseData(_ sender: Any) {
        reloadCourses(completion: {() in
            self.refreshControl?.endRefreshing()
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let course = courses[indexPath[1]]
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTVCell
        if course != nil {
            cell.initialize(name: course!.getName(),
                            semester: course!.getSemester(),
                            description: course!.getDescription(),
                            date: course!.getCreateDateString(),
                            indexPath: indexPath,
                            delegate: self)
        } else {
            cell.initialize(name: "",
                            semester: "",
                            description: "",
                            date: "",
                            indexPath: indexPath,
                            delegate: self)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FollowingCourseTVC: CourseTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath) {
        let followingID = self.followingIDs[indexPath[1]] ?? ""
        let optionMenu = UIAlertController(title: "Options", message: "What do you want to do with this course", preferredStyle: .actionSheet)
        let followAction = UIAlertAction(title: "Unfollow", style: .default, handler: { action in
            self.db.collection("follows").document(followingID).delete { (error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error",
                                                  message: error!.localizedDescription,
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    self.followingIDs.remove(at: indexPath[1])
                    self.courses.remove(at: indexPath[1])
                    self.tableView.performBatchUpdates({
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    }, completion: nil)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(followAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}
