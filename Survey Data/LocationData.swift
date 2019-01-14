//
//  LocationData.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import os.log
import MapKit

class LocationData: NSObject, NSCoding, NSCopying, Copying {
    
    // MARK: Properties
    
    var locationName: String
    var locationNarrative: String?
    var elevation: Double?
    var gps: CLLocationCoordinate2D?
    var hasPhotos: Bool
    //var locationPhotos: Array<UIImage>?
    var locationPhotosAsData = [Data?]()
    
    struct PropertyKey {
        static let locationName = "locationName"
        static let locationNarrative = "locationNarrative"
        static let elevation = "elevation"
        static let gpsLat = "gpsLat"
        static let gpsLon = "gpsLon"
        static let hasPhotos = "hasPhotos"
        //static let locationPhotos = "locationPhotos"
        static let locationPhotosAsData = "locationPhotosAsData"
    }
    
    override init() {
        self.locationName = "New Location"
        self.locationNarrative = "Enter Location Narrative here"
        self.elevation = Double()
        self.gps = CLLocationCoordinate2D()
        self.hasPhotos = false
        //self.locationPhotos = [UIImage(named: "no image selected")!,]
        self.locationPhotosAsData = [UIImage(named: "no image selected")!.jpegData(compressionQuality: 0.10)!]
        
        super.init()
    }
    
    init?(locationName: String, locationNarrative: String?, elevation: Double?, gps: CLLocationCoordinate2D?, /*locationPhotos: Array<UIImage>?,*/ locationPhotosAsData: Array<Data?>) {
        
        // Initialization should fail if there is no location, originalPhotoNumber, or repeatPhotonumber.
        guard !locationName.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.locationName = locationName
        self.locationNarrative = locationNarrative
        self.elevation = elevation
        self.gps = gps
        //self.locationPhotos = locationPhotos
        /*for locationPhoto in locationPhotos!{
            self.locationPhotosAsData.append(UIImageJPEGRepresentation(locationPhoto, 0.25))
        }
        if locationPhotos == nil || locationPhotos?.count == 0 {
            hasPhotos = false
        }
        else {
            hasPhotos = true
        }*/
        if !locationPhotosAsData.isEmpty && locationPhotosAsData[0] == UIImage(named: "no image selected")!.jpegData(compressionQuality: 0.10) {
            hasPhotos = false
        }
        else{
            hasPhotos = true
        }
        self.locationPhotosAsData = locationPhotosAsData
        super.init()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(locationName, forKey: PropertyKey.locationName)
        aCoder.encode(locationNarrative, forKey: PropertyKey.locationNarrative)
        aCoder.encode(Double(elevation!), forKey: PropertyKey.elevation)
        aCoder.encode(Double((gps?.latitude)!), forKey: PropertyKey.gpsLat)
        aCoder.encode(Double((gps?.longitude)!), forKey: PropertyKey.gpsLon)
        aCoder.encode(hasPhotos, forKey: PropertyKey.hasPhotos)
        //aCoder.encode(locationPhotos, forKey: PropertyKey.locationPhotos)
        aCoder.encode(locationPhotosAsData, forKey: PropertyKey.locationPhotosAsData)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The location name is required. If we cannot decode it, the initializer should fail.
        guard let locationName = aDecoder.decodeObject(forKey: PropertyKey.locationName) as? String else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode LocationData", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        
        // Because the narrative and photos are optional, just use conditional cast.
        let locationNarrative = aDecoder.decodeObject(forKey: PropertyKey.locationNarrative) as? String
        //let locationPhotos = aDecoder.decodeObject(forKey: PropertyKey.locationPhotos) as? Array<UIImage>
        
        //all is now saving as data, JPEGs at 10% resolution. Figure out how to have only that used, and not the giant images.....
        var locationPhotosAsData = [Data?]()
        if aDecoder.decodeObject(forKey: PropertyKey.locationPhotosAsData) != nil{
            locationPhotosAsData = aDecoder.decodeObject(forKey: PropertyKey.locationPhotosAsData) as! Array<Data?>
        }
        let elevation = aDecoder.decodeDouble(forKey: PropertyKey.elevation)
        var gps = CLLocationCoordinate2D()
        gps.latitude = aDecoder.decodeDouble(forKey: PropertyKey.gpsLat)
        gps.longitude = aDecoder.decodeDouble(forKey: PropertyKey.gpsLon)
        
        self.init(locationName: locationName, locationNarrative: locationNarrative, elevation: elevation, gps: gps, /*locationPhotos: locationPhotos,*/ locationPhotosAsData: locationPhotosAsData)
    }
    
    //MARK: NSCopying
    required init(copy:LocationData) {
        locationName = copy.locationName
        locationNarrative = copy.locationNarrative
        elevation = copy.elevation
        gps = copy.gps
        hasPhotos = copy.hasPhotos
        //locationPhotos = copy.locationPhotos
        locationPhotosAsData = copy.locationPhotosAsData
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
