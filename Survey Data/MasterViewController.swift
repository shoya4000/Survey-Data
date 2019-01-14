//
//  MasterViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-07.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import MapKit
import os.log

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var surveys = [Survey]()
    var surveysText = [SurveyTextOnly]()
    var selectedRow = 0
    var fromMap = false
    var goToMap = false
    var toShow = [SurveyTextOnly]()
    
    //MARK: Load in sample Survey
    private func loadSampleSurvey(){
        
        let dateFormatter = DateFormatter()
        
        let sample = Survey(SurveyName: "Bridgland Clearwater-Brazeau", Year: 1928, StationName: "492")
        let SampleRepeatDate = "11-08-2014 14:30"
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        sample.repeatDate = dateFormatter.date(from: SampleRepeatDate)! as NSDate
        let SampleFinishTime = "11-08-2014 15:30"
        sample.finishTime = dateFormatter.date(from: SampleFinishTime)! as NSDate
        sample.location = DMMtoDD(latDeg: 52, latMin: 21.378, latDir: "N", longDeg: 117, longMin: 13.677, longDir: "W")
        
        sample.hikingParty = ["Rick Arthur", "Vladka Lackova-Gat", "Tanya Taggart-Hodge"]
        sample.pilot = "Paul Kendall"
        sample.rwCallSign = "PTG"
        
        sample.averageWindSpeed = 2.0
        sample.temperature = 20.0
        sample.barometricPressure = 713.9
        sample.maximumGustSpeed = 5.4
        sample.relativeHumidity = 31.5
        sample.wetBulbReading = 10.7
        
        sample.locOther = "Tanya's iPhone, location camera's battery is dead"
        sample.camOther = "Nikon"
        
        sample.gpsActive = true
        let repeatImageData1 = RepeatImageData(location: "1", originalPhotoNumber: "P1040213", repeatPhotoNumber: "4912 - 4916", azimuth: 300, notes: "")
        let repeatImageData2 = RepeatImageData(location: "1", originalPhotoNumber: "P1040212", repeatPhotoNumber: "4917 - 4919", azimuth: 272, notes: "")
        let repeatImageData3 = RepeatImageData(location: "1", originalPhotoNumber: "P1040211", repeatPhotoNumber: "4920 - 4921", azimuth: 238, notes: "")
        let repeatImageData4 = RepeatImageData(location: "1", originalPhotoNumber: "P1040210", repeatPhotoNumber: "4922 - 4926", azimuth: 206, notes: "")
        let repeatImageData5 = RepeatImageData(location: "1", originalPhotoNumber: "pano 1 *", repeatPhotoNumber: "4927 - 4929", azimuth: 170, notes: "")
        let repeatImageData6 = RepeatImageData(location: "2", originalPhotoNumber: "pano 1 *", repeatPhotoNumber: "4930 - 4932", azimuth: 168, notes: "")
        let repeatImageData7 = RepeatImageData(location: "2", originalPhotoNumber: "pano 2 *", repeatPhotoNumber: "4933 - 4935", azimuth: 135, notes: "")
        let repeatImageData8 = RepeatImageData(location: "2", originalPhotoNumber: "P1040217", repeatPhotoNumber: "4936 - 4938", azimuth: 107, notes: "")
        let repeatImageData9 = RepeatImageData(location: "2", originalPhotoNumber: "P1040216", repeatPhotoNumber: "4939 - 4941", azimuth: 70, notes: "")
        let repeatImageData10 = RepeatImageData(location: "2", originalPhotoNumber: "P1040215", repeatPhotoNumber: "4942 - 4944", azimuth: 30, notes: "")
        let repeatImageData11 = RepeatImageData(location: "2", originalPhotoNumber: "P1040214", repeatPhotoNumber: "4945 - 4947", azimuth: 340, notes: "")
        sample.repeatImages = [repeatImageData1!, repeatImageData2!, repeatImageData3!, repeatImageData4!, repeatImageData5!, repeatImageData6!, repeatImageData7!, repeatImageData8!, repeatImageData9!, repeatImageData10!, repeatImageData11!]
        
        sample.stationNarrative = "PTG (Paul) dropped us off on a saddle to the south of the peak. We hiked up over a distinct rock formation, then continued along the ridge and up the scree slope to the highest point, giving us a 360° view. Total hiking time was one hour.\n* Hiking poles and helmets are advisable; we made a good use of ours. Some sections of the climb had the option of bouldering but the rock was crumbling and unstable.\nPerfect shooting conditions!\n* We were having lunch for an hour, and the hike up & back down was an hour each way.\n* We took the pano shots in order to complete the pano and have a view of the glacier to the southwest, which appears to be missing from Bridgland's photos that we currently have."
        sample.illustration = false
        
        sample.elevationMetres = 2863
        sample.elevationComments = "2,863 is according to kestrel; 3,025m according to GPS (more accurate)"
        //add elevation section?
        
        sample.weatherNarrative = "Blue skies, very gentle breeze, very few cirrus clouds in the distance (practically clear skies), warm sunny day."
        
        let keywordData1 = KeywordData(category: "Custom", keyword: "Granite", comment: "")
        let keywordData2 = KeywordData(category: "Custom", keyword: "Limestone", comment: "")
        let keywordData3 = KeywordData(category: "Custom", keyword: "Scree slope", comment: "")
        let keywordData4 = KeywordData(category: "Custom", keyword: "Rock Formation", comment: "")
        let keywordData5 = KeywordData(category: "9-Perennial Snow/Ice", keyword: "92-Glaciers", comment: "")
        let keywordData6 = KeywordData(category: "Custom", keyword: "Jasper National Park", comment: "")
        let keywordData7 = KeywordData(category: "Custom", keyword: "Alpine", comment: "")
        sample.keywords = [keywordData1!, keywordData2!, keywordData3!, keywordData4!, keywordData5!, keywordData6!, keywordData7!]
        
        //let location1Photos = [UIImage(named: "Stn_492Loc_1"), UIImage(named: "Stn_492_Loc1"), UIImage(named: "Stn_492_Loc_1")]
        let location1PhotosAsData = [UIImage(named: "Stn_492Loc_1")!.jpegData(compressionQuality: 0.10), UIImage(named:  "Stn_492_Loc1")!.jpegData(compressionQuality: 0.10), UIImage(named: "Stn_492_Loc_1")!.jpegData(compressionQuality: 0.10)]
        let gps1 = DMMtoDD(latDeg: 52, latMin: 21.378, latDir: "N", longDeg: 117, longMin: 13.677, longDir: "W")
        let locationData1 = LocationData(locationName: "1", locationNarrative: "Tripod is located on the northwest end of the peak ride, ~10m from the southeast edge. It is 1m from the drop in each direction.", elevation: 3021.0, gps: gps1, /*locationPhotos: location1Photos as? Array<UIImage>,*/ locationPhotosAsData: location1PhotosAsData as Array<Data?>)
        //let location2Photos = [UIImage(named: "Stn_492_Loc2"), UIImage(named: "Stn_492_Loc_2")]
        let location2PhotosAsData = [UIImage(named: "Stn_492_Loc2")!.jpegData(compressionQuality: 0.10), UIImage(named: "Stn_492_Loc_2")!.jpegData(compressionQuality: 0.10)]
        let gps2 = DMMtoDD(latDeg: 52, latMin: 21.373, latDir: "N", longDeg: 117, longMin: 13.672, longDir: "W")
        let locationData2 = LocationData(locationName: "2", locationNarrative: "Tripod was moved to the southeast edge, ~1m from the edge, ~10m from Loc.1", elevation: 3023.0, gps: gps2, /*locationPhotos: location2Photos as? Array<UIImage>, */locationPhotosAsData: location2PhotosAsData as Array<Data?>)
        sample.locationsData = [locationData1!, locationData2!]
        //Add lat and long for locations?
        
        sample.author = "Tanya Taggart-Hodge"
        sample.photographer = "Vladka Lackova-Gat"
        
        surveys += [sample]
    }
    
    //MARK: Actions
    @IBAction func unwindToMasterView(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? DetailViewController, let survey = sourceViewController.survey {
            tableView.selectRow(at: IndexPath(row: selectedRow, section: 0), animated: false, scrollPosition: .top)
            let selectedIndexPath = tableView.indexPathForSelectedRow
            // Update an existing survey.
            surveys[(selectedIndexPath?.row)!] = survey.copySurvey()
            tableView.reloadRows(at: [selectedIndexPath!], with: .none)
            // Save the surveys.
            saveSurveys()
            if sourceViewController.goToSurveyOnMap {
                goToMap = true
                toShow = [surveysText[(selectedIndexPath?.row)!]]
                performSegue(withIdentifier: "showMap", sender: self)
            }
        }
    }
    @IBAction func unwindToMasterViewFromMap(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? MapViewController {
            for (index, survey) in surveys.enumerated() {
                if survey == sourceViewController.subsetOfSurveys[0] {
                    selectedRow = index
                }
            }
            fromMap = true
            let indexPath = IndexPath(row: selectedRow, section: 0);
            performSegue(withIdentifier: "showSurvey", sender: self.tableView.cellForRow(at: indexPath))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load any saved surveys, otherwise load sample data.
        if let savedSurveys = loadSurveys() {
            surveys += savedSurveys
        }
        else {
            // Load the sample data.
            loadSampleSurvey()
        }
        
        //tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        //performSegue(withIdentifier: "showSurvey", sender: self)
        for survey in surveys {
            var allTextInSurvey = String()
            allTextInSurvey.append(survey.historicSurvey)
            allTextInSurvey.append(survey.stationName)
            allTextInSurvey.append("\(survey.year)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            allTextInSurvey.append(dateFormatter.string(from: survey.repeatDate! as Date))
            if survey.hikingParty != nil {
                for names in survey.hikingParty!{
                    allTextInSurvey.append(names)
                }
            }
            if survey.pilot != nil{
                allTextInSurvey.append(survey.pilot!)
            }
            if survey.rwCallSign != nil{
                allTextInSurvey.append(survey.rwCallSign!)
            }
            if survey.locOther != nil{
                allTextInSurvey.append(survey.locOther!)
            }
            if survey.camOther != nil{
                allTextInSurvey.append(survey.camOther!)
            }
            if survey.elevationComments != nil{
                allTextInSurvey.append(survey.elevationComments!)
            }
            if survey.repeatImages != nil{
                for repeatData in survey.repeatImages! {
                    allTextInSurvey.append(repeatData.location)
                    allTextInSurvey.append(repeatData.originalPhotoNumber)
                    allTextInSurvey.append(repeatData.repeatPhotoNumber)
                }
            }
            if survey.stationNarrative != nil{
                allTextInSurvey.append(survey.stationNarrative!)
            }
            if survey.weatherNarrative != nil{
                allTextInSurvey.append(survey.weatherNarrative!)
            }
            if survey.keywords != nil{
                for keyword in survey.keywords! {
                    allTextInSurvey.append(keyword.category)
                    allTextInSurvey.append(keyword.keyword)
                    if keyword.comment != nil{
                        allTextInSurvey.append(keyword.comment!)
                    }
                }
            }
            if survey.locationsData != nil{
                for locationData in survey.locationsData! {
                    allTextInSurvey.append(locationData.locationName)
                    if locationData.locationNarrative != nil{
                        allTextInSurvey.append(locationData.locationNarrative!)
                    }
                }
            }
            
            let surveyText = SurveyTextOnly(SurveyName: survey.historicSurvey, Year: survey.year, StationName: survey.stationName, RepeatDate: survey.repeatDate!, Location: survey.location!, AllText: allTextInSurvey)
            surveysText.append(surveyText)
        }
        
        performSegue(withIdentifier: "showMap", sender: self)
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewSurvey(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
            self.detailViewController?.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            self.detailViewController?.navigationItem.leftItemsSupplementBackButton = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func insertNewSurvey(_ sender: Any) {
        let newSurvey = Survey()
        surveys.insert(newSurvey, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "showSurvey":
                if fromMap {
                    let indexPath = IndexPath(row: selectedRow, section: 0)
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableView.ScrollPosition.none)
                    fromMap = false
                }
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let object = surveys[indexPath.row]
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object.historicSurvey
                }

                guard let DetailViewController = (segue.destination as! UINavigationController).topViewController as? DetailViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                if surveys.count == 1 {
                    let selectedSurvey = surveys[0]
                    DetailViewController.survey = selectedSurvey
                }
                else{
                    guard let selectedSurveyCell = sender as? SurveyTableViewCell else {
                        let selectedSurvey = surveys[0]
                        DetailViewController.survey = selectedSurvey
                        return
                    }
                    guard let indexPath = tableView.indexPath(for: selectedSurveyCell) else {
                         fatalError("The selected cell is not being displayed by the table")
                    }
                    
                    let selectedSurvey = surveys[indexPath.row]
                    selectedRow = indexPath.row
                    DetailViewController.survey = selectedSurvey
                }
                DetailViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                DetailViewController.navigationItem.leftItemsSupplementBackButton = true
            case "showMap":
                let mapViewController = (segue.destination as! UINavigationController).topViewController as! MapViewController
                mapViewController.surveysText = surveysText
                if goToMap == true{
                    mapViewController.subsetOfSurveys = toShow
                }
                else{
                    mapViewController.subsetOfSurveys = surveysText
                }
                
                mapViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                mapViewController.navigationItem.leftItemsSupplementBackButton = true
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return surveys.count
        }
        else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyTableViewCell", for: indexPath) as! SurveyTableViewCell

            let object = surveys[indexPath.row]
            cell.SurveyName.text = object.historicSurvey
            cell.Year.text = "\(object.year)"
            cell.Station.text = object.stationName
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.short
            cell.RepeatDate.text = dateFormatter.string(from: object.repeatDate! as Date)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapViewCell", for: indexPath) as! MapViewCell
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            surveys.remove(at: indexPath.row)
            saveSurveys()
            tableView.deleteRows(at: [indexPath], with: .fade)
            performSegue(withIdentifier: "showSurvey", sender: self)
        } else if editingStyle == .insert {
            debugPrint("editing selected")
        }
    }
    
    //MARK: Save Surveys
    private func saveSurveys() {
        //run this only once to convert all current saved surveys into their respective saved files
        //for survey in surveys.... NSKeyedArchiver.archiveRootObject....
        //after that, will only change an individual survey at a time
        //save one at a time
        //create one at a time
        //delete one at a time
        
        //perhaps for app as whole save array with the keys/filenames for the surveys in array to load them back later?
        //use repeatdate
        let surveyIDList = SurveySaveList()
        var index = 1
        for survey in surveys.reversed() {
            surveyIDList.surveyList.append(String(describing: survey.repeatDate))
            
            //and save all surveys as text files
            //method from https://www.hackingwithswift.com/example-code/strings/how-to-save-a-string-to-a-file-on-disk-with-writeto
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let repeatDate = formatter.string(from: survey.repeatDate! as Date)
            let filename = getDocumentsDirectory().appendingPathComponent("Survey#\(index)-\(repeatDate).txt")
            index += 1

            var allTextInSurvey = String()
            allTextInSurvey.append("Historic Survey: \(survey.historicSurvey)\n")
            allTextInSurvey.append("Station Name: \(survey.stationName)\n")
            allTextInSurvey.append("Year: \(survey.year)\n\n")
            formatter.dateFormat = "dd-MM-yyyy"
            allTextInSurvey.append("Repeat Date: \(formatter.string(from: survey.repeatDate! as Date))\n")
            formatter.dateFormat = "HH:mm"
            allTextInSurvey.append("Start Time: \(formatter.string(from: survey.repeatDate! as Date))\n")
            allTextInSurvey.append("Finish Time: ")
            if survey.finishTime != nil{
                allTextInSurvey.append(formatter.string(from: survey.finishTime! as Date))
            }
            allTextInSurvey.append("\nLocation:\n")
            if survey.location != nil{
                allTextInSurvey.append("\tLatitude: \(String(format: "%.5f", (survey.location?.latitude)!)) ")
                allTextInSurvey.append("\tLongitude: \(String(format: "%.5f", (survey.location?.longitude)!))")
            }
            allTextInSurvey.append("\n\nHiking Party: ")
            if survey.hikingParty != nil {
                for name in survey.hikingParty!{
                    allTextInSurvey.append("\(name), ")
                }
            }
            allTextInSurvey.append("\nPilot: ")
            if survey.pilot != nil{
                allTextInSurvey.append(survey.pilot!)
            }
            allTextInSurvey.append("\nR.W. Call Sign: ")
            if survey.rwCallSign != nil{
                allTextInSurvey.append(survey.rwCallSign!)
            }
            allTextInSurvey.append("\n\nWeather:\n\tAverage Wind Speed: ")
            if survey.averageWindSpeed != nil{
                allTextInSurvey.append(String(survey.averageWindSpeed!) + "km/h")
            }
            allTextInSurvey.append("\n\tTemperature: ")
            if survey.temperature != nil{
                allTextInSurvey.append(String(survey.temperature!) + "°C")
            }
            allTextInSurvey.append("\n\tBarometric Pressure: ")
            if survey.barometricPressure != nil{
                allTextInSurvey.append(String(survey.barometricPressure!) + "hPa")
            }
            allTextInSurvey.append("\n\tMaximum Gust Speed: ")
            if survey.maximumGustSpeed != nil{
                allTextInSurvey.append(String(survey.maximumGustSpeed!) + "km/h")
            }
            allTextInSurvey.append("\n\tRelative Humidity: ")
            if survey.relativeHumidity != nil{
                allTextInSurvey.append(String(survey.relativeHumidity!) + "%")
            }
            allTextInSurvey.append("\n\tWet Bulb Reading: ")
            if survey.wetBulbReading != nil{
                allTextInSurvey.append(String(survey.wetBulbReading!) + "°C")
            }
            allTextInSurvey.append("\n\nLocation Camera Unit: ")
            if survey.iPad != nil {
                if survey.iPad! {
                    allTextInSurvey.append("iPad")
                }
                else {
                    if survey.locOther != nil{
                        allTextInSurvey.append(survey.locOther!)
                    }
                }
            }
            allTextInSurvey.append("\nRepeat Camera Unit: ")
            if survey.camOther != nil{
                allTextInSurvey.append(survey.camOther!)
            }
            allTextInSurvey.append("\n\nElevation: ")
            if survey.elevationMetres != nil{
                allTextInSurvey.append(String(survey.elevationMetres!) + "m")
            }
            allTextInSurvey.append("\nElevation Comments: ")
            if survey.elevationComments != nil{
                allTextInSurvey.append(survey.elevationComments!)
            }
            allTextInSurvey.append("\n\nRepeat Image Data:\n\tCard Number: ")
            if survey.cardNumber != nil{
                allTextInSurvey.append(String(survey.cardNumber!))
            }
            allTextInSurvey.append("\n\tInternal GPS Active: ")
            if survey.gpsActive != nil{
                allTextInSurvey.append(String(survey.gpsActive!))
            }
            allTextInSurvey.append("\n\tRepeat Images: \n\t\t")
            if survey.repeatImages != nil{
                for repeatData in survey.repeatImages! {
                    allTextInSurvey.append("Location: \(repeatData.location)")
                    allTextInSurvey.append("\tOriginal Photo Number: \(repeatData.originalPhotoNumber)")
                    allTextInSurvey.append("\tRepeat Photo Number: \(repeatData.repeatPhotoNumber)")
                    allTextInSurvey.append("\tAzimuth: ")
                    if repeatData.azimuth != nil {
                        allTextInSurvey.append(String(repeatData.azimuth!) + "°")
                    }
                    allTextInSurvey.append("\tNotes: ")
                    if repeatData.notes != nil {
                        allTextInSurvey.append(repeatData.notes!)
                    }
                    allTextInSurvey.append("\n\t\t")
                }
            }
            allTextInSurvey.append("\nStation Narrative: ")
            if survey.stationNarrative != nil{
                allTextInSurvey.append(survey.stationNarrative!)
            }
            allTextInSurvey.append("\n\nWeather Narrative: ")
            if survey.weatherNarrative != nil{
                allTextInSurvey.append(survey.weatherNarrative!)
            }
            allTextInSurvey.append("\n\nKeywords:\n")
            if survey.keywords != nil{
                for keyword in survey.keywords! {
                    allTextInSurvey.append("\tCategory: \(keyword.category)")
                    allTextInSurvey.append("\tKeyword: \(keyword.keyword)")
                    allTextInSurvey.append("\tComment: ")
                    if keyword.comment != nil{
                        allTextInSurvey.append(keyword.comment!)
                    }
                    allTextInSurvey.append("\n")
                }
            }
            allTextInSurvey.append("\n\nLocations:\n")
            if survey.locationsData != nil{
                for locationData in survey.locationsData! {
                    allTextInSurvey.append("\tLocation Name: \(locationData.locationName)")
                    allTextInSurvey.append("\n\tLocation Narrative: ")
                    if locationData.locationNarrative != nil{
                        allTextInSurvey.append(locationData.locationNarrative!)
                    }
                    allTextInSurvey.append("\n\tElevation: ")
                    if locationData.elevation != nil{
                        allTextInSurvey.append(String(locationData.elevation!))
                    }
                    allTextInSurvey.append("\n\tGPS:\n")
                    if locationData.gps != nil{
                        allTextInSurvey.append("\t\tLatitude: \(String(format: "%.5f", (locationData.gps!.latitude))) ")
                        allTextInSurvey.append("\tLongitude: \(String(format: "%.5f", (locationData.gps!.longitude)))")
                    }
                    allTextInSurvey.append("\tHas Photos: \(String(locationData.hasPhotos))")
                    allTextInSurvey.append("\n")
                }
            }
            allTextInSurvey.append("\nAuthor: ")
            if survey.author != nil{
                allTextInSurvey.append(survey.author!)
            }
            allTextInSurvey.append("\nPhotographer: ")
            if survey.photographer != nil{
                allTextInSurvey.append(survey.photographer!)
            }
            
            do {
                try allTextInSurvey.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            }
        }
        var isSuccessfulSave = false
        isSuccessfulSave = NSKeyedArchiver.archiveRootObject(surveyIDList, toFile: SurveySaveList.ArchiveURL.path)
        for (index, surveyID) in surveyIDList.surveyList.enumerated() {
            let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
            let ArchiveURL = DocumentsDirectory.appendingPathComponent(surveyID)
            NSKeyedArchiver.archiveRootObject(surveys[index], toFile: ArchiveURL.path)
        }
        
        isSuccessfulSave = NSKeyedArchiver.archiveRootObject(surveys, toFile: Survey.ArchiveURL.path)
        
        if isSuccessfulSave {
            debugPrint("Surveys successfully saved")
            if #available(iOS 10.0, *) {
                os_log("Surveys successfully saved.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        } else {
            if #available(iOS 10.0, *) {
                os_log("Failed to save surveys...", log: OSLog.default, type: .error)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    //below from https://www.hackingwithswift.com/example-code/strings/how-to-save-a-string-to-a-file-on-disk-with-writeto
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    private func loadSurveys() -> [Survey]? {
        //load up from the array of saved surveys
        let surveyIDList = NSKeyedUnarchiver.unarchiveObject(withFile: SurveySaveList.ArchiveURL.path) as? SurveySaveList
        
        if surveyIDList != nil {
            debugPrint("Loading saved surveys")
            var allSurveys = [Survey]()
            for surveyID in ((surveyIDList?.surveyList)!) {
                let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
                let ArchiveURL = DocumentsDirectory.appendingPathComponent(surveyID)
                allSurveys.append((NSKeyedUnarchiver.unarchiveObject(withFile: ArchiveURL.path) as? Survey)!)
            }
            return allSurveys
        }
        else{
            debugPrint("no surveys saved yet")
            return NSKeyedUnarchiver.unarchiveObject(withFile: Survey.ArchiveURL.path) as? [Survey]
        }
        
        //to get Data from the app on an iPad:
        //1. Plug it into computer
        //2. In Xcode, go to Window
        //3. Select Devices
        //4. Select the device
        //5. Click the gear symbol and then download container
        
        //to see downloaded app data in simulator
        //1. navigate to ~/Library/Developer/CoreSimulator/Devices
        //2. Find the appropriate device (in the Device list in Xcode it will show the device name, a long complex string)
        //3. Under Data/Containers/Data/Application, find the app file which under its Documents folder has appropriate save data
        //4. Copy over the data from the Downloaded Container.
        //5. Run Simulator
        
        //Can see Sandra's iPad data on iPad Mini/iPad 2 simulator
        //Can see Eric's iPad data on iPad Pro (12.9 inch) (the one without the - ) Device: DE4E537B-1846-4EEC-A39D-332 Application: EAEAA97F-5BAB-4971-A6CA-090B8BFC9672
        
    }
}

//Extend CLLocationCoordinate2D to constantly keep track of minute and second values, as well as dms and dmm formats
extension CLLocationCoordinate2D {
    var latitudeMinutes:  Double { return (latitude * 3600).truncatingRemainder(dividingBy: 3600) / 60 }
    var latitudeSeconds:  Double { return ((latitude * 3600).truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60) }
    
    var longitudeMinutes: Double { return (longitude * 3600).truncatingRemainder(dividingBy: 3600) / 60 }
    var longitudeSeconds: Double { return ((longitude * 3600).truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60) }
    
    var dms:(latitude: String, longitude: String) {
        
        return (String(format:"%d°%d'%.1f\"%@",
                       Int(abs(latitude)),
                       Int(abs(latitudeMinutes)),
                       abs(latitudeSeconds),
                       latitude >= 0 ? "N" : "S"),
                String(format:"%d°%d'%.1f\"%@",
                       Int(abs(longitude)),
                       Int(abs(longitudeMinutes)),
                       abs(longitudeSeconds),
                       longitude >= 0 ? "E" : "W"))
    }
    
    var dmm: (latitude: String, longitude: String) {
        return (String(format:"%d°%.4f'%@",
                       Int(abs(latitude)),
                       abs(latitudeMinutes),
                       latitude >= 0 ? "N" : "S"),
                String(format:"%d°%.4f'%@",
                       Int(abs(longitude)),
                       abs(longitudeMinutes),
                       longitude >= 0 ? "E" : "W"))
    }
}

//Allow converstion from DMS to DD
func DMStoDD(latDeg: Double, latMin: Double, latSec: Double, latDir: String?, longDeg: Double, longMin: Double, longSec: Double, longDir: String?) -> CLLocationCoordinate2D {
    var latitude = CLLocationDegrees()
    if latDeg >= 0 {
        latitude = CLLocationDegrees(latDeg + ((latMin*60)/3600) + (latSec/3600))
        if latDir == "S" || latDir == "s" {latitude *= -1}
    }
    else {
        latitude = CLLocationDegrees((latDeg * -1) + ((latMin*60)/3600) + (latSec/3600))
        latitude *= -1
    }
    
    var longitude = CLLocationDegrees()
    if longDeg >= 0 {
        longitude = CLLocationDegrees(longDeg + ((longMin*60)/3600) + (longSec/3600))
        if longDir == "W" || longDir == "w" {longitude *= -1}
    }
    else {
        longitude = CLLocationDegrees((longDeg * -1) + ((longMin*60)/3600) + (longSec/3600))
        longitude *= -1
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}

//Allow converstion from DMM to DD
func DMMtoDD(latDeg: Double, latMin: Double, latDir: String?, longDeg: Double, longMin: Double, longDir: String?) -> CLLocationCoordinate2D {
    var latitude = CLLocationDegrees()
    if latDeg >= 0 {
        latitude = CLLocationDegrees(latDeg + ((latMin*60)/3600))
        if latDir == "S" || latDir == "s" {latitude *= -1}
    }
    else {
        latitude = CLLocationDegrees((latDeg * -1) + ((latMin*60)/3600))
        latitude *= -1
    }
    var longitude = CLLocationDegrees()
    if longDeg >= 0 {
        longitude = CLLocationDegrees(longDeg + ((longMin*60)/3600))
        if longDir == "W" || longDir == "w" {longitude *= -1}
    }
    else {
        longitude = CLLocationDegrees((longDeg * -1) + ((longMin*60)/3600))
        longitude *= -1
    }
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
}
