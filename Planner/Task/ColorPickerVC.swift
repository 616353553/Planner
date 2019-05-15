//
//  ColorPickerVC.swift
//  Planner
//
//  Created by bainingshuo on 4/29/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import UIKit

class ColorPickerVC: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var delegate: ColorPickerVCDelegate!
    var color: UIColor!
    var colorIndexPath: IndexPath!
    
    private let colors = [(246, 64, 44), (235, 19, 96), (156, 25, 176), (102, 51, 185), (61, 77, 183),
                          (70, 175, 74), (0, 150, 135), (0, 187, 213), (0, 166, 246), (16, 147, 245),
                          (136, 195, 64), (203, 221, 30), (255, 236, 21), (255, 193, 0), (255, 152, 0),
                          (0, 0, 0), (95, 124, 139), (157, 157, 157), (122, 85, 71), (255, 85, 3)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.layer.cornerRadius = colorView.bounds.height / 2
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        for (idx, color) in colors.enumerated() {
            let temp = UIColor(red: color.0, green: color.1, blue: color.2, alpha: 1.0)
            if temp.toHexString() == self.color.toHexString() {
                self.colorIndexPath = [0, idx]
                break
            }
        }
        colorView.backgroundColor = color
        colorLabel.text = color.toHexString()
        // Do any additional setup after loading the view.
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

extension ColorPickerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCVCell
        let color = UIColor(red: colors[indexPath.row].0,
                            green: colors[indexPath.row].1,
                            blue: colors[indexPath.row].2,
                            alpha: 1.0)
        cell.initialize(color: color, selected: indexPath == colorIndexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prevSelected = collectionView.cellForItem(at: colorIndexPath) as! ColorCVCell
        prevSelected.setSelected(selected: false)
        let currSelected = collectionView.cellForItem(at: indexPath) as! ColorCVCell
        currSelected.setSelected(selected: true)
        self.colorIndexPath = indexPath
        self.color = UIColor(red: colors[indexPath.row].0,
                            green: colors[indexPath.row].1,
                            blue: colors[indexPath.row].2,
                            alpha: 1.0)
        self.colorView.backgroundColor = self.color
        self.colorLabel.text = self.color.toHexString()
        delegate.colorIsChanged(color: self.color)
    }
}

extension ColorPickerVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let width = collectionViewWidth/5 - 12
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
