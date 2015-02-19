//
//  SpecialityContribution.swift
//  TableWithSwift
//
//  Created by Joan Teixidó on 18/02/15.
//  Copyright (c) 2015 LaIogurtera. All rights reserved.
//

import Foundation
class SpecialityContribution
{
    var id: Int
    var comment: String
    var imageUrl: String
    var speciality: Speciality
    
    init(JsonData: NSDictionary) {
        self.id = JsonData["id"] as Int
        self.comment = JsonData["comment"] as String
        self.imageUrl = JsonData["image"] as String
        let specialityJson = JsonData["speciality"] as NSDictionary
        var speciality = Speciality(JsonData: specialityJson)
        self.speciality = speciality
    }

    class func contributionsWithJSON(allResults: NSArray) -> [SpecialityContribution] {
        var contributions = [SpecialityContribution]()
        if (allResults.count > 0) {
            for result in allResults {
                var specialityContribution = SpecialityContribution(JsonData: result as NSDictionary)
                contributions.append(specialityContribution)
            }
        }
        
        return contributions
    }
}

