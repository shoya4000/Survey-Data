//
//  LocationData.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import os.log

class LocationData: NSObject, NSCoding, NSCopying, Copying {
    
    // MARK: Properties
    
    var locationName: String
    var locationNarrative: String?
    var hasPhotos: Bool
    var locationPhotos: Array<UIImage>?
    
    struct PropertyKey {
        static let locationName = "locationName"
        static let locationNarrative = "locationNarrative"
        static let hasPhotos = "hasPhotos"
        static let locationPhotos = "locationPhotos"
    }
    
    override init() {
        self.locationName = "New Location"
        self.locationNarrative = "Enter Location Narrative here"
        self.hasPhotos = false
        self.locationPhotos = [UIImage(named: "no image selected")!,]
        
        super.init()
    }
    
    init?(locationName: String, locationNarrative: String?, locationPhotos: Array<UIImage>?) {
        
        // Initialization should fail if there is no location, originalPhotoNumber, or repeatPhotonumber.
        guard !locationName.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.locationName = locationName
        self.locationNarrative = locationNarrative
        self.locationPhotos = locationPhotos
        if locationPhotos == nil || locationPhotos?.count == 0 {
            hasPhotos = false
        }
        else {
            hasPhotos = true
        }
        super.init()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: PropertyKey.locationName)
        aCoder.encode(locationNarrative, forKey: PropertyKey.locationNarrative)
        aCoder.encode(hasPhotos, forKey: PropertyKey.hasPhotos)
        aCoder.encode(locationPhotos, forKey: PropertyKey.locationPhotos)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The location name is required. If we cannot decode it, the initializer should fail.
        guard let locationName = aDecoder.decodeObject(forKey: PropertyKey.locationName) as? String else {
            os_log("Unable to decode LocationData", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because the narrative and photos are optional, just use conditional cast.
        let locationNarrative = aDecoder.decodeObject(forKey: PropertyKey.locationNarrative) as? String
        let locationPhotos = aDecoder.decodeObject(forKey: PropertyKey.locationPhotos) as? Array<UIImage>
        
        self.init(locationName: locationName, locationNarrative: locationNarrative, locationPhotos: locationPhotos)
    }
    
    //MARK: NSCopying
    required init(copy:LocationData) {
        locationName = copy.locationName
        locationNarrative = copy.locationNarrative
        hasPhotos = copy.hasPhotos
        locationPhotos = copy.locationPhotos
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return LocationData(copy: self)
    }
}

//Protocal that copyable class should conform
protocol Copying {
    init(copy: Self)
}

//Concrete class extension
extension Copying {
    func copy() -> Self {
        return Self.init(copy: self)
    }
}

//Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
    func clone() -> Array {
        var copiedArray = Array<Element>()
        for element in self {
            copiedArray.append(element.copy())
        }
        return copiedArray
    }
    //https://gist.github.com/sohayb/4ba350f7e45c636cb3c9
}
