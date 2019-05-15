//
//  Duration.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

enum DurationError: Error {
    case invalidDurationString
}

class Duration {
    
    private var day = 0
    private var hour = 0
    private var minute = 0
    private var second = 0
    
    init(day: Int, hour: Int, minute: Int, second: Int) {
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    init(durationString: String) throws {
        if durationString.prefix(1) != "P" {
            throw DurationError.invalidDurationString
        }
        let regex = try! NSRegularExpression(pattern: "[0-9]+[DHMS]")
        _ = regex.matches(in: durationString, options: [], range: NSRange(location: 0, length: durationString.count)).map {
            let part = (durationString as NSString).substring(with: $0.range)
            let value = Int(part.prefix(part.count - 1))!
            let type = part.suffix(1)
            switch type {
            case "D":
                day = value
            case "H":
                hour = value
            case "M":
                minute = value
            case "S":
                second = value
            default:
                break
            }
        }
    }
    
    init(interval: TimeInterval) {
        let ti = NSInteger(interval)
        self.hour = (ti / 3600)
        self.minute = (ti / 60) % 60
        self.second = ti % 60
    }
    
    func getDay() -> Int {
        return day
    }
    
    func getHour() -> Int {
        return hour
    }
    
    func getMinute() -> Int {
        return minute
    }
    
    func setDay(day: Int) {
        self.day = day
    }
    
    func setHour(hour: Int) {
        self.hour = hour
    }
    
    func setMinute(minute: Int) {
        self.minute = minute
    }
    
    func toSecond() -> Int {
        return 86400 * day + 3600 * hour + 60 * minute + second
    }
    
    func toISO8601Duration() -> String {
        let day_str = (day == 0) ? "" : "\(day)D"
        let hour_str = (hour == 0) ? "" : "\(hour)H"
        let minute_str = (minute == 0) ? "" : "\(minute)M"
        let second_str = (second == 0) ? "" : "\(second)S"
        return "P\(day_str)\(hour_str)\(minute_str)\(second_str)"
    }
    
    func toString() -> String {
        var result = ""
        if self.day != 0 {
            result += "\(self.day) Day "
        }
        if self.hour != 0 {
            result += "\(self.hour) Hour "
        }
        if self.minute != 0 {
            result += "\(self.minute) Min"
        }
        return result
    }
    
}


extension Duration: Comparable {
    static func < (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.toSecond() < rhs.toSecond()
    }
    
    static func == (lhs: Duration, rhs: Duration) -> Bool {
        return lhs.toSecond() == rhs.toSecond()
    }
}
