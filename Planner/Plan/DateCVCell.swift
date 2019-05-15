//
//  DateCVCell.swift
//  Planner
//
//  Created by bainingshuo on 4/22/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

class DateCVCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    private func setup() {
        dateLabel.text = ""
        dateLabel.textColor = .black
        bgView.layer.cornerRadius = 12
        bgView.backgroundColor = .white
    }
    
    func initialize(text: String, textColor: UIColor, bgColor: UIColor) {
        bgView.backgroundColor = bgColor
        dateLabel.text = text
        dateLabel.textColor = textColor
    }
}
