//
//  CreateCourseTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditCourseTVC: UITableViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameCounterLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var semesterArrow: UIImageView!
    @IBOutlet weak var semesterPicker: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var descriptionCounterLabel: UILabel!
    
    var isCreate: Bool!
    var course: Course?
    
    let nameMaxLength = 40
    let descriptionMaxLength = 1000
    var isEditingSemester = false
    
    let semesterData = ["Spring", "Summer", "Fall", "Winter"]
    var yearData = [String]()
    
    var tap: UITapGestureRecognizer!
    var db: Firestore!
    
    @IBAction func cancelIsPushed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Alert", message: "Performing this action will discard all the changes", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func actionIsPushed(_ sender: UIBarButtonItem) {
        if isCreate {
            createCourse()
        } else {
            updateCourse()
        }
    }
    
    
    func isValidCourse() -> String? {
        let trimmedName = nameTextField.text!.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        if nameTextField.text!.count > nameMaxLength || trimmedName.count == 0 {
            return "Invalid course name"
        } else if descriptionTextView.text.count > descriptionMaxLength || trimmedDescription.count == 0 {
            return "Invalid course description"
        }
        return nil
    }
    
    func createCourse() {
        let errorString = isValidCourse()
        if errorString != nil {
            let alert = UIAlertController(title: "Error", message: errorString!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            let course = Course(name: nameTextField.text!,
                                owner: Auth.auth().currentUser!.uid,
                                semester: semesterLabel.text!,
                                description: descriptionTextView.text,
                                createDate: Date())
            db.collection("courses").addDocument(data: course.toJSON()) {err in
                if err != nil {
                    let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateCourse() {
        let errorString = isValidCourse()
        if errorString != nil {
            let alert = UIAlertController(title: "Error", message: errorString!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            let newCourse = Course(name: nameTextField.text!, owner: Auth.auth().currentUser!.uid, semester: semesterLabel.text!, description: descriptionTextView.text, createDate: Date())
            db.collection("courses").document(course!.getID()).setData(newCourse.toJSON()) { err in
                if err != nil {
                    let alert = UIAlertController(title: "Error", message: err!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        
        actionButton.title = isCreate ? "Create" : "Update"
        navigationItem.title = isCreate ? "Create Course" : "Edit Course"
        nameTextField.delegate = self
        semesterPicker.delegate = self
        semesterPicker.dataSource = self
        for i in 0...20 {
            yearData.append(String(2019 + i))
        }
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        descriptionTextView.delegate = self
        
        if self.course != nil {
            nameTextField.text = course!.getName()
            updateNameCounterLabel()
            semesterLabel.text = course!.getSemester()
            let parts = course!.getSemester().components(separatedBy: " ")
            semesterPicker.selectRow(semesterData.index(of: parts[0]) ?? 0, inComponent: 0, animated: false)
            semesterPicker.selectRow(yearData.index(of: parts[1]) ?? 0, inComponent: 1, animated: false)
            descriptionTextView.text = course!.getDescription()
            updateDescriptionConterLabel()
            placeholderLabel.isHidden = course!.getDescription().count > 0
        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        db = Firestore.firestore()
    }
    
    @objc func dismissKeyboard() {
        view.removeGestureRecognizer(tap)
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNameCounterLabel()
    }
    
    func updateNameCounterLabel() {
        nameCounterLabel.text = "\(nameTextField.text!.count)/\(nameMaxLength)"
        if nameTextField.text!.count <= nameMaxLength{
            self.nameCounterLabel.textColor = .lightGray
        } else {
            self.nameCounterLabel.textColor = .red
        }
    }
    
    func updateDescriptionConterLabel() {
        descriptionCounterLabel.text = "\(descriptionTextView.text.count)/\(descriptionMaxLength)"
        descriptionCounterLabel.textColor = descriptionTextView.text.count > descriptionMaxLength ? .red : .lightGray
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isCreate {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        if indexPath == [0, 1] {
            isEditingSemester = !isEditingSemester
            UIView.animate(withDuration: 0.2) {
                self.semesterArrow.transform = self.semesterArrow.transform.rotated(by: CGFloat.pi)
            }
            tableView.reloadRows(at: [[0, 2]], with: .none)
        } else if indexPath == [1, 0] {
            updateCourse()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0, 2] {
            return isEditingSemester ? 140 : 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}


extension EditCourseTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return semesterData.count
        } else{
            return yearData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return semesterData[row]
        } else {
            return yearData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let semester = semesterData[pickerView.selectedRow(inComponent: 0)]
        let year = yearData[pickerView.selectedRow(inComponent: 1)]
        self.semesterLabel.text = "\(semester) \(year)"
    }
}

extension EditCourseTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        view.removeGestureRecognizer(tap)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tap)
    }
}

extension EditCourseTVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = descriptionTextView.text.count > 0
        updateDescriptionConterLabel()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.addGestureRecognizer(tap)
    }
}
