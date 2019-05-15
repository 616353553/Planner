//
//  DisplayableTask.swift
//  Planner
//
//  Created by bainingshuo on 4/22/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation
import UIKit

enum TaskType: String {
    case course
    case custom
}

class DisplayableTask: Task {
    
    private var id: String?
    private var timeFlags: [Date]?
    private var priority: Int!
    private var color: UIColor!
    private var originalTask: [String: AnyObject]!
    
    init(type: TaskType, owner: String, name: String, deadline: Date, durationEstimate: Duration, description: String, createDate: Date, priority: Int, color: UIColor, originalID: String? = nil) {
        super.init(owner: owner,
                   name: name,
                   deadline: deadline,
                   durationEstimate: durationEstimate,
                   description: description,
                   createDate: createDate)
        self.priority = priority
        self.color = color
        self.originalTask = ["type": type.rawValue as AnyObject]
        if originalID != nil {
            self.originalTask["id"] = originalID! as AnyObject
        }
    }
    
    override init(id: String?, data: [String: AnyObject]) throws {
        try super.init(id: id, data: data)
        self.priority = (data["priority"] as! Int)
        self.color = UIColor.init(hex: data["color"] as! String)
        self.originalTask = data["original_task"] as? [String: AnyObject]
    }
    
    func getTimeFlags() -> [Date]? {
        return timeFlags
    }
    
    func getPriority() -> Int {
        return priority
    }
    
    func getColor() -> UIColor {
        return color
    }
    
    func setPriority(priority: Int) {
        self.priority = priority
    }
    
    func setColor(color: UIColor) {
        self.color = color
    }
    
    func splitTask(before prevEndTime: Date) {
        var dates = [Date]()
        if prevEndTime > self.getDeadline() {
            dates.append(self.getDeadline())
        } else {
            dates.append(prevEndTime)
        }
        var duration = self.getDurationEstimate().toSecond()
        var endTime = Calendar.current.date(byAdding: .second, value: -1, to: prevEndTime)!
        while duration > 0 {
            var startTime = Calendar.current.startOfDay(for: endTime)
            let interval = endTime.timeIntervalSince(startTime)
            let seconds = Duration(interval: interval).toSecond() + 1
            if seconds <= duration {
                dates.append(startTime)
                duration -= seconds
                endTime = Calendar.current.date(byAdding: .second, value: -1, to: startTime)!
            } else {
                startTime = Calendar.current.date(byAdding: .second, value: -1 * duration + 1, to: endTime)!
                dates.append(startTime)
                duration = 0
            }
        }
        timeFlags = dates.reversed()
    }
    
    func intervalOn(date: Date) -> [Date]? {
        guard timeFlags != nil && timeFlags!.count > 0 else {
            return nil
        }
        var startTime = timeFlags![0]
        for i in 1..<timeFlags!.count {
            let endTime = timeFlags![i]
            if Calendar.current.isDate(date, inSameDayAs: startTime) {
                return [startTime, endTime]
            } else {
                startTime = endTime
            }
        }
        return nil
    }
    
    override func toJSON() -> [String : AnyObject] {
        var data = super.toJSON()
        data["color"] = self.color.toHexString() as AnyObject
        data["priority"] = self.priority as AnyObject
        data["original_task"] = self.originalTask as AnyObject
        return data
    }
}

extension DisplayableTask: Comparable {
//    static func < (lhs: DisplayableTask, rhs: DisplayableTask) -> Bool {
//        if lhs.getDeadline() < rhs.getDeadline() {
//            return false
//        } else if (lhs.getDeadline() > rhs.getDeadline()) {
//            return true
//        } else {
//            return lhs.priority < rhs.priority
//        }
//    }

    static func < (lhs: DisplayableTask, rhs: DisplayableTask) -> Bool {
        if lhs.getDeadline() < rhs.getDeadline() {
            return true
        } else if (lhs.getDeadline() > rhs.getDeadline()) {
            return false
        } else {
            return lhs.priority < rhs.priority
        }
    }
    
    static func == (lhs: DisplayableTask, rhs: DisplayableTask) -> Bool {
        return lhs.getDeadline() == rhs.getDeadline() && lhs.priority == rhs.priority
    }
}
