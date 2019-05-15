//
//  TaskTypeTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/28/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseAuth

class TaskTypeTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .groupTableViewBackground
        tableView.isScrollEnabled = false

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        if indexPath == [0, 0] {
            let today = Date()
            let task = DisplayableTask(type: .custom,
                                       owner: Auth.auth().currentUser?.uid ?? "",
                                       name: "",
                                       deadline: today,
                                       durationEstimate: Duration(day: 0, hour: 0, minute: 0, second: 0),
                                       description: "",
                                       createDate: today,
                                       priority: 0,
                                       color: .black)
            let vc = EditTaskViewController(isCreate: true, isDisplayable: true, parent: self, task: task)
            vc.present(animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "toCourseTask", sender: self)
        }
    }

}
