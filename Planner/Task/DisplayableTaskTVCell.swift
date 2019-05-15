//
//  DisplayableTaskTVCell.swift
//  Planner
//
//  Created by bainingshuo on 4/27/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

class DisplayableTaskTVCell: UITableViewCell {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var createDataLabel: UILabel!
    
    private var indexPath: IndexPath!
    private var delegate: TaskTVCellDelegate!
    
    @IBAction func optionIsPushed(_ sender: UIButton) {
        self.delegate.optionButtonClicked(indexPath: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUp()
    }
    
    private func setUp() {
        self.colorView.layer.cornerRadius = colorView.frame.height / 2
        self.colorView.clipsToBounds = true
        self.colorView.backgroundColor = .black
        self.nameLabel.text = nil
        self.deadlineLabel.text = nil
        self.durationLabel.text = nil
        self.descriptionLabel.text = nil
        self.priorityLabel.text = nil
        createDataLabel.text = nil
        self.indexPath = nil
        self.delegate = nil
    }
    
    func initialize(color: UIColor, name: String, deadline: String, duration: String, description: String, priority: Int, createDate: String, delegate: TaskTVCellDelegate, indexPath: IndexPath) {
        self.colorView.backgroundColor = color
        self.nameLabel.text = name
        self.deadlineLabel.text = deadline
        self.durationLabel.text = duration
        self.descriptionLabel.text = description
        self.priorityLabel.text = String(priority)
        self.createDataLabel.text = createDate
        self.delegate = delegate
        self.indexPath = indexPath
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
