//
//  User.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 19/02/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation
class User {
    var name: String
    var id: Int

    init(JsonData: NSDictionary) {
        self.name = JsonData["name"] as String
        self.id = JsonData["id"] as Int
    }
}