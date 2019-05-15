//
//  Course.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

class Course {
    
    static var dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    private var id: String!
    private var name: String!
    private var owner: String!
    private var semester: String!
    private var description: String!
    private var createDate: Date!
    private var taskIDs: [String]?
    private var tasks: [Task]?
    
    init(id: String, data: [String: AnyObject]) {
        self.id = id
        self.name = data["name"] as? String
        self.owner = data["owner"] as? String
        self.semester = data["semester"] as? String
        self.description = data["description"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Course.dateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        self.createDate = dateFormatter.date(from: data["create_date"] as! String)!
    }
    
    init(name: String, owner: String, semester: String, description: String, createDate: Date) {
        self.name = name
        self.owner = owner
        self.semester = semester
        self.description = description
        self.createDate = createDate
    }
    
    public func getID() -> String {
        return id
    }
    
    public func getName() -> String {
        return name
    }
    
    public func getOwner() -> String {
        return owner
    }
    
    public func getSemester() -> String {
        return semester
    }
    
    public func getDescription() -> String {
        return description
    }
    
    public func getCreateDate() -> Date {
        return createDate
    }
    
    public func getCreateDateString(format: String = "MM-dd-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self.createDate)
    }
    
    public func toJSON() -> [String: AnyObject] {
        let formatter = DateFormatter()
        formatter.dateFormat = Course.dateFormat
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = formatter.string(from: self.createDate)
        let data = ["name": name as AnyObject,
                    "owner": owner as AnyObject,
                    "semester": semester as AnyObject,
                    "description": description as AnyObject,
                    "create_date": dateString as AnyObject]
        return data
    }
}
