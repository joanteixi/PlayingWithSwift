//
//  Speciality.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 18/02/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation
class Speciality
{
    var name: String
    var mainContribution: SpecialityContribution?
    var venue: Venue

    init(JsonData: NSDictionary)
    {
        self.name = JsonData["name"] as String
        self.mainContribution? = JsonData["maincontribution"] as NSDictionary
        

        
        //venue
        let venueJson = JsonData["venue"] as NSDictionary
        self.venue = Venue(JsonData: venueJson)
    }
}