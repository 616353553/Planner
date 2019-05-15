//
//  Task.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

class Task {
    
    static var storageDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static var displayDateFormat = "yyyy-MM-dd HH:mm:ss"
    
    private var id: String?
    private var owner: String!
    private var name: String!
    private var deadline: Date!
    private var durationEstimate: Duration!
    private var description: String!
    private var createDate: Date!
    
    
    init(id: String?, data: [String: AnyObject]) throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Task.storageDateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        self.id = id
        self.owner = data["owner"] as? String
        self.name = data["name"] as? String
        self.deadline = dateFormatter.date(from: data["deadline"] as! String)!
        self.durationEstimate = try Duration(durationString: data["duration_estimate"] as! String)
        self.description = data["description"] as? String
        self.createDate = dateFormatter.date(from: data["create_date"] as! String)!
    }
    
    init(owner: String, name: String, deadline: Date, durationEstimate: Duration, description: String, createDate: Date) {
        self.owner = owner
        self.name = name
        self.deadline = deadline
        self.durationEstimate = durationEstimate
        self.description = description
        self.createDate = createDate
    }
    
    func isDue(compareTo currentDate: Date) -> Bool {
        return self.deadline <= currentDate
    }
    
    func getID() -> String? {
        return id
    }
    
    func getOwner() -> String {
        return owner
    }
    
    func getName() -> String {
        return name
    }
    
    func getDeadline() -> Date {
        return self.deadline
    }
    
    func getDeadlineString(format: String = Task.displayDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: deadline)
    }
    
    func getDurationEstimate() -> Duration {
        return self.durationEstimate
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getCreateDate() -> Date {
        return createDate
    }
    
    func getCreateDateString(format: String = Task.displayDateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: createDate)
    }
    
    func setDeadline(deadline: Date) {
        self.deadline = deadline
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setDurationEstimate(durationEstimate: Duration) {
        self.durationEstimate = durationEstimate
    }
    
    func toJSON() -> [String: AnyObject] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Task.storageDateFormat
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let data = ["owner": owner as AnyObject,
                    "name": name as AnyObject,
                    "deadline": dateFormatter.string(from: deadline) as AnyObject,
                    "duration_estimate": durationEstimate.toISO8601Duration() as AnyObject,
                    "description": description as AnyObject,
                    "create_date": dateFormatter.string(from: createDate) as AnyObject]
        return data
    }
    
}
