//
//  Task.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

class CustomTask: Task {

//    private var owner: String!
//
//    override init(id: String, data: [String: AnyObject]) throws {
//        try super.init(id: id, data: data)
//        self.owner = (data["owner"] as! String)
//    }
//
//    init(name: String, owner: String, deadline: Date, durationEstimate: Duration, description: String, createDate: Date) {
//        super.init(type: TaskType.custom,
//                   name: name,
//                   deadline: deadline,
//                   durationEstimate: durationEstimate,
//                   description: description,
//                   createDate: createDate)
//        self.owner = owner
//    }
//
//    func getOwner() -> String {
//        return self.owner
//    }
//
//    func setOwner(owner: String) {
//        self.owner = owner
//    }
//
//    override func toJSON() -> [String: AnyObject] {
//        var data = super.toJSON()
//        data["owner"] = owner as AnyObject
//        return data
//    }

}

//extension CustomTask: Comparable {
//    static func < (lhs: CustomTask, rhs: CustomTask) -> Bool {
//        if lhs.getDeadline() < rhs.getDeadline() {
//            return false
//        } else if (lhs.getDeadline() > rhs.getDeadline()) {
//            return true
//        } else {
//            return lhs.getPriority() < rhs.getPriority()
//        }
//    }
//
//    static func == (lhs: CustomTask, rhs: CustomTask) -> Bool {
//        return lhs.getDeadline() == rhs.getDeadline() && lhs.getPriority() == rhs.getPriority()
//    }
//}
