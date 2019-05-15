//
//  SpaceMainVC.swift
//  Planner
//
//  Created by bainingshuo on 4/12/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SpaceMainTVC: UITableViewController {

    let numQuery = 20
    var themeColor = UIColor.init(red: 28/255.0, green: 116/255.0, blue: 235/255.0, alpha: 1.0)
    var db: Firestore!
    var filteredCourses = [Course]()
    var courses = [Course]()
    let searchController = UISearchController(searchResultsController: nil)
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    
    @IBAction func createIsPushed(_ sender: UIBarButtonItem) {
        if Auth.auth().currentUser == nil {
            let alert = UIAlertController(title: "Error", message: "To create a course, user must log in first", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(alert, animated: true)
        } else {
            let editCourseVC = EditCourseViewController(isCreate: true, parent: self, course: nil)
            editCourseVC.present(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CourseTVCell", bundle: nil), forCellReuseIdentifier: "courseCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Courses"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCourses(completion: nil)
    }
    
    
    func loadCourses(completion: (() -> Void)?) {
        db.collection("courses").limit(to: numQuery).getDocuments { (querySnapshot, error) in
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
    
    func isFiltering() -> Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCourses.count
        }
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var course: Course!
        if isFiltering() {
            course = filteredCourses[indexPath[1]]
        } else {
            course = courses[indexPath[1]]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell") as! CourseTVCell
        cell.initialize(name: course.getName(),
                        semester: course.getSemester(),
                        description: course.getDescription(),
                        date: course.getCreateDateString(),
                        indexPath: indexPath, delegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 3 >= courses.count {
//            loadCourses()
//        }
//    }
}


extension SpaceMainTVC: CourseTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: "Options", message: "What do you want to do with this course", preferredStyle: .actionSheet)
        let uid = Auth.auth().currentUser?.uid ?? ""
        let courseID = self.courses[indexPath[1]].getID()
        self.db.collection("follows").whereField("uid", isEqualTo: uid).whereField("course_id", isEqualTo: courseID).getDocuments { (querySnapshot, error) in
            if error != nil {
                // nothing
            } else {
                var followingID: String?
                if querySnapshot!.documents.count > 0 {
                    followingID = querySnapshot!.documents[0].documentID
                }
                let followAction = self.createFollowAction(followingID: followingID, indexPath: indexPath)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                optionMenu.addAction(followAction)
                optionMenu.addAction(cancelAction)
                self.present(optionMenu, animated: true, completion: nil)
            }
        }
    }
    
    func createFollowAction(followingID: String?, indexPath: IndexPath) -> UIAlertAction {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let followAction: UIAlertAction!
        let completion: ((Error?) -> Void) = { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Error",
                                              message: error!.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
        if followingID != nil {
            followAction = UIAlertAction(title: "Unfollow", style: .default, handler: { action in
                self.db.collection("follows").document(followingID!).delete(completion: completion)
            })
        } else {
            followAction = UIAlertAction(title: "Follow", style: .default, handler:{ action in
                if uid == "" {
                    let alert = UIAlertController(title: "Error",
                                                  message: "User must log in to follow a course",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    let data = ["course_id": self.courses[indexPath.row].getID(), "uid": uid]
                    self.db.collection("follows").addDocument(data: data, completion: completion)
                }
            })
        }
        return followAction
    }
}


extension SpaceMainTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.db.collection("courses").whereField("name", isEqualTo: searchController.searchBar.text!).getDocuments { (querySnapshot, error) in
            if error != nil {
                
            } else {
                self.filteredCourses.removeAll()
                for document in querySnapshot!.documents {
                    let data = document.data() as [String: AnyObject]
                    self.filteredCourses.append(Course(id: document.documentID, data: data))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
}
