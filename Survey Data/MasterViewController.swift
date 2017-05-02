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
    var selectedRow = 0
    
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
        
        sample.hikingParty = "Rick Arthur, Vladka Lackova-Gat, Tanya Taggart-Hodge"
        sample.pilot = "Paul Kendall"
        sample.rwCallSign = "PTG"
        
        sample.averageWindSpeed = 2.0
        sample.temperature = 20.0
        sample.barometricPressure = 713.9
        sample.maximumGustSpeed = 5.4
        sample.relativeHumidity = 31.5
        sample.wetBulbReading = 10.7
        
        sample.locOther = "Tanya's iPhone, location camera's batter is dead"
        sample.camOther = "Nikon"
        
        sample.gpsActive = true
        let repeatImageData1 = RepeatImageData(location: "1", originalPhotoNumber: "P1040213", repeatPhotoNumber: "4912 - 4916", azimuth: 300)
        let repeatImageData2 = RepeatImageData(location: "1", originalPhotoNumber: "P1040212", repeatPhotoNumber: "4917 - 4919", azimuth: 272)
        let repeatImageData3 = RepeatImageData(location: "1", originalPhotoNumber: "P1040211", repeatPhotoNumber: "4920 - 4921", azimuth: 238)
        let repeatImageData4 = RepeatImageData(location: "1", originalPhotoNumber: "P1040210", repeatPhotoNumber: "4922 - 4926", azimuth: 206)
        let repeatImageData5 = RepeatImageData(location: "1", originalPhotoNumber: "pano 1 *", repeatPhotoNumber: "4927 - 4929", azimuth: 170)
        let repeatImageData6 = RepeatImageData(location: "2", originalPhotoNumber: "pano 1 *", repeatPhotoNumber: "4930 - 4932", azimuth: 168)
        let repeatImageData7 = RepeatImageData(location: "2", originalPhotoNumber: "pano 2 *", repeatPhotoNumber: "4933 - 4935", azimuth: 135)
        let repeatImageData8 = RepeatImageData(location: "2", originalPhotoNumber: "P1040217", repeatPhotoNumber: "4936 - 4938", azimuth: 107)
        let repeatImageData9 = RepeatImageData(location: "2", originalPhotoNumber: "P1040216", repeatPhotoNumber: "4939 - 4941", azimuth: 70)
        let repeatImageData10 = RepeatImageData(location: "2", originalPhotoNumber: "P1040215", repeatPhotoNumber: "4942 - 4944", azimuth: 30)
        let repeatImageData11 = RepeatImageData(location: "2", originalPhotoNumber: "P1040214", repeatPhotoNumber: "4945 - 4947", azimuth: 340)
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
        
        let location1Photos = [UIImage(named: "Stn_492Loc_1"), UIImage(named: "Stn_492_Loc1"), UIImage(named: "Stn_492_Loc_1")]
        let locationData1 = LocationData(locationName: "1", locationNarrative: "Tripod is located on the northwest end of the peak ride, ~10m from the southeast edge. It is 1m from the drop in each direction.\nN52°21,378'\nW117°13.677'", locationPhotos: location1Photos as? Array<UIImage>)
        let location2Photos = [UIImage(named: "Stn_492_Loc2"), UIImage(named: "Stn_492_Loc_2")]
        let locationData2 = LocationData(locationName: "2", locationNarrative: "Tripod was moved to the southeast edge, ~1m from\nN52°21,378'\nW117°13.677'", locationPhotos: location2Photos as? Array<UIImage>)
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
        performSegue(withIdentifier: "showSurvey", sender: self)
        
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

    func insertNewSurvey(_ sender: Any) {
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
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let object = surveys[indexPath.row]
                    let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                    controller.detailItem = object.historicSurvey
                    controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                    controller.navigationItem.leftItemsSupplementBackButton = true
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
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            surveys.remove(at: indexPath.row)
            saveSurveys()
            tableView.deleteRows(at: [indexPath], with: .fade)
            performSegue(withIdentifier: "showSurvey", sender: self)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //MARK: Save Surveys
    private func saveSurveys() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(surveys, toFile: Survey.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Surveys successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save surveys...", log: OSLog.default, type: .error)
        }
    }
    private func loadSurveys() -> [Survey]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Survey.ArchiveURL.path) as? [Survey]
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
