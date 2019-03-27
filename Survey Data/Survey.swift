//
//  Survey.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import MapKit
import os.log

class Survey: NSObject, NSCoding {
    
    //MARK: Historic Data
    
    var historicSurvey: String
    var year: Int
    var stationName: String
    
    //MARK: Repeat Data
    
    var repeatDate: NSDate?
    var finishTime: NSDate?
    var location: CLLocationCoordinate2D?
    
    //MARK: Party Info
    
    var hikingParty: Array<String>?
    var pilot: String?
    var rwCallSign: String?
    
    // MARK: Weather Data
    
    var averageWindSpeed: Double?
    var temperature: Double?
    var barometricPressure: Double?
    var maximumGustSpeed: Double?
    var relativeHumidity: Double?
    var wetBulbReading: Double?
    
    // MARK: Camera Info
    
    var iPad: Bool?
    var locOther: String?
    var camera1: Bool?
    var camera2: Bool?
    var camOther: String?
    
    // MARK: Elevation Info
    var elevationMetres: Double?
    var elevationComments: String?
    
    // MARK: Repeat Image Data
    
    var cardNumber: Int?
    var gpsActive: Bool?
    var repeatImages: Array<RepeatImageData>?
    
    //MARK: Station Narrative
    var stationNarrative: String?
    var illustration: Bool?
    var illustrationImage: UIImage?
    var illustrationImageAsData: Data?
    
    //MARK: Weather Narrative
    var weatherNarrative: String?
    
    //MARK: Station Keywords
    
    var keywords: Array<KeywordData>?
    
    // MARK: Locations
    
    var locationsData: Array<LocationData>?
    
    // MARK: Author and Photographer
    
    var author: String?
    var photographer: String?
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("surveys")
    
    // MARK: Empty Initialization
    override init() {
        self.historicSurvey = "New Survey"
        self.year = 1900
        self.stationName = "Station Name"
        self.repeatDate = NSDate()
        
        self.location = CLLocationCoordinate2D()
        
        self.iPad = false
        self.camera1 = false
        self.camera2 = false
        self.gpsActive = false
        self.illustration = false
    }
    
    //MARK: Types
    
    struct PropertyKey {
        static let historicSurvey = "historicSurvey"
        static let year = "year"
        static let stationName = "stationName"
        
        //MARK: Repeat Data
        
        static let repeatDate = "repeatDate"
        static let finishTime = "finishTime"
        static let locationLat = "locationLat"
        static let locationLon = "locationLon"
        
        //MARK: Party Info
        
        static let hikingParty = "hikingParty"
        static let pilot = "pilot"
        static let rwCallSign = "rwCallSign"
        
        // MARK: Weather Data
        
        static let averageWindSpeed = "averageWindSpeed"
        static let temperature = "temperature"
        static let barometricPressure = "barometricPressure"
        static let maximumGustSpeed = "maximumGustSpeed"
        static let relativeHumidity = "relativeHumidity"
        static let wetBulbReading = "wetBulbReading"
        
        // MARK: Camera Info
        
        static let iPad = "iPad"
        static let locOther = "locOther"
        static let camera1 = "camera1"
        static let camera2 = "camera2"
        static let camOther = "camOther"
        
        // MARK: Elevation Info
        static let elevationMetres = "elevationMetres"
        static let elevationComments = "elevationComments"
        
        // MARK: Repeat Image Data
        
        static let cardNumber = "cardNumber"
        static let gpsActive = "gpsActive"
        static let repeatImages = "repeatImages"
        
        //MARK: Station Narrative
        static let stationNarrative = "stationNarrative"
        static let illustration = "illustration"
        static let illustrationImage = "illustrationImage"
        static let illustrationImageAsData = "illustrationImageAsData"
        
        //MARK: Weather Narrative
        static let weatherNarrative = "weatherNarrative"
        
        //MARK: Station Keywords
        
        static let keywords = "keywords"
        
        // MARK: Locations
        
        static let locationsData = "locationData"
        
        // MARK: Author and Photographer
        
        static let author = "author"
        static let photographer = "photographer"
    }
    
    //MARK: Initialize with values
    init(SurveyName: String, Year: Int, StationName: String) {
        self.historicSurvey = SurveyName
        self.year = Year
        self.stationName = StationName
        self.repeatDate = NSDate()
        
        self.location = CLLocationCoordinate2D()
        
        self.iPad = false
        self.camera1 = false
        self.camera2 = false
        self.gpsActive = false
        self.illustration = false
    }
    
    //MARK: Initialize with all values
    init(historicSurvey: String, year: Int, stationName: String, repeatDate: NSDate?, finishTime: NSDate?, location: CLLocationCoordinate2D?, hikingParty: Array<String>?, pilot: String?, rwCallSign: String?, averageWindSpeed: Double?, temperature: Double?, barometricPressure: Double?, maximumGustSpeed: Double?, relativeHumidity: Double?, wetBulbReading: Double?, iPad: Bool?, locOther: String?, camera1: Bool?, camera2: Bool?, camOther: String?, elevationMetres: Double?, elevationComments: String?, cardNumber: Int?, gpsActive: Bool?, repeatImages: Array<RepeatImageData>?, stationNarrative: String?, illustration: Bool?, illustrationImage: UIImage?, illustrationImageAsData: Data?, weatherNarrative: String?, keywords: Array<KeywordData>?, locationsData: Array<LocationData>?, author: String?, photographer: String?) {
        self.historicSurvey = historicSurvey
        self.year = year
        self.stationName = stationName
        
        self.repeatDate = repeatDate
        self.finishTime = finishTime
        self.location = location
        
        self.hikingParty = hikingParty
        self.pilot = pilot
        self.rwCallSign = rwCallSign
        
        self.averageWindSpeed = averageWindSpeed
        self.temperature = temperature
        self.barometricPressure = barometricPressure
        self.maximumGustSpeed = maximumGustSpeed
        self.relativeHumidity = relativeHumidity
        self.wetBulbReading = wetBulbReading
        
        self.iPad = iPad
        self.locOther = locOther
        self.camera1 = camera1
        self.camera2 = camera2
        self.camOther = camOther
        
        self.elevationMetres = elevationMetres
        self.elevationComments = elevationComments
        
        self.cardNumber = cardNumber
        self.gpsActive = gpsActive
        self.repeatImages = repeatImages
        
        self.stationNarrative = stationNarrative
        self.illustration = illustration
        self.illustrationImage = illustrationImage
        self.illustrationImageAsData = illustrationImageAsData
        
        self.weatherNarrative = weatherNarrative
        
        self.keywords = keywords
        self.locationsData = locationsData

        self.author = author
        self.photographer = photographer
        
    }
    
    //MARK: Initialize a copy
    init(copy:Survey) {
        //MARK: Historic Data
        
        historicSurvey = copy.historicSurvey
        year = copy.year
        stationName = copy.stationName
        
        //MARK: Repeat Data
        
        repeatDate = copy.repeatDate
        finishTime = copy.finishTime
        location = copy.location
        
        //MARK: Party Info
        
        hikingParty = copy.hikingParty
        pilot = copy.pilot
        rwCallSign = copy.rwCallSign
        
        // MARK: Weather Data
        
        averageWindSpeed = copy.averageWindSpeed
        temperature = copy.temperature
        barometricPressure = copy.barometricPressure
        maximumGustSpeed = copy.maximumGustSpeed
        relativeHumidity = copy.relativeHumidity
        wetBulbReading = copy.wetBulbReading
        
        // MARK: Camera Info
        
        iPad = copy.iPad
        locOther = copy.locOther
        camera1 = copy.camera1
        camera2 = copy.camera2
        camOther = copy.camOther
        
        //MARK: Elevation data
        elevationMetres = copy.elevationMetres
        elevationComments = copy.elevationComments
        
        // MARK: Repeat Image Data
        
        cardNumber = copy.cardNumber
        gpsActive = copy.gpsActive
        repeatImages = copy.repeatImages
                
        //MARK: Station Narrative
        stationNarrative = copy.stationNarrative
        illustration = copy.illustration
        illustrationImage = copy.illustrationImage
        illustrationImageAsData = copy.illustrationImageAsData
        
        //MARK: Weather Narrative
        weatherNarrative = copy.weatherNarrative
        
        //MARK: Station Keywords
        
        keywords = copy.keywords
        
        // MARK: Locations
        
        locationsData = copy.locationsData?.clone()
        
        // MARK: Author and Photographer
        
        author = copy.author
        photographer = copy.photographer
    }
    
    //MARK: Allow copying survey
    func copySurvey() -> Survey {
        return Survey(copy: self)
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(historicSurvey, forKey: PropertyKey.historicSurvey)
        aCoder.encode(year, forKey: PropertyKey.year)
        aCoder.encode(stationName, forKey: PropertyKey.stationName)
        
        aCoder.encode(repeatDate, forKey: PropertyKey.repeatDate)
        aCoder.encode(finishTime, forKey: PropertyKey.finishTime)
    
        // Split up CLLocationCoordinates
        aCoder.encode(Double((location?.latitude)!), forKey: PropertyKey.locationLat)
        aCoder.encode(Double((location?.longitude)!), forKey: PropertyKey.locationLon)
        
        aCoder.encode(hikingParty, forKey: PropertyKey.hikingParty)
        aCoder.encode(pilot, forKey: PropertyKey.pilot)
        aCoder.encode(rwCallSign, forKey: PropertyKey.rwCallSign)
        
        if averageWindSpeed != nil {
            aCoder.encode(averageWindSpeed!, forKey: PropertyKey.averageWindSpeed)
        }
        if temperature != nil {
            aCoder.encode(temperature!, forKey: PropertyKey.temperature)
        }
        if barometricPressure != nil {
            aCoder.encode(barometricPressure!, forKey: PropertyKey.barometricPressure)
        }
        if maximumGustSpeed != nil {
            aCoder.encode(maximumGustSpeed!, forKey: PropertyKey.maximumGustSpeed)
        }
        if relativeHumidity != nil {
            aCoder.encode(relativeHumidity!, forKey: PropertyKey.relativeHumidity)
        }
        if wetBulbReading != nil {
            aCoder.encode(wetBulbReading!, forKey: PropertyKey.wetBulbReading)
        }
        
        aCoder.encode(iPad!, forKey: PropertyKey.iPad)
        aCoder.encode(locOther, forKey: PropertyKey.locOther)
        aCoder.encode(camera1!, forKey: PropertyKey.camera1)
        aCoder.encode(camera2!, forKey: PropertyKey.camera2)
        aCoder.encode(camOther, forKey: PropertyKey.camOther)
        
        if elevationMetres != nil {
            aCoder.encode(elevationMetres!, forKey: PropertyKey.elevationMetres)
        }
        aCoder.encode(elevationComments, forKey: PropertyKey.elevationComments)
        
        if cardNumber != nil {
            aCoder.encode(cardNumber!, forKey: PropertyKey.cardNumber)
        }
        aCoder.encode(gpsActive!, forKey: PropertyKey.gpsActive)
        aCoder.encode(repeatImages, forKey: PropertyKey.repeatImages)
        
        aCoder.encode(stationNarrative, forKey: PropertyKey.stationNarrative)
        aCoder.encode(illustration!, forKey: PropertyKey.illustration)
        aCoder.encode(illustrationImage, forKey: PropertyKey.illustrationImage)
        aCoder.encode(illustrationImageAsData, forKey: PropertyKey.illustrationImageAsData)
        
        aCoder.encode(weatherNarrative, forKey: PropertyKey.weatherNarrative)
        
        aCoder.encode(keywords, forKey: PropertyKey.keywords)
        
        aCoder.encode(locationsData, forKey: PropertyKey.locationsData)
        
        aCoder.encode(author, forKey: PropertyKey.author)
        aCoder.encode(photographer, forKey: PropertyKey.photographer)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The historicSurvey, year, and stationName are required. If we cannot decode them, the initializer should fail.
        guard let historicSurvey = aDecoder.decodeObject(forKey: PropertyKey.historicSurvey) as? String else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode Survey Name", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        let year = aDecoder.decodeInteger(forKey: PropertyKey.year) as Int
        if year == 0 {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode Survey Year", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        }
        guard let stationName = aDecoder.decodeObject(forKey: PropertyKey.stationName) as? String  else {
            if #available(iOS 10.0, *) {
                os_log("Unable to decode Station Name", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
            return nil
        }
        
        // Because the rest are optional, just use conditional cast.
        let repeatDate = aDecoder.decodeObject(forKey: PropertyKey.repeatDate) as? NSDate
        let finishTime = aDecoder.decodeObject(forKey: PropertyKey.finishTime) as? NSDate
        var location = CLLocationCoordinate2D()
        location.latitude = aDecoder.decodeDouble(forKey: PropertyKey.locationLat)
        location.longitude = aDecoder.decodeDouble(forKey: PropertyKey.locationLon)
        
        let hikingParty = aDecoder.decodeObject(forKey: PropertyKey.hikingParty) as? Array<String>
        let pilot = aDecoder.decodeObject(forKey: PropertyKey.pilot) as? String
        let rwCallSign = aDecoder.decodeObject(forKey: PropertyKey.rwCallSign) as? String
        
        let averageWindSpeed = aDecoder.decodeDouble(forKey: PropertyKey.averageWindSpeed)
        let temperature = aDecoder.decodeDouble(forKey: PropertyKey.temperature)
        let barometricPressure = aDecoder.decodeDouble(forKey: PropertyKey.barometricPressure)
        let maximumGustSpeed = aDecoder.decodeDouble(forKey: PropertyKey.maximumGustSpeed)
        let relativeHumidity = aDecoder.decodeDouble(forKey: PropertyKey.relativeHumidity)
        let wetBulbReading = aDecoder.decodeDouble(forKey: PropertyKey.wetBulbReading)
        
        let iPad = aDecoder.decodeBool(forKey: PropertyKey.iPad)
        let locOther = aDecoder.decodeObject(forKey: PropertyKey.locOther) as? String
        let camera1 = aDecoder.decodeBool(forKey: PropertyKey.camera1)
        let camera2 = aDecoder.decodeBool(forKey: PropertyKey.camera2)
        let camOther = aDecoder.decodeObject(forKey: PropertyKey.camOther) as? String
        
        let elevationMetres = aDecoder.decodeDouble(forKey: PropertyKey.elevationMetres)
        let elevationComments = aDecoder.decodeObject(forKey: PropertyKey.elevationComments) as? String
        
        
        let cardNumber = aDecoder.decodeInteger(forKey: PropertyKey.cardNumber)
        let gpsActive = aDecoder.decodeBool(forKey: PropertyKey.gpsActive)
        let repeatImages = aDecoder.decodeObject(forKey: PropertyKey.repeatImages) as? Array<RepeatImageData>
        
        let stationNarrative = aDecoder.decodeObject(forKey: PropertyKey.stationNarrative) as? String
        let illustration = aDecoder.decodeBool(forKey: PropertyKey.illustration)
        let illustrationImage = aDecoder.decodeObject(forKey: PropertyKey.illustrationImage) as? UIImage
        let illustrationImageAsData = aDecoder.decodeObject(forKey: PropertyKey.illustrationImageAsData) as? Data
        
        let weatherNarrative = aDecoder.decodeObject(forKey: PropertyKey.weatherNarrative) as? String
        
        let keywords = aDecoder.decodeObject(forKey: PropertyKey.keywords) as? Array<KeywordData>
        
        let locationsData = aDecoder.decodeObject(forKey: PropertyKey.locationsData) as? Array<LocationData>
        
        let author = aDecoder.decodeObject(forKey: PropertyKey.author) as? String
        let photographer = aDecoder.decodeObject(forKey: PropertyKey.photographer) as? String
        
        
        // Must call designated initializer.
        self.init(historicSurvey: historicSurvey, year: year, stationName: stationName, repeatDate: repeatDate, finishTime: finishTime, location: location, hikingParty: hikingParty, pilot: pilot, rwCallSign: rwCallSign, averageWindSpeed: averageWindSpeed, temperature: temperature, barometricPressure: barometricPressure, maximumGustSpeed: maximumGustSpeed, relativeHumidity: relativeHumidity, wetBulbReading: wetBulbReading, iPad: iPad, locOther: locOther, camera1: camera1, camera2: camera2, camOther: camOther, elevationMetres: elevationMetres, elevationComments: elevationComments, cardNumber: cardNumber, gpsActive: gpsActive, repeatImages: repeatImages, stationNarrative: stationNarrative, illustration: illustration, illustrationImage: illustrationImage, illustrationImageAsData: illustrationImageAsData, weatherNarrative: weatherNarrative, keywords: keywords, locationsData: locationsData, author: author, photographer: photographer)
    }
}
