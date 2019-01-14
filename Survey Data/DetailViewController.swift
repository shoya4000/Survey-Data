//
//  DetailViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-07.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import os.log

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIScrollViewDelegate {

    //MARK: Instantiate Foundational Elements
    var survey: Survey?
    let locationManager = CLLocationManager()
    func locationManager(_: CLLocationManager, didFailWithError: Error){
        let alert = UIAlertController(title: "GPS unavailable", message: "GPS has failed", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
        
        return
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if locations.last != nil{
            let location = locations.last! as CLLocation
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
            if isAddLocationGPSClicked == true {
                survey?.locationsData?[rowSelectedInLocations].gps = center
                LocationDataTable.reloadData()
                isAddLocationGPSClicked = false
            }
            else {
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                survey?.location = center
                updateAllLatFields()
                updateAllLonFields()
                narrativeMap.setRegion(region, animated: true)
            }
        }
        save()
        locationManager.stopUpdatingLocation()
    }
    var goToSurveyOnMap = false
    
    @IBOutlet weak var goToMap: UIButton!
    @IBAction func goToSurveyOnMap(_ sender: Any) {
        goToSurveyOnMap = true
        save()
    }
    var repeatImagesData = [RepeatImageData]()
    
    var categories = ["1-Urban or Built-up", "2-Agricultural Land", "3-Rangeland", "4-Forest Land", "5-Water", "6-Wetland", "7-Barren Land", "8-Alpine Tundra","9-Perennial Snow/Ice", "Fire", "Change", "Artifacts"]
    var keywords = [["11-Residential", "12-Commercial", "13-Industrial", "→ Forestry", "→ Mining", "→ Hydrocarbons", "→ Electricity", "14-Transportation, communications, and utilities", "15-Industrial and Commercial Complexes", "16-Mixed urban or built-up land", "17-Other urban or built-up land"], ["21-Cropland and pasture", "11-Orchards, groves, vineyards, nurseries, and ornamental areas", "23-Confined feeding operations", "24-Other Agricultural land"] , ["31-Herbaceous Rangeland", "32-Shrub and Brush Rangeland", "33-Mixed Rangeland"] , ["41-Deciduous Forest Land", "42-Evergreen Forest Land", "43-Mixed Forest Land"] , ["51-Streams and Canals", "52-Lakes", "53-Reservoirs", "54-Bays and Estuaries"] , ["61-Forested Wetland", "62-Non-Forested Wetland"] , ["71-Dry Salt Flats", "72-Beaches", "73-Sandy areas other than beaches", "74-Strip mines, quarries, and gravel pits", "76-Transitional areas", "77-Mixed Barren Land"] , ["81-Shrub and Bush Tundra", "82-Herbaceous Tundra", "83-Bare Ground Tundra", "84-Wet Tundra", "85-Mixed Tundra"] , ["91-Perennial Snowfields", "92-Glaciers"] , ["Fire"], ["Change advance", "Change Retreat", "Change Encroach", "Change Composition", "Change in Water"] , ["Human Subject", "Marker", "Equipment", "Historic Structure"]]
    var categoryToShow = [String]()
    var categoryPicked = "1-Urban or Built-up"
    var keywordpicked = "11-Residential"
    var KeywordsData = [KeywordData]()
    
    var storedOffsets = [Int: CGFloat]()
    var LocationsData = [LocationData()]
    //rowSelectedInLocations keep track of rowselected for adding photos
    var rowSelectedInLocations = 0
    
        //MARK: Instantiate Buttons
    var checkedBox = UIImage(named: "checked-checkbox-128")
    var uncheckedBox = UIImage(named: "unchecked-checkbox-128")
    
    let noImageSelected = UIImage(named: "no image selected")
    
    var isBoxClicked:Bool!
    var isBoxClicked3:Bool!
    var isBoxClicked4:Bool!
    var isBoxClicked5:Bool!
    var isBoxClicked6:Bool!
    var isBoxClicked7:Bool!
    
        //MARK: Instantiate add buttons
    var isAddRepeatDataClicked:Bool!
    
    var isAddKeywordButtonClicked:Bool!
    var isAddCustomKeywordClicked:Bool!
    
    var isAddLocationClicked:Bool!
    var isAddLocationGPSClicked:Bool!
    var isAddLocationPhotoClicked:Bool!
    var isALocationPhotoClicked:Bool!
    var locationPhotoClickedRow:Int!
    var locationPhotoClickedIndexPath:Int!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    @objc func doneDatePickerPressed(){
        self.view.endEditing(true)
    }
    
    //MARK: IBOutlets - Link code to objects in Interface Builder
    @IBOutlet weak var HistoricSurveyName: UITextField!
    @IBOutlet weak var SurveyYear: UITextField!
    @IBOutlet weak var StationName: UITextField!
    
    @IBOutlet weak var repeatDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var finishTime: UITextField!
    
    @IBOutlet weak var DDLat: UITextField!
    @IBOutlet weak var DDLong: UITextField!
    @IBOutlet weak var DMMLatDeg: UITextField!
    @IBOutlet weak var DMMLatMin: UITextField!
    @IBOutlet weak var DMMLatDir: UITextField!
    @IBOutlet weak var DMMLonDeg: UITextField!
    @IBOutlet weak var DMMLonMin: UITextField!
    @IBOutlet weak var DMMLonDir: UITextField!
    @IBOutlet weak var DMSLatDeg: UITextField!
    @IBOutlet weak var DMSLatMin: UITextField!
    @IBOutlet weak var DMSLatSec: UITextField!
    @IBOutlet weak var DMSLatDir: UITextField!
    @IBOutlet weak var DMSLonDeg: UITextField!
    @IBOutlet weak var DMSLonMin: UITextField!
    @IBOutlet weak var DMSLonSec: UITextField!
    @IBOutlet weak var DMSLonDir: UITextField!
    
    @IBOutlet weak var hikingDetails: UITextField!
    @IBOutlet weak var pilotName: UITextField!
    @IBOutlet weak var rwCallSign: UITextField!
    
    @IBOutlet weak var windSpeed: UITextField!
    @IBOutlet weak var temp: UITextField!
    @IBOutlet weak var baroPress: UITextField!
    
    @IBOutlet weak var gustSpeed: UITextField!
    @IBOutlet weak var humidity: UITextField!
    @IBOutlet weak var wetBulb: UITextField!
    
    @IBOutlet weak var locOtherInput: UITextField!
    @IBOutlet weak var camOtherInput: UITextField!
    
    @IBOutlet weak var elevMetres: UITextField!
    @IBOutlet weak var elevFT: UITextField!
    @IBOutlet weak var elevComments: UITextField!
    
    @IBOutlet weak var cardNumber: UITextField!
    
    @IBOutlet weak var stationNarrative: UITextView!
    @IBOutlet weak var narrativeIllustration: UIImageView!
    @IBOutlet weak var narrativeMap: MKMapView!
    
    @IBOutlet weak var weatherNarrative: UITextView!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var photographer: UITextField!
    
    //MARK: getGPS button and action
    @IBOutlet weak var getGPS: UIButton!
    @IBAction func getGPSLocation(_ sender: Any) {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    //MARK: Autosave
    func save(){
        self.performSegue(withIdentifier: "unwindToMasterView", sender: (Any).self)
    }
    
    //MARK: Checkbox Outlets
    @IBOutlet weak var checkBoxButton: UIButton!
    //checkBoxButton2 was removed
    @IBOutlet weak var checkBoxButton3: UIButton!
    @IBOutlet weak var checkBoxButton4: UIButton!
    @IBOutlet weak var checkBoxButton5: UIButton!
    @IBOutlet weak var checkBoxButton6: UIButton!
    @IBOutlet weak var checkBoxButton7: UIButton!
    
    // MARK: Outlets for location data input
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var OriginalPhotoNumberInput: UITextField!
    @IBOutlet weak var RepeatPhotoNumberInput: UITextField!
    @IBOutlet weak var azimuthInput: UITextField!
    @IBOutlet weak var notesInput: UITextField!
    
    //MARK: Keyword Pickers
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var DescriptionBar: UITextField!
    
    //MARK: Keyword table outlets and actions
    @IBOutlet weak var KeywordTable: UITableView!
    
    @IBAction func addKeywordToTable(_ sender: Any) {
        if isAddKeywordButtonClicked == true {
            isAddKeywordButtonClicked = false
        }
        else {
            isAddKeywordButtonClicked = true
        }
        if isAddKeywordButtonClicked == true {
            if !categoryPicked.isEmpty && !keywordpicked.isEmpty {
                insertNewKeyword()
            }
            isAddKeywordButtonClicked = false
        }
    }
    //Insert selected Keyword
    func insertNewKeyword() {
        let newKeywordData = KeywordData(category: categoryPicked, keyword: keywordpicked, comment: DescriptionBar.text!)
        
        KeywordsData.insert(newKeywordData!, at: 0)
        survey?.keywords = KeywordsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.KeywordTable.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    //Custom Keyword input
    @IBOutlet weak var customKeyword: UITextField!
    //Add a custom Keyword
    @IBAction func addCustomKeyword(_ sender: Any) {
        if isAddCustomKeywordClicked == true {
            isAddCustomKeywordClicked = false
        }
        else {
            isAddCustomKeywordClicked = true
        }
        if isAddCustomKeywordClicked == true {
            if !customKeyword.text!.isEmpty {
                insertCustomKeyword()
            }
            customKeyword.text = ""
            DescriptionBar.text = ""
            isAddCustomKeywordClicked = false
        }
    }
    //Insert custom Keyword
    func insertCustomKeyword() {
        let newKeywordData = KeywordData(category: "Custom", keyword: customKeyword.text!, comment: DescriptionBar.text!)
        
        KeywordsData.insert(newKeywordData!, at: 0)
        survey?.keywords = KeywordsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.KeywordTable.insertRows(at: [indexPath], with: .automatic)
        save()
    }

    // MARK: Location Table and Add Action
    @IBOutlet weak var LocationDataTable: UITableView!
    //Add location
    @IBAction func AddLocation(_ sender: Any) {
        if isAddLocationClicked == true {
            isAddLocationClicked = false
        }
        else {
            isAddLocationClicked = true
        }
        if isAddLocationClicked == true {
            insertLocation()
            isAddLocationClicked = false
        }
    }
    func insertLocation() {
        let newLocationData = LocationData()
        
        LocationsData.insert(newLocationData, at: 0)
        survey?.locationsData = LocationsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.LocationDataTable.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    //MARK: Link ScrollView
    @IBOutlet weak var scrollView: UIScrollView!
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.view
    }
    //MARK: @IBActions
    //MARK: Check box for iPad
    @IBAction func checkBox(_ sender: Any) {
        if isBoxClicked == true{
            isBoxClicked = false
        }
        else{
            isBoxClicked = true
        }
        if isBoxClicked == true{
            checkBoxButton.setImage(checkedBox, for: UIControl.State.normal)
            survey?.iPad = true
            save()
        }
        else{
            checkBoxButton.setImage(uncheckedBox, for: UIControl.State.normal)
            survey?.iPad = false
            save()
        }
    }
    // MARK: Check box for GPS
    @IBAction func checkBox5(_ sender: Any) {
        if isBoxClicked5 == true{
            isBoxClicked5 = false
        }
        else{
            isBoxClicked5 = true
        }
        if isBoxClicked5 == true{
            checkBoxButton5.setImage(checkedBox, for: UIControl.State.normal)
            survey?.gpsActive = true
            save()
        }
        else{
            checkBoxButton5.setImage(uncheckedBox, for: UIControl.State.normal)
            survey?.gpsActive = false
            save()
        }
    }
    // MARK: Yes button for selecting an image for station narrative
    @IBAction func checkBox6(_ sender: Any) {
        if isBoxClicked6 == true{
            isBoxClicked6 = false
        }
        else{
            isBoxClicked6 = true
        }
        if isBoxClicked6 == true{
            checkBoxButton6.setImage(checkedBox, for: UIControl.State.normal)
            
            // prompt to select image
            // UIImagePickerController is a view controller that lets a user pick media from their photo library.
            let imagePickerController = UIImagePickerController()
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            
            let alert = UIAlertController(title: "Image Source?", message: "Would you like to take a new photo, or use one saved on the iPad?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Take new photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Use saved photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            // show the alert
            present(alert, animated: true, completion: nil)
            
            checkBoxButton7.setImage(uncheckedBox, for: UIControl.State.normal)
            isBoxClicked7 = false
            survey?.illustration = true
            save()
        }
        else{
            checkBoxButton6.setImage(uncheckedBox, for: UIControl.State.normal)
            // if not no image selected, switch to no image selected
            survey?.illustration = false
            survey?.illustrationImage = noImageSelected
            save()
        }
    }
    // MARK: No button for selecting an image for station narrative
    @IBAction func checkBox7(_ sender: Any) {
        if isBoxClicked7 == true{
            isBoxClicked7 = false
        }
        else{
            isBoxClicked7 = true
        }
        if isBoxClicked7 == true{
            checkBoxButton7.setImage(checkedBox, for: UIControl.State.normal)
            // if not no image selected, switch to no image selected
            narrativeIllustration.image = noImageSelected
            
            checkBoxButton6.setImage(uncheckedBox, for: UIControl.State.normal)
            isBoxClicked6 = false
            survey?.illustration = false
            survey?.illustrationImage = noImageSelected
            save()
        }
        else{
            checkBoxButton7.setImage(uncheckedBox, for: UIControl.State.normal)
        }
    }

    @IBAction func AddLocationGPS(_ sender: Any) {
        isAddLocationGPSClicked = true
        let touchPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.LocationDataTable)
        rowSelectedInLocations = (LocationDataTable.indexPathForRow(at: touchPoint)?.row)!
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: Add location Photo to view
    @IBAction func AddLocationPhoto(_ sender: Any) {
        let touchPoint = (sender as AnyObject).convert(CGPoint.zero, to: self.LocationDataTable)
        rowSelectedInLocations = (LocationDataTable.indexPathForRow(at: touchPoint)?.row)!
        
        if isAddLocationPhotoClicked == true {
            isAddLocationPhotoClicked = false
        }
        else{
            isAddLocationPhotoClicked = true
        }
        if isAddLocationPhotoClicked == true {
            // prompt to select image
            // UIImagePickerController is a view controller that lets a user pick media from their photo library.
            let imagePickerController = UIImagePickerController()
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            let alert = UIAlertController(title: "Image Source?", message: "Would you like to take a new photo, or use one saved on the iPad?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Take new photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Use saved photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            // show the alert
            present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Insert location photo into back data
    func insertLocationPhoto(selectedImage: UIImage) {
        if !LocationsData[rowSelectedInLocations].hasPhotos {
            LocationsData[rowSelectedInLocations].locationPhotosAsData[0] = selectedImage.jpegData(compressionQuality: 0.10)
        }
        else {
            if isALocationPhotoClicked {
                LocationsData[locationPhotoClickedRow].locationPhotosAsData[locationPhotoClickedIndexPath] = selectedImage.jpegData(compressionQuality: 0.10)
            }
            else {
                LocationsData[rowSelectedInLocations].locationPhotosAsData.insert(selectedImage.jpegData(compressionQuality: 0.10), at: 0)
            }
        }
        LocationsData[rowSelectedInLocations].hasPhotos = true
        survey?.locationsData?[rowSelectedInLocations].locationPhotosAsData = LocationsData[rowSelectedInLocations].locationPhotosAsData
        
        survey?.locationsData?[rowSelectedInLocations].hasPhotos = LocationsData[rowSelectedInLocations].hasPhotos
        save()
        
        LocationDataTable.reloadData()
        isAddLocationPhotoClicked = false
        isALocationPhotoClicked = false
    }
    
    //MARK: Actions for adding Repeat Image Data
    @IBAction func addNewRepeatImageData(_ sender: Any) {
        if isAddRepeatDataClicked == true {
            isAddRepeatDataClicked = false
        }
        else {
            isAddRepeatDataClicked = true
        }
        if isAddRepeatDataClicked == true {
            if !locationInput.text!.isEmpty && !OriginalPhotoNumberInput.text!.isEmpty && !RepeatPhotoNumberInput.text!.isEmpty{
                insertNewRepeatImageData()
                OriginalPhotoNumberInput.text = ""
                RepeatPhotoNumberInput.text = ""
                azimuthInput.text = ""
                notesInput.text = ""
            }
            isAddRepeatDataClicked = false
        }
    }
    func insertNewRepeatImageData() {
        let newRepeatImageData = RepeatImageData(location: locationInput.text!, originalPhotoNumber: OriginalPhotoNumberInput.text!, repeatPhotoNumber: RepeatPhotoNumberInput.text!, azimuth: Double(azimuthInput.text!), notes: notesInput.text)
        repeatImagesData.insert(newRepeatImageData!, at: 0)
        survey?.repeatImages = repeatImagesData
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        save()
    }
    
    //MARK: Return from Hiking Party picker with data
    @IBAction func unwindToDetailView(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? TeamTableViewController {
            let hikingParty = sourceViewController.selectedPeople
            survey?.hikingParty = hikingParty
            hikingDetails.text = hikingParty.joined(separator: ", ")
            hikingDetails.resignFirstResponder()
        }
        if let sourceViewController = sender.source as? CameraTableViewController {
            let camera = sourceViewController.selectedCamera
            survey?.camOther = camera
            camOtherInput.text = camera
            camOtherInput.resignFirstResponder()
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "popoverSegue" {
            view.endEditing(true)
            let popoverViewController = segue.destination as! TeamTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self as? UIPopoverPresentationControllerDelegate
            if survey?.hikingParty != nil {
                popoverViewController.selectedPeople = (survey?.hikingParty)!
            }
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    //MARK: Load page functions
    func configureView() {
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
        
        // Handle the text field’s user input through delegate callbacks.
        HistoricSurveyName.delegate = self as UITextFieldDelegate
        SurveyYear.delegate = self as UITextFieldDelegate
        StationName.delegate = self as UITextFieldDelegate
        
        repeatDate.delegate = self as UITextFieldDelegate
        startTime.delegate = self as UITextFieldDelegate!
        finishTime.delegate = self as UITextFieldDelegate
        
        getGPS.backgroundColor = .clear
        getGPS.layer.cornerRadius = 3
        getGPS.layer.borderWidth = 2
        getGPS.layer.borderColor = UIColor.blue.cgColor
        
        goToMap.backgroundColor = .clear
        goToMap.layer.cornerRadius = 3
        goToMap.layer.borderWidth = 2
        goToMap.layer.borderColor = UIColor.blue.cgColor
        
        DDLat.delegate = self as UITextFieldDelegate
        DDLong.delegate = self as UITextFieldDelegate
        DMMLatDeg.delegate = self as UITextFieldDelegate
        DMMLatMin.delegate = self as UITextFieldDelegate
        DMMLatDir.delegate = self as UITextFieldDelegate
        DMMLonDeg.delegate = self as UITextFieldDelegate
        DMMLonMin.delegate = self as UITextFieldDelegate
        DMMLonDir.delegate = self as UITextFieldDelegate
        DMSLatDeg.delegate = self as UITextFieldDelegate
        DMSLatMin.delegate = self as UITextFieldDelegate
        DMSLatSec.delegate = self as UITextFieldDelegate
        DMSLatDir.delegate = self as UITextFieldDelegate
        DMSLonDeg.delegate = self as UITextFieldDelegate
        DMSLonMin.delegate = self as UITextFieldDelegate
        DMSLonSec.delegate = self as UITextFieldDelegate
        DMSLonDir.delegate = self as UITextFieldDelegate
        
        hikingDetails.delegate = self as UITextFieldDelegate
        pilotName.delegate = self as UITextFieldDelegate
        rwCallSign.delegate = self as UITextFieldDelegate
        
        windSpeed.delegate = self as UITextFieldDelegate
        temp.delegate = self as UITextFieldDelegate
        baroPress.delegate = self as UITextFieldDelegate
        
        gustSpeed.delegate = self as UITextFieldDelegate
        humidity.delegate = self as UITextFieldDelegate
        wetBulb.delegate = self as UITextFieldDelegate
        
        locOtherInput.delegate = self as UITextFieldDelegate
        camOtherInput.delegate = self as UITextFieldDelegate
        
        elevMetres.delegate = self as UITextFieldDelegate
        elevFT.delegate = self as UITextFieldDelegate
        elevComments.delegate = self as UITextFieldDelegate
        
        cardNumber.delegate = self as UITextFieldDelegate
        
        locationInput.delegate = self as UITextFieldDelegate
        OriginalPhotoNumberInput.delegate = self as UITextFieldDelegate
        RepeatPhotoNumberInput.delegate = self as UITextFieldDelegate
        azimuthInput.delegate = self as UITextFieldDelegate
        notesInput.delegate = self as UITextFieldDelegate
        
        stationNarrative.delegate = self as UITextViewDelegate
        weatherNarrative.delegate = self as UITextViewDelegate
        
        author.delegate = self as UITextFieldDelegate
        photographer.delegate = self as UITextFieldDelegate
        
        // Set up views if editing an existing Survey.
        if let survey = survey {
            navigationItem.title = survey.historicSurvey
            HistoricSurveyName.text = survey.historicSurvey
            SurveyYear.text = "\(survey.year)"
            StationName.text = survey.stationName
            
            if survey.location != nil && survey.location?.latitude != 0 {
                updateAllLatFields()
                updateAllLonFields()
                let span = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: survey.location!, span: span)
                narrativeMap.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = survey.location!
                narrativeMap.addAnnotation(annotation)
            }
            else {
                DDLat.text = ""
                DDLong.text = ""
                DMMLatDeg.text = ""
                DMMLatMin.text = ""
                DMMLatDir.text = ""
                DMMLonDeg.text = ""
                DMMLonMin.text = ""
                DMMLonDir.text = ""
                DMSLatDeg.text = ""
                DMSLatMin.text = ""
                DMSLatSec.text = ""
                DMSLatDir.text = ""
                DMSLonDeg.text = ""
                DMSLonMin.text = ""
                DMSLonSec.text = ""
                DMSLonDir.text = ""
            }
            
            let dateFormatter = DateFormatter()
            if survey.repeatDate != nil {
                dateFormatter.dateStyle = DateFormatter.Style.long
                repeatDate.text = dateFormatter.string(from: survey.repeatDate! as Date)
                dateFormatter.dateFormat = "h:mm a"
                startTime.text = dateFormatter.string(from: survey.repeatDate! as Date)
            }
            if survey.finishTime != nil {
                dateFormatter.dateFormat = "h:mm a"
                finishTime.text = dateFormatter.string(from: survey.finishTime! as Date)
            }
            else {
                finishTime.text = ""
            }
            
            hikingDetails.text = survey.hikingParty?.joined(separator: ", ")
            pilotName.text = survey.pilot
            rwCallSign.text = survey.rwCallSign
            
            if survey.averageWindSpeed != nil && survey.averageWindSpeed != 0 {
                windSpeed.text = String(format: "%.1f", survey.averageWindSpeed!)
            }
            else {
                windSpeed.text = ""
            }
            if survey.temperature != nil && survey.temperature != 0 {
                temp.text = String(format: "%.1f", survey.temperature!)
            }
            else {
                temp.text = ""
            }
            if survey.barometricPressure != nil && survey.barometricPressure != 0 {
                baroPress.text = String(format: "%.1f", survey.barometricPressure!)
            }
            else {
                baroPress.text = ""
            }
            if survey.maximumGustSpeed != nil  && survey.maximumGustSpeed != 0 {
                gustSpeed.text = String(format: "%.1f", survey.maximumGustSpeed!)
            }
            else {
                gustSpeed.text = ""
            }
            if survey.relativeHumidity != nil  && survey.relativeHumidity != 0 {
                humidity.text = String(format: "%.1f", survey.relativeHumidity!)
            }
            else {
                humidity.text = ""
            }
            if survey.wetBulbReading != nil  && survey.wetBulbReading != 0 {
                wetBulb.text = String(format: "%.1f", survey.wetBulbReading!)
            }
            else {
                wetBulb.text = ""
            }
            
            if survey.iPad != nil && survey.iPad! {
                checkBoxButton.setImage(checkedBox, for: UIControl.State.normal)
            }
            else {
                checkBoxButton.setImage(uncheckedBox, for: UIControl.State.normal)
            }
            locOtherInput.text = survey.locOther
            camOtherInput.text = survey.camOther

            
            if survey.elevationMetres != nil  && survey.elevationMetres != 0 {
                updateElevation()
            }
            else {
                elevMetres.text = ""
                elevFT.text = ""
            }
            elevComments.text = survey.elevationComments
            if survey.cardNumber != nil && survey.cardNumber != 0 {
                cardNumber.text = String(format: "%d", survey.cardNumber!)
            }
            else {
                cardNumber.text = ""
            }
            if survey.gpsActive != nil && survey.gpsActive! {
                checkBoxButton5.setImage(checkedBox, for: UIControl.State.normal)
            }
            else {
                checkBoxButton5.setImage(uncheckedBox, for: UIControl.State.normal)
            }
            
            if survey.repeatImages != nil {
                repeatImagesData = survey.repeatImages!
            }
            else {
                repeatImagesData = [RepeatImageData]()
            }
            
            stationNarrative.text = survey.stationNarrative

            if survey.illustration != nil && survey.illustration! {
                checkBoxButton6.setImage(checkedBox, for: UIControl.State.normal)
                checkBoxButton7.setImage(uncheckedBox, for: UIControl.State.normal)
                if survey.illustrationImage != nil{
                    //delete this conversion once applied to all iPads
                    survey.illustrationImageAsData = survey.illustrationImage!.jpegData(compressionQuality: 0.10)
                    narrativeIllustration.image = UIImage(data:survey.illustrationImageAsData!)
                }
            }
            else {
                checkBoxButton7.setImage(checkedBox, for: UIControl.State.normal)
                checkBoxButton6.setImage(uncheckedBox, for: UIControl.State.normal)
                narrativeIllustration.image = noImageSelected
            }
            
            weatherNarrative.text = survey.weatherNarrative
            
            if survey.keywords != nil {
                KeywordsData = survey.keywords!
            }
            else {
                KeywordsData = [KeywordData]()
            }
            
            if survey.locationsData != nil {
                LocationsData = survey.locationsData!
            }
            else {
                survey.locationsData = LocationsData
            }
            
            author.text = survey.author
            photographer.text = survey.photographer
        }
        
        isBoxClicked = false
        isBoxClicked3 = false
        isBoxClicked4 = false
        isBoxClicked5 = false
        
        isAddRepeatDataClicked = false
        
        isBoxClicked6 = false
        isBoxClicked7 = false
        
        self.CategoryPicker.delegate = self
        self.CategoryPicker.dataSource = self
        categoryToShow = keywords[0]
        isAddKeywordButtonClicked = false
        isAddCustomKeywordClicked = false
        
        isAddLocationClicked = false
        isAddLocationGPSClicked = false
        isAddLocationPhotoClicked = false
        isALocationPhotoClicked = false
        locationPhotoClickedRow = 0
        locationPhotoClickedIndexPath = 0
        
        view.addBackground(imageName: "MLP Logo Watermark", contextMode: .scaleAspectFit)
        
        // Date pickers
        if survey?.repeatDate != nil{
            datePicker.date = (survey?.repeatDate as Date?)!
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        repeatDate.inputView = datePicker
        if survey?.repeatDate != nil{
            timePicker.date = (survey?.repeatDate as Date?)!
        }
        timePicker.datePickerMode = UIDatePicker.Mode.time
        startTime.inputView = timePicker
        finishTime.inputView = timePicker
        
        let doneBar = UIToolbar()
        doneBar.barStyle = UIBarStyle.default
        doneBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(DetailViewController.doneDatePickerPressed))
        
        // if you remove the space element, the "done" button will be left aligned
        // you can add more items if you want
        doneBar.setItems([space, doneButton], animated: false)
        doneBar.isUserInteractionEnabled = true
        doneBar.sizeToFit()
        
        repeatDate.inputAccessoryView = doneBar
        startTime.inputAccessoryView = doneBar
        finishTime.inputAccessoryView = doneBar
        
        // let narrativeIllustration be clicked
        // create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.imageTapped(gesture:)))
        
        // add it to the image view;
        narrativeIllustration.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        narrativeIllustration.isUserInteractionEnabled = true
        
        self.hideKeyboardWhenTappedAround()
        
        //MARK: Adjust view to device screensize
        let transformValue = (self.navigationController?.view.bounds.width)!/1024
        self.view.transform = CGAffineTransform.identity.scaledBy(x: transformValue, y: transformValue)
        
        SurveyYear.keyboardType = UIKeyboardType.numberPad
        StationName.keyboardType = UIKeyboardType.numberPad
        
        DDLat.keyboardType = UIKeyboardType.numberPad
        DDLong.keyboardType = UIKeyboardType.numberPad
        DMMLatDeg.keyboardType = UIKeyboardType.numberPad
        DMMLatMin.keyboardType = UIKeyboardType.numberPad
        DMMLonDeg.keyboardType = UIKeyboardType.numberPad
        DMMLonMin.keyboardType = UIKeyboardType.numberPad
        DMSLatDeg.keyboardType = UIKeyboardType.numberPad
        DMSLatMin.keyboardType = UIKeyboardType.numberPad
        DMSLatSec.keyboardType = UIKeyboardType.numberPad
        DMSLonDeg.keyboardType = UIKeyboardType.numberPad
        DMSLonMin.keyboardType = UIKeyboardType.numberPad
        DMSLonSec.keyboardType = UIKeyboardType.numberPad
        
        windSpeed.keyboardType = UIKeyboardType.numberPad
        gustSpeed.keyboardType = UIKeyboardType.numberPad
        temp.keyboardType = UIKeyboardType.numberPad
        humidity.keyboardType = UIKeyboardType.numberPad
        baroPress.keyboardType = UIKeyboardType.numberPad
        wetBulb.keyboardType = UIKeyboardType.numberPad
        
        elevMetres.keyboardType = UIKeyboardType.numberPad
        elevFT.keyboardType = UIKeyboardType.numberPad
        
        cardNumber.keyboardType = UIKeyboardType.numberPad
        locationInput.keyboardType = UIKeyboardType.numberPad
        OriginalPhotoNumberInput.keyboardType = UIKeyboardType.numberPad
        RepeatPhotoNumberInput.keyboardType = UIKeyboardType.numberPad
        azimuthInput.keyboardType = UIKeyboardType.numberPad
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            isBoxClicked6 = true
            let imagePickerController = UIImagePickerController()
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            let alert = UIAlertController(title: "Image Source?", message: "Would you like to take a new photo, or use one saved on the iPad?", preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Take new photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Use saved photo", style: .default, handler: { (action: UIAlertAction!) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Just view current image", style: .default, handler: { (action: UIAlertAction!) in
                let imageView = gesture.view as! UIImageView
                let newImageView = UIImageView(image: imageView.image)
                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            
            // show the alert
            present(alert, animated: true, completion: nil)
        }
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
        //http://stackoverflow.com/questions/34694377/swift-how-can-i-make-an-image-full-screen-when-clicked-and-then-original-size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    //MARK: TextField Controls
    func textFieldDidEndEditing(_ textField: UITextField) {
        //MARK: Handle survey, year, and station input
        if textField == self.HistoricSurveyName {
            navigationItem.title = HistoricSurveyName.text
            survey?.historicSurvey = HistoricSurveyName.text!
        }
        if textField == self.SurveyYear {
            if isInteger(a: SurveyYear.text!) {
                survey?.year = Int(SurveyYear.text!)!
            }
            SurveyYear.text = String(format: "%d", (survey?.year)!)
        }
        if textField == self.StationName {
            survey?.stationName = StationName.text!
        }
        
        //MARK: Handle date and times input
        if textField == self.repeatDate {
            survey?.repeatDate = combineDateWithTime(date: datePicker.date, time: (survey?.repeatDate)! as Date) as NSDate?
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            textField.text = dateFormatter.string(from: survey!.repeatDate! as Date)
        }
        
        if textField == self.startTime {
            survey?.repeatDate = combineDateWithTime(date: (survey?.repeatDate)! as Date, time: timePicker.date) as NSDate?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            textField.text = dateFormatter.string(from: survey!.repeatDate! as Date)
        }
        if textField == self.finishTime {
            survey?.finishTime = combineDateWithTime(date: (survey?.repeatDate)! as Date, time: timePicker.date) as NSDate?
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            textField.text = dateFormatter.string(from: survey!.finishTime! as Date)
        }
        
        //MARK: Handle DD input
        if textField == self.DDLat {
            if isNumeric(a: DDLat.text!){
                let latitude = Double(DDLat.text!)!
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DDLong {
            if isNumeric(a: DDLong.text!){
                let longitude = Double(DDLong.text!)!
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        
        //MARK: Handle DMM input
        if textField == self.DMMLatDeg {
            if isNumeric(a: DMMLatDeg.text!) && Double(DMMLatDeg.text!)! >= -90.0 && Double(DMMLatDeg.text!)! <= 90.0 {
                if DMMLatMin.text == "" {
                    DMMLatMin.text = "0"
                }
                let latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DMMLatMin {
            if isNumeric(a: DMMLatMin.text!){
                if DMMLatDeg.text == "" {
                    DMMLatDeg.text = "0"
                }
                let latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DMMLatDir && DMMLatDir.text != "" {
            survey?.location?.latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
            updateAllLatFields()
        }
        if textField == self.DMMLonDeg {
            if isNumeric(a: DMMLonDeg.text!) && Double(DMMLonDeg.text!)! >= -180.0 && Double(DMMLonDeg.text!)! <= 180.0 {
                if DMMLonMin.text == "" {
                    DMMLonMin.text = "0"
                }
                let longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        if textField == self.DMMLonMin  {
            if isNumeric(a: DMMLonMin.text!){
                if DMMLonDeg.text == "" {
                    DMMLonDeg.text = "0"
                }
                let longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        if textField == self.DMMLonDir && DMMLonDir.text != "" {
            survey?.location?.longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
            updateAllLonFields()
        }
        
        //MARK: Handle DMS input
        if textField == self.DMSLatDeg {
            if isNumeric(a: DMSLatDeg.text!) && Double(DMSLatDeg.text!)! >= -90.0 && Double(DMSLatDeg.text!)! <= 90.0 {
                if DMSLatMin.text == "" {
                    DMSLatMin.text = "0"
                }
                if DMSLatSec.text == "" {
                    DMSLatSec.text = "0"
                }
                let latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatMin {
            if isNumeric(a: DMSLatMin.text!){
                if DMSLatDeg.text == "" {
                    DMSLatDeg.text = "0"
                }
                if DMSLatSec.text == "" {
                    DMSLatSec.text = "0"
                }
                let latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatSec {
            if isNumeric(a: DMSLatSec.text!) {
                if DMSLatDeg.text == "" {
                    DMSLatDeg.text = "0"
                }
                if DMSLatMin.text == "" {
                    DMSLatMin.text = "0"
                }
                let latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.location?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatDir && DMMLatDir.text != "" {
            survey?.location?.latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
            updateAllLatFields()
        }
        if textField == self.DMSLonDeg {
            if isNumeric(a: DMSLonDeg.text!) && Double(DMSLonDeg.text!)! >= -180.0 && Double(DMSLonDeg.text!)! <= 180.0 {
                if DMSLonMin.text == "" {
                    DMSLonMin.text = "0"
                }
                if DMSLonSec.text == "" {
                    DMSLonSec.text = "0"
                }
                let longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonMin{
            if isNumeric(a: DMSLonMin.text!) {
                if DMSLonDeg.text == "" {
                    DMSLonDeg.text = "0"
                }
                if DMSLonSec.text == "" {
                    DMSLonSec.text = "0"
                }
                let longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonSec {
            if isNumeric(a: DMSLonSec.text!) {
                if DMSLonDeg.text == "" {
                    DMSLonDeg.text = "0"
                }
                if DMSLonMin.text == "" {
                    DMSLonMin.text = "0"
                }
                let longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.location?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonDir && DMSLonDir.text != "" {
            survey?.location?.longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
            updateAllLonFields()
        }
        
        if textField == self.pilotName {
            survey?.pilot = pilotName.text
        }
        if textField == self.rwCallSign {
            survey?.rwCallSign = rwCallSign.text
        }
        
        if textField == self.windSpeed {
            if isNumeric(a: windSpeed.text!) {
                survey?.averageWindSpeed = Double(windSpeed.text!)!
            }
            if survey?.averageWindSpeed != nil {
                windSpeed.text = String(format: "%.1f", (survey?.averageWindSpeed!)!)
            }
            else{
                windSpeed.text = ""
            }
        }
        if textField == self.temp {
            if isNumeric(a: temp.text!) {
                survey?.temperature = Double(temp.text!)!
            }
            if survey?.temperature != nil {
                temp.text = String(format: "%.1f", (survey?.temperature!)!)
            }
            else {
                temp.text = ""
            }
        }
        if textField == self.baroPress {
            if isNumeric(a: baroPress.text!) {
                survey?.barometricPressure = Double(baroPress.text!)!
            }
            if survey?.barometricPressure != nil {
                baroPress.text = String(format: "%.1f", (survey?.barometricPressure!)!)
            }
            else {
                baroPress.text = ""
            }
        }
        if textField == self.gustSpeed {
            if isNumeric(a: gustSpeed.text!) {
                survey?.maximumGustSpeed = Double(gustSpeed.text!)!
            }
            if survey?.maximumGustSpeed != nil {
                gustSpeed.text = String(format: "%.1f", (survey?.maximumGustSpeed!)!)
            }
            else {
                gustSpeed.text = ""
            }
        }
        if textField == self.humidity {
            if isNumeric(a: humidity.text!) {
                survey?.relativeHumidity = Double(humidity.text!)!
            }
            if survey?.relativeHumidity != nil {
                humidity.text = String(format: "%.1f", (survey?.relativeHumidity!)!)
            }
            else {
                humidity.text = ""
            }
        }
        if textField == self.wetBulb {
            if isNumeric(a: wetBulb.text!) {
                survey?.wetBulbReading = Double(wetBulb.text!)!
            }
            if survey?.wetBulbReading != nil {
                wetBulb.text = String(format: "%.1f", (survey?.wetBulbReading!)!)
            }
            else {
                wetBulb.text = ""
            }
        }
        
        if textField == self.locOtherInput {
            survey?.locOther = locOtherInput.text
        }
        if textField == self.camOtherInput {
            survey?.camOther = camOtherInput.text
        }
        
        if textField == self.elevMetres {
            elevMetres.text = elevMetres.text?.replacingOccurrences(of: ",", with: "")
            if isNumeric(a: elevMetres.text!) {
                survey?.elevationMetres = Double(elevMetres.text!)
            }
            if elevMetres.text != "" {
                updateElevation()
            }
            else{
                survey?.elevationMetres = nil
                elevFT.text = ""
            }
        }
        if textField == self.elevFT {
            elevFT.text = elevFT.text?.replacingOccurrences(of: ",", with: "")
            if isNumeric(a: elevFT.text!) {
                survey?.elevationMetres = Double(elevFT.text!)! / 3.28084
            }
            if elevFT.text != "" {
                updateElevation()
            }
            else{
                survey?.elevationMetres = nil
                elevMetres.text = ""
            }
        }
        if textField == self.elevComments {
            survey?.elevationComments = elevComments.text
        }
        
        if textField == self.cardNumber {
            if isInteger(a: cardNumber.text!) {
                survey?.cardNumber = Int(cardNumber.text!)
            }
            else if survey?.cardNumber != nil {
                cardNumber.text = String(format: "%d", (survey?.cardNumber)!)
            }
            else {
                cardNumber.text = ""
            }
        }
        
        if textField == self.author {
            survey?.author = author.text
        }
        if textField == self.photographer {
            survey?.photographer = photographer.text
        }
        
        let touchPoint = (textField).convert(CGPoint.zero, to: self.LocationDataTable)
        let indexPath = LocationDataTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let cell = LocationDataTable.cellForRow(at: indexPath!) as! LocationDataTableViewCell
            if textField == cell.LocationName {
                survey?.locationsData?[(indexPath?.row)!].locationName = textField.text!
            }
            if textField == cell.elevation {
                cell.elevation.text = cell.elevation.text?.replacingOccurrences(of: ",", with: "")
                if isNumeric(a: cell.elevation.text!) {
                    survey?.locationsData?[(indexPath?.row)!].elevation = Double(textField.text!)
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let elevationInMetres = round(LocationsData[(indexPath?.row)!].elevation!)
                cell.elevation.text = numberFormatter.string(from: NSNumber(value: elevationInMetres))
            }
            if textField == cell.gpsLatDeg {
                if isNumeric(a: cell.gpsLatDeg.text!) {
                    let latitude = DMMtoDD(latDeg: Double(cell.gpsLatDeg.text!)!, latMin: Double(cell.gpsLatMin.text!)!, latDir: cell.gpsLonDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
                    if validLat(latitude: latitude){
                        survey?.locationsData?[(indexPath?.row)!].gps?.latitude = latitude
                    }
                    else {
                        invalidCoordinate()
                    }
                }
                let LatDegInt = abs(Int(Double((LocationsData[(indexPath?.row)!].gps?.latitude)!)))
                let LatMinAbs = abs(Double((LocationsData[(indexPath?.row)!].gps?.latitudeMinutes)!))
                
                cell.gpsLatDeg.text = String(format: "%d", LatDegInt)
                cell.gpsLatMin.text = String(format: "%.4f", LatMinAbs)
                cell.gpsLatDir.text = LocationsData[(indexPath?.row)!].gps!.latitude >= 0 ? "N" : "S"
            }
            if textField == cell.gpsLatMin {
                if isNumeric(a: cell.gpsLatMin.text!) {
                    let latitude = DMMtoDD(latDeg: Double(cell.gpsLatDeg.text!)!, latMin: Double(cell.gpsLatMin.text!)!, latDir: cell.gpsLonDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
                    if validLat(latitude: latitude){
                        survey?.locationsData?[(indexPath?.row)!].gps?.latitude = latitude
                    }
                    else {
                        invalidCoordinate()
                    }
                }
                let LatDegInt = abs(Int(Double((LocationsData[(indexPath?.row)!].gps?.latitude)!)))
                let LatMinAbs = abs(Double((LocationsData[(indexPath?.row)!].gps?.latitudeMinutes)!))
                
                cell.gpsLatDeg.text = String(format: "%d", LatDegInt)
                cell.gpsLatMin.text = String(format: "%.4f", LatMinAbs)
                cell.gpsLatDir.text = LocationsData[(indexPath?.row)!].gps!.latitude >= 0 ? "N" : "S"
            }
            if textField == cell.gpsLatDir && cell.gpsLatDir.text != "" {
                let latitude = DMMtoDD(latDeg: Double(cell.gpsLatDeg.text!)!, latMin: Double(cell.gpsLatMin.text!)!, latDir: cell.gpsLonDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
                if validLat(latitude: latitude){
                    survey?.locationsData?[(indexPath?.row)!].gps?.latitude = latitude
                }
                else {
                    invalidCoordinate()
                }
                cell.gpsLatDir.text = LocationsData[(indexPath?.row)!].gps!.latitude >= 0 ? "N" : "S"
            }
            if textField == cell.gpsLonDeg {
                if isNumeric(a: cell.gpsLonDeg.text!) {
                    let longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(cell.gpsLonDeg.text!)!, longMin: Double(cell.gpsLonMin.text!)!, longDir: cell.gpsLonDir.text).longitude
                    if validLon(longitude: longitude){
                        survey?.locationsData?[(indexPath?.row)!].gps?.longitude = longitude
                    }
                    else {
                        invalidCoordinate()
                    }
                }
                let LonDegInt = abs(Int(Double((LocationsData[(indexPath?.row)!].gps?.longitude)!)))
                let LonMinAbs = abs(Double((LocationsData[(indexPath?.row)!].gps?.longitudeMinutes)!))
                
                cell.gpsLonDeg.text = String(format: "%d", LonDegInt)
                cell.gpsLonMin.text = String(format: "%.4f", LonMinAbs)
                cell.gpsLonDir.text = LocationsData[(indexPath?.row)!].gps!.longitude >= 0 ? "E" : "W"
            }
            if textField == cell.gpsLonMin {
                if isNumeric(a: cell.gpsLonMin.text!) {
                    let longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(cell.gpsLonDeg.text!)!, longMin: Double(cell.gpsLonMin.text!)!, longDir: cell.gpsLonDir.text).longitude
                    if validLon(longitude: longitude){
                        survey?.locationsData?[(indexPath?.row)!].gps?.longitude = longitude
                    }
                    else {
                        invalidCoordinate()
                    }
                }
                let LonDegInt = abs(Int(Double((LocationsData[(indexPath?.row)!].gps?.longitude)!)))
                let LonMinAbs = abs(Double((LocationsData[(indexPath?.row)!].gps?.longitudeMinutes)!))
                
                cell.gpsLonDeg.text = String(format: "%d", LonDegInt)
                cell.gpsLonMin.text = String(format: "%.4f", LonMinAbs)
                cell.gpsLonDir.text = LocationsData[(indexPath?.row)!].gps!.longitude >= 0 ? "E" : "W"
            }
            if textField == cell.gpsLonDir && cell.gpsLonDir.text != "" {
                let longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(cell.gpsLonDeg.text!)!, longMin: Double(cell.gpsLonMin.text!)!, longDir: cell.gpsLonDir.text).longitude
                if validLon(longitude: longitude){
                    survey?.locationsData?[(indexPath?.row)!].gps?.longitude = longitude
                }
                else {
                    invalidCoordinate()
                }
                cell.gpsLonDir.text = LocationsData[(indexPath?.row)!].gps!.longitude >= 0 ? "E" : "W"
            }
        }
        if textField != author && textField != photographer && textField != locationInput && textField != OriginalPhotoNumberInput && textField != RepeatPhotoNumberInput && textField != azimuthInput && textField != notesInput {
            save()
        }
        if textField == OriginalPhotoNumberInput {
            self.RepeatPhotoNumberInput.becomeFirstResponder()
        }
        if textField == RepeatPhotoNumberInput {
            self.azimuthInput.becomeFirstResponder()
        }
        if textField == azimuthInput {
            self.notesInput.becomeFirstResponder()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.locationInput {
            textField.text = string
            self.OriginalPhotoNumberInput.becomeFirstResponder()
            return false
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.hikingDetails {
            performSegue(withIdentifier: "popoverSegue", sender: nil)
        }
        if textField == self.camOtherInput {
            performSegue(withIdentifier: "cameraPopoverSegue", sender: nil)
        }
        if textField == self.author {
            if survey?.hikingParty != nil {
                let possibleAuthors = survey?.hikingParty
                let alert = UIAlertController(title: "Author?", message: "Who was the primary author of this document?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                for author in possibleAuthors! {
                    alert.addAction(UIAlertAction(title: author, style: .default, handler: { (action: UIAlertAction!) in
                        self.survey?.author = author
                        self.save()
                        self.author.text = self.survey?.author
                    }))
                }
                alert.addAction(UIAlertAction(title: "Clear", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.survey?.author = ""
                    self.save()
                    self.author.text = ""
                    
                }))
                // show the alert
                present(alert, animated: true, completion: nil)
            }
        }
        if textField == self.photographer {
            if survey?.hikingParty != nil {
                let possiblePhotgraphers = survey?.hikingParty
                let alert = UIAlertController(title: "Photographer?", message: "Who was the primary photographer?", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                for photographer in possiblePhotgraphers! {
                    alert.addAction(UIAlertAction(title: photographer, style: .default, handler: { (action: UIAlertAction!) in
                        self.survey?.photographer = photographer
                        self.photographer.text = self.survey?.photographer
                    }))
                }
                alert.addAction(UIAlertAction(title: "Clear", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.survey?.photographer = ""
                    self.photographer.text = ""
                }))
                // show the alert
                present(alert, animated: true, completion: nil)
            }
        }
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    //MARK: TextField helper functions
    //MARK: TextField functions for lat/long
    func validLat(latitude: CLLocationDegrees) -> Bool {
        if Double(latitude) >= -90.0 && Double(latitude) <= 90.0{
            return true
        }
        else {
            return false
        }
    }
    func updateAllLatFields(){
        DDLat.text = String(format: "%.5f", (survey?.location?.latitude)!)
        
        let LatDegInt = abs(Int(Double((survey?.location?.latitude)!)))
        let LatMinAbs = abs(Double((survey?.location?.latitudeMinutes)!))
        let LatSecsAbs = abs(Double((survey?.location?.latitudeSeconds)!))
        
        DMMLatDeg.text = String(format: "%d", LatDegInt)
        DMMLatMin.text = String(format: "%.4f", LatMinAbs)
        DMMLatDir.text = survey!.location!.latitude >= 0 ? "N" : "S"
        
        DMSLatDeg.text = String(format: "%d", LatDegInt)
        DMSLatMin.text = String(format: "%d", Int(LatMinAbs))
        DMSLatSec.text = String(format: "%.1f", LatSecsAbs)
        DMSLatDir.text = survey!.location!.latitude >= 0 ? "N" : "S"
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: (survey?.location!)!, span: span)
        narrativeMap.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = (survey?.location!)!
        narrativeMap.addAnnotation(annotation)
    }
    func validLon(longitude: CLLocationDegrees) -> Bool {
        if Double(longitude) >= -180.0 && Double(longitude) <= 180.0{
            return true
        }
        else {
            return false
        }
    }
    func updateAllLonFields(){
        DDLong.text = String(format: "%.5f", (survey?.location?.longitude)!)
        
        let LonDegInt = abs(Int(Double((survey?.location?.longitude)!)))
        let LonMinAbs = abs(Double((survey?.location?.longitudeMinutes)!))
        let LonSecsAbs = abs(Double((survey?.location?.longitudeSeconds)!))
        
        DMMLonDeg.text = String(format: "%d", LonDegInt)
        DMMLonMin.text = String(format: "%.4f", LonMinAbs)
        DMMLonDir.text = survey!.location!.longitude >= 0 ? "E" : "W"
        
        DMSLonDeg.text = String(format: "%d", LonDegInt)
        DMSLonMin.text = String(format: "%d", Int(LonMinAbs))
        DMSLonSec.text = String(format: "%.1f", LonSecsAbs)
        DMSLonDir.text = survey!.location!.longitude >= 0 ? "E" : "W"
        
        let span = MKCoordinateSpan.init(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: (survey?.location!)!, span: span)
        narrativeMap.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = (survey?.location!)!
        narrativeMap.addAnnotation(annotation)
    }
    func invalidCoordinate(){
        let alert = UIAlertController(title: "Invalid input", message: "Supplied GPS co-ordinate is invalid", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    //MARK: Check text is numeric
    func isNumeric(a: String) -> Bool {
        return (Double(a) != nil && a != "")
    }
    func isInteger(a: String) -> Bool {
        return (Int(a) != nil && a != "")
    }
    //MARK: Convert Elevation between metres and feet
    func updateElevation() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let elevationInMetres = round((survey?.elevationMetres!)!)
        elevMetres.text = numberFormatter.string(from: NSNumber(value: elevationInMetres))
        let elevationInFeet = round((survey?.elevationMetres!)! * 3.28084)
        elevFT.text = numberFormatter.string(from: NSNumber(value: elevationInFeet))
    }
    //MARK: Combine date with time to allow selection/changes of each independently
    func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
        
        return calendar.date(from: mergedComponments)
        
        //https://gist.github.com/justinmfischer/0a6edf711569854c2537
    }
    
    //MARK: TextView Controls
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectAll(nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.stationNarrative {
            survey?.stationNarrative = stationNarrative.text
            /*if survey?.hikingParty != nil && textView.text != "" {
                let possibleAuthors = survey?.hikingParty
                let alert = UIAlertController(title: "Author?", message: "Who authored this narrative?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                for author in possibleAuthors! {
                    alert.addAction(UIAlertAction(title: author, style: .default, handler: { (action: UIAlertAction!) in
                        self.survey?.stationNarrative = (self.survey?.stationNarrative)! + "\n~\(author)"
                        self.stationNarrative.text = self.survey?.stationNarrative
                    }))
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                // show the alert
                present(alert, animated: true, completion: nil)
            //decided 1 author at end is sufficient
            }*/
        }
        
        if textView == self.weatherNarrative {
            survey?.weatherNarrative = weatherNarrative.text
        }
        
        let touchPoint = (textView).convert(CGPoint.zero, to: self.LocationDataTable)
        let indexPath = LocationDataTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let cell = LocationDataTable.cellForRow(at: indexPath!) as! LocationDataTableViewCell
            if textView == cell.LocationNarrative {
                survey?.locationsData?[(indexPath?.row)!].locationNarrative = textView.text!
            }
        }
        save()
    }
    
    //MARK: TableView controls
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatImageDataViewCell", for: indexPath) as! RepeatImageDataViewCell
            cell.locationField?.text = repeatImagesData[indexPath.row].location
            cell.originalPhotoNumberField?.text = repeatImagesData[indexPath.row].originalPhotoNumber
            cell.repeatImageNumberField?.text = repeatImagesData[indexPath.row].repeatPhotoNumber
            if repeatImagesData[indexPath.row].azimuth != nil
            {
                cell.azimuthField?.text = String(format:"%.1f", repeatImagesData[indexPath.row].azimuth!) + "°"
                
            }
            else {
                cell.azimuthField.text = "Not taken"
            }
            cell.notesField.text = repeatImagesData[indexPath.row].notes
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
        else if tableView == self.KeywordTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordTableViewCell", for: indexPath) as! KeywordTableViewCell
            cell.category.text = KeywordsData[indexPath.row].category
            cell.keyword.text = KeywordsData[indexPath.row].keyword
            cell.descriptionComment.text = KeywordsData[indexPath.row].comment
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell", for: indexPath) as! LocationDataTableViewCell
            cell.LocationName.delegate = self as UITextFieldDelegate
            cell.LocationName.text = LocationsData[indexPath.row].locationName
            cell.LocationNarrative.delegate = self as UITextViewDelegate
            cell.LocationNarrative.text = LocationsData[indexPath.row].locationNarrative
            
            cell.elevation.delegate = self as UITextFieldDelegate
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            let elevationInMetres = round(LocationsData[indexPath.row].elevation!)
            cell.elevation.text = numberFormatter.string(from: NSNumber(value: elevationInMetres))
            
            cell.gpsLatDeg.delegate = self as UITextFieldDelegate
            cell.gpsLatMin.delegate = self as UITextFieldDelegate
            cell.gpsLatDir.delegate = self as UITextFieldDelegate
            cell.gpsLonDeg.delegate = self as UITextFieldDelegate
            cell.gpsLonMin.delegate = self as UITextFieldDelegate
            cell.gpsLonDir.delegate = self as UITextFieldDelegate
            
            let LatDegInt = abs(Int(Double((LocationsData[indexPath.row].gps?.latitude)!)))
            let LatMinAbs = abs(Double((LocationsData[indexPath.row].gps?.latitudeMinutes)!))
            
            cell.gpsLatDeg.text = String(format: "%d", LatDegInt)
            cell.gpsLatMin.text = String(format: "%.4f", LatMinAbs)
            cell.gpsLatDir.text = LocationsData[indexPath.row].gps!.latitude >= 0 ? "N" : "S"
            
            let LonDegInt = abs(Int(Double((LocationsData[indexPath.row].gps?.longitude)!)))
            let LonMinAbs = abs(Double((LocationsData[indexPath.row].gps?.longitudeMinutes)!))
            
            cell.gpsLonDeg.text = String(format: "%d", LonDegInt)
            cell.gpsLonMin.text = String(format: "%.4f", LonMinAbs)
            cell.gpsLonDir.text = LocationsData[indexPath.row].gps!.longitude >= 0 ? "E" : "W"
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if tableView == self.tableView {
            count = repeatImagesData.count
        }
        if tableView == self.KeywordTable {
            count = KeywordsData.count
        }
        if tableView == self.LocationDataTable {
            count = LocationsData.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == self.tableView {
                repeatImagesData.remove(at: indexPath.row)
            }
            if tableView == self.KeywordTable {
                KeywordsData.remove(at: indexPath.row)
            }
            if tableView == self.LocationDataTable {
                LocationsData.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? LocationDataTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? LocationDataTableViewCell else { return }
        
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    //MARK: UIImagePickerControllerDelegate - Functions for image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        if isBoxClicked6 {
            narrativeIllustration.image = selectedImage
            survey?.illustrationImageAsData = selectedImage.jpegData(compressionQuality: 0.10)
            checkBoxButton6.setImage(checkedBox, for: UIControl.State.normal)
            checkBoxButton7.setImage(uncheckedBox, for: UIControl.State.normal)
            isBoxClicked6 = false
            survey?.illustration = true
            save()
        }
        else if isAddLocationPhotoClicked {
            insertLocationPhoto(selectedImage: selectedImage)
        }
        // also save to camera roll as a back up should the app storage fail for some reason
        if picker.sourceType == UIImagePickerController.SourceType.camera {
            UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
        }
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    //MARK: Pickerview Controls
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return categories.count
        }
        else{
            return categoryToShow.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component == 0) {
            return categories[row]
        }
        else{
            return categoryToShow[row]
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if component == 0 {
            categoryToShow = keywords[row]
            CategoryPicker.reloadAllComponents()
            DescriptionBar.text = ""
            if categoryToShow == keywords[9] {
                DescriptionBar.text = "Wildfire burn scar, smoke"
            }
            if categoryToShow == keywords[10] {
                DescriptionBar.text = "Tree line or vegetation advancement"
            }
            DescriptionBar.resignFirstResponder()
            categoryPicked = categories[row]
            keywordpicked = categoryToShow[0]
            CategoryPicker.selectRow(0, inComponent: 1, animated: true)
        }
        if component == 1{
            if categoryToShow == keywords[0] {
                switch(row)
                {
                case 2:
                    DescriptionBar.text = ""
                    break
                case 3:
                    DescriptionBar.text = "Cut blocks, clear cuts, logging roads"
                    break
                case 4:
                    DescriptionBar.text = "Mine scar/pit mining equipment, slag heap"
                    break
                case 5:
                    DescriptionBar.text = "Gas pipelines, nodding donkeys, refineries"
                    break
                case 6:
                    DescriptionBar.text = "Power generation, reservoirs, wind turbines"
                    break
                default:
                    DescriptionBar.text = ""
                }
            }
            if categoryToShow == keywords[1] {
                switch(row)
                {
                case 0:
                    DescriptionBar.text = ""
                    break
                case 1:
                    DescriptionBar.text = "Orchards, groves, vineyards, nurseries, and ornamental areas"
                    break
                default:
                    DescriptionBar.text = ""
                }
            }
            if categoryToShow == keywords[10] {
                switch(row)
                {
                case 0:
                    DescriptionBar.text = "Tree line or vegetation advancement"
                    break
                case 1:
                    DescriptionBar.text = "Tree line or vegetation retreat"
                    break
                case 2:
                    DescriptionBar.text = "Grasslands encroachment"
                    break
                case 3:
                    DescriptionBar.text = "Vegetation composition"
                    break
                case 4:
                    DescriptionBar.text = "Water course change, lake size/shape change, reservoir construction, glacial retreat/advancement"
                    break
                default:
                    DescriptionBar.text = ""
                }
            }
            if categoryToShow == keywords[11] {
                switch(row)
                {
                case 0:
                    DescriptionBar.text = ""
                    break
                case 1:
                    DescriptionBar.text = "Cairn, Survey Marker, Sighting pole"
                    break
                case 2:
                    DescriptionBar.text = "Tools, equipment, gear, horses, wagons"
                    break
                default:
                    DescriptionBar.text = ""
                }
            }
            keywordpicked = categoryToShow[row]
        }
    }
}

//MARK: Extend DetailViewController to conform to collectionView protocols
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LocationsData[collectionView.tag].locationPhotosAsData.count
    }
    
    // Display images in Collection Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationPhotosCollectionViewCell", for: indexPath) as! LocationPhotosCollectionViewCell
        if LocationsData[collectionView.tag].locationPhotosAsData.indices.contains(indexPath.item){
            cell.imageView.image = UIImage(data: LocationsData[collectionView.tag].locationPhotosAsData[indexPath.item]!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        let touchPoint = (collectionView.cellForItem(at: indexPath) as AnyObject).convert(CGPoint.zero, to: self.LocationDataTable)
        if LocationDataTable.indexPathForRow(at: touchPoint)?.row == nil{
            return
        }
        rowSelectedInLocations = (LocationDataTable.indexPathForRow(at: touchPoint)?.row)!
        isALocationPhotoClicked = true
        isAddLocationPhotoClicked = true
        locationPhotoClickedRow = rowSelectedInLocations
        locationPhotoClickedIndexPath = indexPath.row
        let imagePickerController = UIImagePickerController()
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let alert = UIAlertController(title: "Image Source?", message: "Would you like to take a new photo, or use one saved on the iPad?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Take new photo", style: .default, handler: { (action: UIAlertAction!) in
            imagePickerController.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Use saved photo", style: .default, handler: { (action: UIAlertAction!) in
            imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Just view current image", style: .default, handler: { (action: UIAlertAction!) in
            let imageView =  UIImage(data: self.LocationsData[self.rowSelectedInLocations].locationPhotosAsData[self.locationPhotoClickedIndexPath]!)
            //convert above to use locationPhotosAsData
            let newImageView = UIImageView(image: imageView)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Make the background image scale to screen size
extension UIView {
    func addBackground(imageName: String = "YOUR DEFAULT IMAGE NAME", contextMode: UIView.ContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubviewToBack(backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
} // http://stackoverflow.com/questions/27153181/how-do-you-make-a-background-image-scale-to-screen-size-in-swift

//MARK: Close iOS keyboard by touching anywhere
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}//http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

func createPdfFromView(aView: UIView, saveToDocumentsWithFileName fileName: String)
{
    let pdfData = NSMutableData()
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil)
    UIGraphicsBeginPDFPage()
    
    guard let pdfContext = UIGraphicsGetCurrentContext() else { return }
    
    aView.layer.render(in: pdfContext)
    UIGraphicsEndPDFContext() //specifically this?
    
    if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let documentsFileName = documentDirectories + "/" + fileName
        debugPrint(documentsFileName)
        pdfData.write(toFile: documentsFileName, atomically: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
