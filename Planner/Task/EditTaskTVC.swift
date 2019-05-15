//
//  EditTaskTVC.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditTaskTVC: UITableViewController {
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameCounterLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var deadlineArrow: UIImageView!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationArrow: UIImageView!
    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var descriptionCounterLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var prioritySlider: UISlider!
    @IBOutlet weak var priorityLabel: UILabel!
    
    var isCreate = false
    var isDisplayable = false
    var task: Task!
    
    let nameMaxLength = 40
    let descriptionMaxLength = 1000
    var isEditingDeadline = false
    var isEditingDuration = false
    
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
            createTask()
        } else {
            updateTask()
        }
    }
    
    @IBAction func deadlineChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        self.deadlineLabel.text = formatter.string(from: deadlinePicker.date)
    }
    
    @IBAction func priorityChanged(_ sender: UISlider) {
        (self.task as! DisplayableTask).setPriority(priority: Int(prioritySlider.value))
        priorityLabel.text = String(Int(prioritySlider.value))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.groupTableViewBackground
        self.tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.db = Firestore.firestore()
        
        self.actionButton.title = isCreate ? "Create" : "Update"
        self.navigationItem.title = isCreate ? "Create Task" : "Edit Task"
        
        self.nameTextField.delegate = self
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.durationPicker.delegate = self
        self.durationPicker.dataSource = self
        self.descriptionTextView.delegate = self
        
        let duration = self.task.getDurationEstimate()
        self.nameTextField.text = self.task.getName()
        self.updateNameCounterLabel()
        self.deadlineLabel.text = self.task.getDeadlineString(format: "MM-dd-yyyy HH:mm")
        self.deadlinePicker.setDate(self.task.getDeadline(), animated: false)
        self.durationLabel.text = duration.toString()
        self.durationPicker.selectRow(duration.getDay(), inComponent: 0, animated: false)
        self.durationPicker.selectRow(duration.getHour(), inComponent: 1, animated: false)
        self.durationPicker.selectRow(duration.getMinute(), inComponent: 2, animated: false)
        self.descriptionTextView.text = self.task.getDescription()
        self.updateDescriptionConterLabel()
        self.placeholderLabel.isHidden = self.task.getDescription().count > 0
        
        if isDisplayable {
            let displayableTask = self.task as! DisplayableTask
            self.colorLabel.text = displayableTask.getColor().toHexString()
            self.colorView.layer.cornerRadius = self.colorView.bounds.height / 2
            self.colorView.backgroundColor = displayableTask.getColor()
            self.prioritySlider.setValue(Float(displayableTask.getPriority()), animated: false)
            self.priorityLabel.text = String(displayableTask.getPriority())
        }
    }
    
    @objc func dismissKeyboard() {
        view.removeGestureRecognizer(tap)
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateNameCounterLabel()
    }
    
    private func isValidTask() -> String? {
        let trimmedName = nameTextField.text!.trimmingCharacters(in: .whitespaces)
        if nameTextField.text!.count > nameMaxLength || trimmedName.count == 0 {
            return "Invalid task name"
        }
        let trimmedDescription = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
        if descriptionTextView.text.count > descriptionMaxLength || trimmedDescription.count == 0 {
            return "Invalid task description"
        }
        return nil
    }
    
    private func getJSON() -> [String: AnyObject] {
        let day = durationPicker.selectedRow(inComponent: 0)
        let hour = durationPicker.selectedRow(inComponent: 1)
        let minute = durationPicker.selectedRow(inComponent: 2)
        let duration = Duration(day: day, hour: hour, minute: minute, second: 0)
        self.task.setName(name: nameTextField.text!)
        self.task.setDeadline(deadline: deadlinePicker.date)
        self.task.setDurationEstimate(durationEstimate: duration)
        self.task.setDescription(description: descriptionTextView.text)
        
        if isDisplayable {
            return (self.task as! DisplayableTask).toJSON()
        } else {
            return (self.task as! CourseTask).toJSON()
        }
    }
    
    private func createTask() {
        let errorString = isValidTask()
        if errorString != nil {
            let alert = UIAlertController(title: "Error", message: errorString!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            let json = getJSON()
            let collectionName = isDisplayable ? "displayable_tasks" : "course_tasks"
            db.collection(collectionName).addDocument(data: json) {err in
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
    
    private func updateTask() {
        let errorString = isValidTask()
        if errorString != nil {
            let alert = UIAlertController(title: "Error", message: errorString!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        } else {
            let json = getJSON()
            let collectionName = isDisplayable ? "displayable_tasks" : "course_tasks"
            db.collection(collectionName).document(task.getID()!).setData(json) { (error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toColorPicker" {
            let vc = segue.destination as! ColorPickerVC
            vc.delegate = self
            vc.color = (self.task as! DisplayableTask).getColor()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isDisplayable {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        if indexPath == [0, 1] {
            isEditingDeadline = !isEditingDeadline
            UIView.animate(withDuration: 0.2) {
                self.deadlineArrow.transform = self.deadlineArrow.transform.rotated(by: CGFloat.pi)
            }
            tableView.reloadRows(at: [[0, 2]], with: .none)
        } else if indexPath == [0, 3] {
            isEditingDuration = !isEditingDuration
            UIView.animate(withDuration: 0.2) {
                self.durationArrow.transform = self.durationArrow.transform.rotated(by: CGFloat.pi)
            }
            tableView.reloadRows(at: [[0, 4]], with: .none)
        } else if indexPath == [1, 0] {
            self.performSegue(withIdentifier: "toColorPicker", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0, 2] {
            return isEditingDeadline ? 140 : 0
        } else if indexPath == [0, 4] {
            return isEditingDuration ? 140 : 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

}

extension EditTaskTVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 100
        } else if component == 1 {
            return 24
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            let day = pickerView.selectedRow(inComponent: 0)
            self.task.getDurationEstimate().setDay(day: day)
        } else if component == 1 {
            let hour = pickerView.selectedRow(inComponent: 1)
            self.task.getDurationEstimate().setHour(hour: hour)
        } else if component == 2 {
            let minute = pickerView.selectedRow(inComponent: 2)
            self.task.getDurationEstimate().setMinute(minute: minute)
        }
        self.durationLabel.text = self.task.getDurationEstimate().toString()
    }
}


extension EditTaskTVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        view.removeGestureRecognizer(tap)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        view.addGestureRecognizer(tap)
    }
}

extension EditTaskTVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = descriptionTextView.text.count > 0
        updateDescriptionConterLabel()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        view.addGestureRecognizer(tap)
    }
}

extension EditTaskTVC: ColorPickerVCDelegate {
    func colorIsChanged(color: UIColor) {
        self.colorView.backgroundColor = color
        self.colorLabel.text = color.toHexString()
        (self.task as! DisplayableTask).setColor(color: color)
    }
}
