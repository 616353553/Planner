//
//  CourseTask.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

class CourseTask: Task {
    
    private var courseID: String!
    
    override init(id: String?, data: [String : AnyObject]) throws {
        try super.init(id: id, data: data)
        self.courseID = data["course_id"] as? String
    }
    
    init(courseID: String, owner: String, name: String, deadline: Date, durationEstimate: Duration, description: String, createDate: Date) {
        super.init(owner: owner,
                   name: name,
                   deadline: deadline,
                   durationEstimate: durationEstimate,
                   description: description,
                   createDate: createDate)
        self.courseID = courseID
    }
    
    func getCourseID() -> String {
        return courseID
    }
    
    override func toJSON() -> [String: AnyObject] {
        var data = super.toJSON()
        data["course_id"] = courseID as AnyObject
        return data
    }
}
