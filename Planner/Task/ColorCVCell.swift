//
//  ColorCVCell.swift
//  Planner
//
//  Created by bainingshuo on 4/29/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

class ColorCVCell: UICollectionViewCell {
    
    @IBOutlet weak var checkmarkVIew: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUp()
    }
    
    private func setUp() {
        self.bgView.backgroundColor = .white
        self.bgView.layer.cornerRadius = self.bgView.frame.height / 2
        self.bgView.clipsToBounds = true
        self.checkmarkVIew.isHidden = true
    }
    
    func initialize(color: UIColor, selected: Bool) {
        self.bgView.backgroundColor = color
        self.checkmarkVIew.isHidden = !selected
    }
    
    func setSelected(selected: Bool) {
        self.checkmarkVIew.isHidden = !selected
    }
}
