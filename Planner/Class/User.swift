//
//  User.swift
//  Planner
//
//  Created by Ningshuo Bai on 4/8/19.
//  Copyright © 2019 Ningshuo Bai. All rights reserved.
//

import Foundation

class User {
    
    private var id: String!
    private var name: String!
    
    init(data: [String: AnyObject]) {
        self.name = data["name"] as? String
    }
}
