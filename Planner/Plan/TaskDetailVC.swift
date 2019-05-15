//
//  TaskDetailVC.swift
//  Planner
//
//  Created by bainingshuo on 4/29/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TaskDetailVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var task: DisplayableTask!
    var db: Firestore!
    
    @IBAction func editIsPushed(_ sender: UIBarButtonItem) {
        let optionMenu = UIAlertController(title: "Options", message: "What do you want to do with your task", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit", style: .default, handler:{ (action) -> Void in
            let vc = EditTaskViewController(isCreate: false, isDisplayable: true, parent: self, task: self.task)
            vc.present(animated: true, completion: nil)
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            let alert = UIAlertController(title: "Warning", message: "Are your sure you want to delete this task?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                self.db.collection("displayable_tasks").document(self.task.getID()!).delete() { err in
                    if err != nil {
                        let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        self.navigationController?.popViewController(animated: true)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorView.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        nameLabel.text = task.getName()
        colorView.backgroundColor = task.getColor()
        priorityLabel.text = String(task.getPriority())
        deadlineLabel.text = task.getDeadlineString()
        durationLabel.text = task.getDurationEstimate().toString()
        descriptionLabel.text = task.getDescription()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
