//
//  Venue.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 18/02/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation

class Venue {
    var name: String?
    var city: String?
    
    init(JsonData: NSDictionary) {
        self.name = JsonData["name"] as? String
        self.city = JsonData["city"] as? String
    }
}