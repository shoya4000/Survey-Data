//
//  SurveySaveList.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-08-30.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class SurveySaveList: NSObject, NSCoding {
    var surveyList = [String]()
    
    override init() {
        self.surveyList = []
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("SurveySaveList")
    
    struct PropertyKey {
        static let surveyList = "surveyList"
    }
    
    init(surveyList: [String]) {
        self.surveyList = surveyList
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(surveyList, forKey: PropertyKey.surveyList)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let surveyList = aDecoder.decodeObject(forKey: PropertyKey.surveyList) as? [String]
        self.init(surveyList: surveyList!)
    }
}
