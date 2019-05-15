//
//  EditTaskViewController.swift
//  Planner
//
//  Created by bainingshuo on 4/15/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation
import UIKit

class EditTaskViewController {
    
    var storyboard: UIStoryboard!
    var initialVC: EditTaskTVC!
    var parent: UIViewController!
    
    init(isCreate: Bool, isDisplayable: Bool, parent: UIViewController, task: Task) {
        let storyboard = UIStoryboard(name: "Task", bundle: nil)
        initialVC = storyboard.instantiateInitialViewController() as? EditTaskTVC
        initialVC.isCreate = isCreate
        initialVC.isDisplayable = isDisplayable
        initialVC.task = task
        self.parent = parent
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        let nc = UINavigationController()
        nc.addChild(initialVC)
        parent.present(nc, animated: animated, completion: completion)
    }
}
