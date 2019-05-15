//
//  EditCourseViewController.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation
import UIKit

class EditCourseViewController {
    
    var storyboard: UIStoryboard!
    var initialVC: EditCourseTVC!
    var parent: UIViewController!
    
    init(isCreate: Bool, parent: UIViewController, course: Course?) {
        let storyboard = UIStoryboard(name: "Course", bundle: nil)
        initialVC = storyboard.instantiateInitialViewController() as? EditCourseTVC
        initialVC.isCreate = isCreate
        initialVC.course = course
        self.parent = parent
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        let nc = UINavigationController()
        nc.addChild(initialVC)
        parent.present(nc, animated: animated, completion: completion)
    }
}
