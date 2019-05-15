//
//  CourseTaskTVCell.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

class CourseTaskTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    
    var delegate: TaskTVCellDelegate!
    var indexPath: IndexPath!
    
    @IBAction func optionIsPushed(_ sender: UIButton) {
        self.delegate.optionButtonClicked(indexPath: indexPath)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }

    private func setup() {
        nameLabel.text = nil
        deadlineLabel.text = nil
        durationLabel.text = nil
        descriptionLabel.text = nil
        createDateLabel.text = nil
    }
    
    func initialize(name: String, deadline: String, duration: String, description: String, createDate: String, delegate: TaskTVCellDelegate, indexPath: IndexPath) {
        nameLabel.text = name
        deadlineLabel.text = deadline
        durationLabel.text = duration
        descriptionLabel.text = description
        createDateLabel.text = createDate
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
