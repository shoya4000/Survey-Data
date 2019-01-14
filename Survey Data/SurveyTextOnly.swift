//
//  SurveyTextOnly.swift
//  Survey Data
//
//  Created by Sandra Frey on 2017-07-11.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import Foundation
import MapKit

class SurveyTextOnly: NSObject {
    var historicSurvey: String
    var year: Int
    var stationName: String
    
    var repeatDate: NSDate
    var location: CLLocationCoordinate2D
    
    var allText: String

    
    init(SurveyName: String, Year: Int, StationName: String, RepeatDate: NSDate, Location: CLLocationCoordinate2D, AllText: String ) {
        self.historicSurvey = SurveyName
        self.year = Year
        self.stationName = StationName
        self.repeatDate = RepeatDate
        self.location = Location
        
        self.allText = AllText
    }
}
