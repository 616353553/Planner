//
//  CourseTVCell.swift
//  Planner
//
//  Created by bainingshuo on 4/14/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

protocol CourseTVCellDelegate {
    func optionButtonClicked(indexPath: IndexPath)
}

class CourseTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateHeaderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    @IBAction func optionIsPushed(_ sender: UIButton) {
        self.delegate.optionButtonClicked(indexPath: indexPath)
    }
    
    var delegate: CourseTVCellDelegate!
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    func initialize(name: String, semester: String, description: String, date: String, indexPath: IndexPath, delegate: CourseTVCellDelegate) {
        self.nameLabel.text = name
        self.semesterLabel.text = semester
        self.descriptionLabel.text = description
        self.dateLabel.text = date
        self.indexPath = indexPath
        self.delegate = delegate
    }
    
    private func setup() {
        nameLabel.text = nil
        semesterLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
//
//    func hideDateLabel(isHidden: Bool) {
//        dateHeaderLabel.isHidden = isHidden
//        dateLabel.isHidden = isHidden
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
