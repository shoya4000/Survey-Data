//
//  RepeatImageData.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import os.log

class RepeatImageData: NSObject, NSCoding, NSCopying {
    
    //MARK: Properties
    
    var location: String
    var originalPhotoNumber: String
    var repeatPhotoNumber: String
    var azimuth: Double?
    var notes: String?
    
    struct PropertyKey {
        static let location = "location"
        static let originalPhotoNumber = "originalPhotoNumber"
        static let repeatPhotoNumber = "repeatPhotoNumber"
        static let azimuth = "azimuth"
        static let notes = "notes"
    }
    
    init?(location: String, originalPhotoNumber: String, repeatPhotoNumber: String, azimuth: Double?, notes: String?) {
        
        // Initialization should fail if there is no location, originalPhotoNumber, or repeatPhotonumber.
        guard !location.isEmpty || !originalPhotoNumber.isEmpty || !repeatPhotoNumber.isEmpty  else {
            return nil
        }
        
        // Initialize stored properties.
        self.location = location
        self.originalPhotoNumber = originalPhotoNumber
        self.repeatPhotoNumber = repeatPhotoNumber
        self.azimuth = azimuth
        self.notes = notes
        
        super.init()
    }

    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(originalPhotoNumber, forKey: PropertyKey.originalPhotoNumber)
        aCoder.encode(repeatPhotoNumber, forKey: PropertyKey.repeatPhotoNumber)
        aCoder.encode(azimuth, forKey: PropertyKey.azimuth)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The location, originalPhotoNumber, and repeatPhotoNumber are required. If we cannot decode them, the initializer should fail.
        guard let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String, let originalPhotoNumber = aDecoder.decodeObject(forKey: PropertyKey.originalPhotoNumber) as? String, let repeatPhotoNumber = aDecoder.decodeObject(forKey: PropertyKey.repeatPhotoNumber) as? String  else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode RepeatImageData", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        
        // Because the azimuth is optional, just use conditional cast.
        let azimuth = aDecoder.decodeObject(forKey: PropertyKey.azimuth) as? Double
        
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String
        
        self.init(location: location, originalPhotoNumber: originalPhotoNumber, repeatPhotoNumber: repeatPhotoNumber, azimuth: azimuth, notes: notes)
    }
    
    //MARK: NSCopying
    init(copy:RepeatImageData) {
        location = copy.location
        originalPhotoNumber = copy.originalPhotoNumber
        repeatPhotoNumber = copy.repeatPhotoNumber
        azimuth = copy.azimuth
        notes = copy.notes
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return RepeatImageData(copy: self)
    }
}
