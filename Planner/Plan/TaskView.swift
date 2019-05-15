//
//  TaskView.swift
//  Planner
//
//  Created by bainingshuo on 4/22/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

protocol TaskViewDelegate {
    func taskIsTapped(task: DisplayableTask)
}

class TaskView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBAction func buttonIsPushed(_ sender: UIButton) {
        delegate.taskIsTapped(task: task)
    }
    
    private var delegate: TaskViewDelegate!
    private var task: DisplayableTask!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("TaskView", owner: self, options: nil)
        contentView.fixInView(self)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.contentView.backgroundColor = .white
        self.taskLabel.text = ""
        self.deadlineLabel.text = ""
        self.durationLabel.text = ""
    }
    
    func initialize(task: DisplayableTask, delegate: TaskViewDelegate) {
        self.contentView.backgroundColor = task.getColor()
        self.task = task
        self.delegate = delegate
        self.taskLabel.text = task.getName()
        self.deadlineLabel.text = task.getDeadlineString()
        self.durationLabel.text = task.getDurationEstimate().toString()
    }
    
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
