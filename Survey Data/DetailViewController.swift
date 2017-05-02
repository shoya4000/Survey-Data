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

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate {

    //MARK: Instantiate data
    var survey: Survey?
    var resetSurvey: Survey?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var HistoricSurveyName: UITextField!
    @IBOutlet weak var SurveyYear: UITextField!
    @IBOutlet weak var StationName: UITextField!
    
    @IBOutlet weak var repeatDate: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var finishTime: UITextField!
    
    func updateFinishTime() {
        survey?.finishTime = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        finishTime.text = dateFormatter.string(from: survey!.finishTime! as Date)
    }

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
    @IBOutlet weak var narrativeMap: MKMapView!
    
    @IBOutlet weak var weatherNarrative: UITextView!
    
    @IBOutlet weak var author: UITextField!
    @IBOutlet weak var photographer: UITextField!
    
    //MARK: Save button inputs
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func saveButtonCheckFinish(_ sender: Any) {
        askToSave()
    }
    @IBOutlet weak var saveButtonBottom: UIBarButtonItem!
    @IBAction func saveButtonBottomCheckFinish(_ sender: Any) {
        askToSave()
    }
    
    //MARK: Reset changes to last save
    @IBAction func discardChanges(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Discard Changes?", message: "Would you like to discard recent changes?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.survey = self.resetSurvey?.copySurvey()
        
            self.CategoryPicker.selectRow(0, inComponent: 0, animated: true)
            self.CategoryPicker.selectRow(0, inComponent: 1, animated: true)
            self.viewDidLoad()
            
            self.tableView.reloadData()
            self.KeywordTable.reloadData()
            self.LocationDataTable.reloadData()
            self.viewWillAppear(true)
            self.view.endEditing(true)
            self.performSegue(withIdentifier: "unwindToMasterView", sender: self.saveButton)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    func askToSave() {
        let alert = UIAlertController(title: "Update Finish Time?", message: "Would you like to update the Finish Time?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.updateFinishTime()
            self.resetSurvey = self.survey?.copySurvey()
            self.performSegue(withIdentifier: "unwindToMasterView", sender: self.saveButton)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            self.resetSurvey = self.survey?.copySurvey()
            self.performSegue(withIdentifier: "unwindToMasterView", sender: self.saveButton)
        }))
        alert.addAction(UIAlertAction(title: "Cancel Saving", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        // show the alert
        present(alert, animated: true, completion: nil)
        
        return
    }

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self as? UIPopoverPresentationControllerDelegate
        }
        else {
            guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            resetSurvey = survey?.copySurvey()
            return
            }
            // Configure the destination view controller only when the save button is pressed.
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    @IBAction func unwindToDetailView(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? TeamTableViewController {
            let hikingParty = sourceViewController.selectedPeople
            if survey?.hikingParty == nil {
                survey?.hikingParty = ""
            }
            else {
                survey?.hikingParty = (survey?.hikingParty)! + ","
            }
            for names in hikingParty {
                survey?.hikingParty = (survey?.hikingParty)! + " "
                survey?.hikingParty = (survey?.hikingParty)! + names
                survey?.hikingParty = (survey?.hikingParty)! + ","
            }
            survey?.hikingParty = survey?.hikingParty?.substring(to: (survey?.hikingParty?.index(before: (survey?.hikingParty?.endIndex)!))!)
            hikingDetails.text = survey?.hikingParty
        }
    }
    
    //MARK: Instantiate Checkboxes
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkBoxButton3: UIButton!
    @IBOutlet weak var checkBoxButton4: UIButton!
    @IBOutlet weak var checkBoxButton5: UIButton!
    @IBOutlet weak var checkBoxButton6: UIButton!
    @IBOutlet weak var checkBoxButton7: UIButton!
    
    var checkedBox = UIImage(named: "checked-checkbox-128")
    var uncheckedBox = UIImage(named: "unchecked-checkbox-128")
    
    var noImageSelected = UIImage(named: "no image selected")
    
    var isBoxClicked:Bool!
    var isBoxClicked2:Bool!
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
    var isAddLocationPhotoClicked:Bool!
    var isALocationPhotoClicked:Bool!
    var locationPhotoClickedRow:Int!
    var locationPhotoClickedIndexPath:Int!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    //MARK: Load page functions
    func configureView() {
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        HistoricSurveyName.delegate = self as UITextFieldDelegate
        SurveyYear.delegate = self as UITextFieldDelegate
        StationName.delegate = self as UITextFieldDelegate
        
        repeatDate.delegate = self as UITextFieldDelegate
        startTime.delegate = self as UITextFieldDelegate!
        finishTime.delegate = self as UITextFieldDelegate
        
        getGPS.backgroundColor = .clear
        getGPS.layer.cornerRadius = 5
        getGPS.layer.borderWidth = 2
        getGPS.layer.borderColor = UIColor.blue.cgColor
        
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
                let span = MKCoordinateSpanMake(0.2,0.2)
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
            
            hikingDetails.text = survey.hikingParty
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
                checkBoxButton.setImage(checkedBox, for: UIControlState.normal)
            }
            else {
                checkBoxButton.setImage(uncheckedBox, for: UIControlState.normal)
            }
            locOtherInput.text = survey.locOther
            camOtherInput.text = survey.camOther
            if survey.camera1 != nil && survey.camera1! {
                checkBoxButton3.setImage(checkedBox, for: UIControlState.normal)
            }
            else {
                checkBoxButton3.setImage(uncheckedBox, for: UIControlState.normal)
            }
            if survey.camera2 != nil && survey.camera2! {
                checkBoxButton4.setImage(checkedBox, for: UIControlState.normal)
            }
            else {
                checkBoxButton4.setImage(uncheckedBox, for: UIControlState.normal)
            }
            
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
                checkBoxButton5.setImage(checkedBox, for: UIControlState.normal)
            }
            else {
                checkBoxButton5.setImage(uncheckedBox, for: UIControlState.normal)
            }
            
            if survey.repeatImages != nil {
                repeatImagesData = survey.repeatImages!
            }
            else {
                repeatImagesData = [RepeatImageData]()
            }
            
            stationNarrative.text = survey.stationNarrative

            if survey.illustration != nil && survey.illustration! {
                checkBoxButton6.setImage(checkedBox, for: UIControlState.normal)
                checkBoxButton7.setImage(uncheckedBox, for: UIControlState.normal)
                if survey.illustrationImage != nil{
                    narrativeIllustration.image = survey.illustrationImage
                }
            }
            else {
                checkBoxButton7.setImage(checkedBox, for: UIControlState.normal)
                checkBoxButton6.setImage(uncheckedBox, for: UIControlState.normal)
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
            
            author.text = survey.author
            photographer.text = survey.photographer
        }
        
        // Create resetSurvey to have a point to return to
        resetSurvey = survey?.copySurvey()
        
        // Enable the Save button only if the text field has a valid Survey name.
        updateSaveButtonState()
        
        isBoxClicked = false
        isBoxClicked2 = false
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
        isAddLocationPhotoClicked = false
        isALocationPhotoClicked = false
        locationPhotoClickedRow = 0
        locationPhotoClickedIndexPath = 0
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named:"MLP Logo Watermark")!)
        
        // Date pickers
        datePicker.date = (survey?.repeatDate as Date?)!
        datePicker.datePickerMode = UIDatePickerMode.date
        repeatDate.inputView = datePicker
        timePicker.date = (survey?.repeatDate as Date?)!
        timePicker.datePickerMode = UIDatePickerMode.time
        startTime.inputView = timePicker
        finishTime.inputView = timePicker
        
        let doneBar = UIToolbar()
        doneBar.barStyle = UIBarStyle.default
        doneBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DetailViewController.doneDatePickerPressed))
        
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
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            isBoxClicked6 = true
            let imagePickerController = UIImagePickerController()
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func doneDatePickerPressed(){
        self.view.endEditing(true)
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
    
    // MARK: Check box for iPad
    @IBAction func checkBox(_ sender: Any) {
        if isBoxClicked == true{
            isBoxClicked = false
        }
        else{
            isBoxClicked = true
        }
        if isBoxClicked == true{
            checkBoxButton.setImage(checkedBox, for: UIControlState.normal)
            survey?.iPad = true
        }
        else{
            checkBoxButton.setImage(uncheckedBox, for: UIControlState.normal)
            survey?.iPad = false
        }
    }
    // MARK: Check box for Camera1
    @IBAction func checkBox3(_ sender: Any) {
        if isBoxClicked3 == true{
            isBoxClicked3 = false
        }
        else{
            isBoxClicked3 = true
        }
        if isBoxClicked3 == true{
            checkBoxButton3.setImage(checkedBox, for: UIControlState.normal)
            survey?.camera1 = true
        }
        else{
            checkBoxButton3.setImage(uncheckedBox, for: UIControlState.normal)
            survey?.camera1 = false
        }
    }
    // MARK: Check box for Camera2
    @IBAction func checkBox4(_ sender: Any) {
        if isBoxClicked4 == true{
            isBoxClicked4 = false
        }
        else{
            isBoxClicked4 = true
        }
        if isBoxClicked4 == true{
            checkBoxButton4.setImage(checkedBox, for: UIControlState.normal)
            survey?.camera2 = true
        }
        else{
            checkBoxButton4.setImage(uncheckedBox, for: UIControlState.normal)
            survey?.camera2 = false
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
            checkBoxButton5.setImage(checkedBox, for: UIControlState.normal)
            survey?.gpsActive = true
        }
        else{
            checkBoxButton5.setImage(uncheckedBox, for: UIControlState.normal)
            survey?.gpsActive = false
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
            checkBoxButton6.setImage(checkedBox, for: UIControlState.normal)
            
            // prompt to select image
            // UIImagePickerController is a view controller that lets a user pick media from their photo library.
            let imagePickerController = UIImagePickerController()
            
            // Make sure ViewController is notified when the user picks an image.
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePickerController, animated: true, completion: nil)
            
            checkBoxButton7.setImage(uncheckedBox, for: UIControlState.normal)
            isBoxClicked7 = false
            survey?.illustration = true
        }
        else{
            checkBoxButton6.setImage(uncheckedBox, for: UIControlState.normal)
            // if not no image selected, switch to no image selected
            survey?.illustration = false
            survey?.illustrationImage = noImageSelected
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
            checkBoxButton7.setImage(checkedBox, for: UIControlState.normal)
            // if not no image selected, switch to no image selected
            narrativeIllustration.image = noImageSelected
            
            checkBoxButton6.setImage(uncheckedBox, for: UIControlState.normal)
            isBoxClicked6 = false
            survey?.illustration = false
            survey?.illustrationImage = noImageSelected
        }
        else{
            checkBoxButton7.setImage(uncheckedBox, for: UIControlState.normal)
        }
    }
    
    // MARK: Repeat Image Data components
    
    var repeatImagesData = [RepeatImageData]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var OriginalPhotoNumberInput: UITextField!
    @IBOutlet weak var RepeatPhotoNumberInput: UITextField!
    @IBOutlet weak var azimuthInput: UITextField!
    
    //MARK: General Table control functions
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
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        else if tableView == self.KeywordTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "KeywordTableViewCell", for: indexPath) as! KeywordTableViewCell
            cell.category.text = KeywordsData[indexPath.row].category
            cell.keyword.text = KeywordsData[indexPath.row].keyword
            cell.descriptionComment.text = KeywordsData[indexPath.row].comment
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDataTableViewCell", for: indexPath) as! LocationDataTableViewCell
            cell.LocationName.delegate = self as UITextFieldDelegate
            cell.LocationName.text = LocationsData[indexPath.row].locationName
            cell.LocationNarrative.delegate = self as UITextViewDelegate
            cell.LocationNarrative.text = LocationsData[indexPath.row].locationNarrative
            cell.selectionStyle = UITableViewCellSelectionStyle.none
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    //MARK: Table functions specifically for Repeat Image Data
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
                locationInput.text = ""
                OriginalPhotoNumberInput.text = ""
                RepeatPhotoNumberInput.text = ""
                azimuthInput.text = ""
            }
            isAddRepeatDataClicked = false
        }
    }
    func insertNewRepeatImageData() {
        let newRepeatImageData = RepeatImageData(location: locationInput.text!, originalPhotoNumber: OriginalPhotoNumberInput.text!, repeatPhotoNumber: RepeatPhotoNumberInput.text!, azimuth: Double(azimuthInput.text!))
        repeatImagesData.insert(newRepeatImageData!, at: 0)
        survey?.repeatImages = repeatImagesData
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: Location Narrative
    @IBOutlet weak var narrativeIllustration: UIImageView!
    
    //MARK: UIImagePickerControllerDelegate - Functions for image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as?
            UIImage else {
                fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        if isBoxClicked6 {
            narrativeIllustration.image = selectedImage
            survey?.illustrationImage = selectedImage
            checkBoxButton6.setImage(checkedBox, for: UIControlState.normal)
            checkBoxButton7.setImage(uncheckedBox, for: UIControlState.normal)
            isBoxClicked6 = false
            survey?.illustration = true
        }
        else if isAddLocationPhotoClicked {
            insertLocationPhoto(selectedImage: selectedImage)
        }
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Station Keywords
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var DescriptionBar: UITextField!
    
    var categories = ["1-Urban or Built-up", "2-Agricultural Land", "3-Rangeland", "4-Forest Land", "5-Water", "6-Wetland", "7-Barren Land", "8-Alpine Tundra","9-Perennial Snow/Ice", "Fire", "Change", "Artifacts"]
    var keywords = [["11-Residential", "12-Commercial", "13-Industrial", "→ Forestry", "→ Mining", "→ Hydrocarbons", "→ Electricity", "14-Transportation, communications, and utilities", "15-Industrial and Commercial Complexes", "16-Mixed urban or built-up land", "17-Other urban or built-up land"], ["21-Cropland and pasture", "11-Orchards, groves, vineyards, nurseries, and ornamental areas", "23-Confined feeding operations", "24-Other Agricultural land"] , ["31-Herbaceous Rangeland", "32-Shrub and Brush Rangeland", "33-Mixed Rangeland"] , ["41-Deciduous Forest Land", "42-Evergreen Forest Land", "43-Mixed Forest Land"] , ["51-Streams and Canals", "52-Lakes", "53-Reservoirs", "54-Bays and Estuaries"] , ["61-Forested Wetland", "62-Non-Forested Wetland"] , ["71-Dry Salt Flats", "72-Beaches", "73-Sandy areas other than beaches", "74-Strip mines, quarries, and gravel pits", "76-Transitional areas", "77-Mixed Barren Land"] , ["81-Shrub and Bush Tundra", "82-Herbaceous Tundra", "83-Bare Ground Tundra", "84-Wet Tundra", "85-Mixed Tundra"] , ["91-Perennial Snowfields", "92-Glaciers"] , ["Fire"], ["Change advance", "Change Retreat", "Change Encroach", "Change Composition", "Change in Water"] , ["Human Subject", "Marker", "Equipment", "Historic Structure"]]
    var categoryToShow = [String]()
    
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
    var categoryPicked = "1-Urban or Built-up"
    var keywordpicked = "11-Residential"
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
    
    //MARK: Keyword table outlets and actions
    @IBOutlet weak var KeywordTable: UITableView!
    
    var KeywordsData = [KeywordData]()
    
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
    
    //MARK: Table functions specifically for Keywords
    //Insert selected Keyword
    func insertNewKeyword() {
        let newKeywordData = KeywordData(category: categoryPicked, keyword: keywordpicked, comment: DescriptionBar.text!)
        
        KeywordsData.insert(newKeywordData!, at: 0)
        survey?.keywords = KeywordsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.KeywordTable.insertRows(at: [indexPath], with: .automatic)
    }
    //Insert custom Keyword
    func insertCustomKeyword() {
        let newKeywordData = KeywordData(category: "Custom", keyword: customKeyword.text!, comment: DescriptionBar.text!)
        
        KeywordsData.insert(newKeywordData!, at: 0)
        survey?.keywords = KeywordsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.KeywordTable.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: Location Tables
    @IBOutlet weak var LocationDataTable: UITableView!
    
    var storedOffsets = [Int: CGFloat]()
    
    var LocationsData = [LocationData()]
    
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
    
    // MARK: Table functions specifically for Locations
    func insertLocation() {
        let newLocationData = LocationData()
        
        LocationsData.insert(newLocationData, at: 0)
        survey?.locationsData = LocationsData
        let indexPath = IndexPath(row: 0, section: 0)
        self.LocationDataTable.insertRows(at: [indexPath], with: .automatic)
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
    //rowSelectedInLocations keep track of rowselected for adding photos
    var rowSelectedInLocations = 0
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
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    //MARK: Insert location photo into back data
    func insertLocationPhoto(selectedImage: UIImage) {
        if !LocationsData[rowSelectedInLocations].hasPhotos {
            LocationsData[rowSelectedInLocations].locationPhotos?[0] = selectedImage
        }
        else {
            if isALocationPhotoClicked {
                LocationsData[locationPhotoClickedRow].locationPhotos?[locationPhotoClickedIndexPath] = selectedImage
            }
            else {
                LocationsData[rowSelectedInLocations].locationPhotos?.insert(selectedImage, at: 0)
            }
        }
        LocationsData[rowSelectedInLocations].hasPhotos = true
        survey?.locationsData?[rowSelectedInLocations].locationPhotos = LocationsData[rowSelectedInLocations].locationPhotos
        survey?.locationsData?[rowSelectedInLocations].hasPhotos = LocationsData[rowSelectedInLocations].hasPhotos

        LocationDataTable.reloadData()
        isAddLocationPhotoClicked = false
        isALocationPhotoClicked = false
    }
    
    //MARK: Latitude and longitude displays
    //MARK: Lat and lon Fields
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
    

    //MARK: TextFieldDelegate functions for lat/long
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
    }
    func checkLatFields() {
        if DDLat.text == "" {
            DDLat.text = "0"
        }
        if DMMLatDeg.text == "" {
            DMMLatDeg.text = "0"
        }
        if DMMLatMin.text == "" {
            DMMLatMin.text = "0"
        }
        
        if DMSLatDeg.text == "" {
            DMSLatDeg.text = "0"
        }
        if DMSLatMin.text == "" {
            DMSLatMin.text = "0"
        }
        if DMSLatSec.text == "" {
            DMSLatSec.text = "0"
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
        DMSLonDir.text = survey!.location!.latitude >= 0 ? "E" : "W"
    }
    
    func checkLonFields() {
        if DDLong.text == "" {
            DDLong.text = "0"
        }
        if DMMLonDeg.text == "" {
            DMMLonDeg.text = "0"
        }
        if DMMLonMin.text == "" {
            DMMLonMin.text = "0"
        }
        
        if DMSLonDeg.text == "" {
            DMSLonDeg.text = "0"
        }
        if DMSLonMin.text == "" {
            DMSLonMin.text = "0"
        }
        if DMSLonSec.text == "" {
            DMSLonSec.text = "0"
        }
    }

    func isNumeric(a: String) -> Bool {
        return Double(a) != nil
    }
    
    func updateElevation() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let elevationInMetres = round((survey?.elevationMetres!)!)
        elevMetres.text = numberFormatter.string(from: NSNumber(value: elevationInMetres))
        let elevationInFeet = round((survey?.elevationMetres!)! * 3.28084)
        elevFT.text = numberFormatter.string(from: NSNumber(value: elevationInFeet))
    }
    
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        //MARK: Handle survey, year, and station input
        if textField == self.HistoricSurveyName {
            navigationItem.title = HistoricSurveyName.text
            survey?.historicSurvey = HistoricSurveyName.text!
        }
        if textField == self.SurveyYear {
            if SurveyYear.text == "" {
                SurveyYear.text = "0"
            }
            survey?.year = Int(SurveyYear.text!)!
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
            checkLatFields()
            if isNumeric(a: DDLat.text!) {
                if Double(DDLat.text!) != 0.0 {
                    survey?.location?.latitude = Double(DDLat.text!)!
                }
                else {
                    survey?.location?.latitude = 0
                }
            }
            else {
                DDLat.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DDLong {
            checkLonFields()
            if isNumeric(a: DDLong.text!) {
                survey?.location?.longitude = Double(DDLong.text!)!
            }
            else {
                DDLong.text = ""
            }
            updateAllLonFields()
        }
        
        //MARK: Handle DMM input
        if textField == self.DMMLatDeg {
            checkLatFields()
            if isNumeric(a: DMMLatDeg.text!) {
                survey?.location?.latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
            }
            else {
                DMMLatDeg.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DMMLatMin {
            checkLatFields()
            if isNumeric(a: DMMLatMin.text!) {
                survey?.location?.latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
            }
            else {
                DMMLatMin.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DMMLatDir && DMMLatDir.text != "" {
            checkLatFields()
            survey?.location?.latitude = DMMtoDD(latDeg: Double(DMMLatDeg.text!)!, latMin: Double(DMMLatMin.text!)!, latDir: DMMLatDir.text, longDeg: 0, longMin: 0, longDir: "").latitude
            updateAllLatFields()
        }
        if textField == self.DMMLonDeg {
            checkLonFields()
            if isNumeric(a: DMMLonDeg.text!) {
                survey?.location?.longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
            }
            else {
                DMMLonDeg.text = ""
            }
            updateAllLonFields()
        }
        if textField == self.DMMLonMin {
            checkLonFields()
            if isNumeric(a: DMMLonMin.text!) {
                survey?.location?.longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
            }
            else {
                DMMLonMin.text = ""
            }
            updateAllLonFields()
        }
        if textField == self.DMMLonDir && DMMLonDir.text != "" {
            checkLonFields()
            survey?.location?.longitude = DMMtoDD(latDeg: 0, latMin: 0, latDir: "", longDeg: Double(DMMLonDeg.text!)!, longMin: Double(DMMLonMin.text!)!, longDir: DMMLonDir.text).longitude
            updateAllLonFields()
        }

        //MARK: Handle DMS input
        if textField == self.DMSLatDeg {
            checkLatFields()
            if isNumeric(a: DMSLatDeg.text!) {
                survey?.location?.latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
            }
            else {
                DMSLatDeg.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatMin {
            checkLatFields()
            if isNumeric(a: DMSLatMin.text!) {
                survey?.location?.latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
            }
            else{
                DMSLatMin.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatSec {
            checkLatFields()
            if isNumeric(a: DMSLatSec.text!) {
                survey?.location?.latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
            }
            else{
                DMSLatSec.text = ""
            }
            updateAllLatFields()
        }
        if textField == self.DMSLatDir && DMMLatDir.text != "" {
            checkLatFields()
            survey?.location?.latitude = DMStoDD(latDeg: Double(DMSLatDeg.text!)!, latMin: Double(DMSLatMin.text!)!, latSec: Double(DMSLatSec.text!)!, latDir: DMSLatDir.text, longDeg: 0, longMin: 0, longSec: 0, longDir: "").latitude
            updateAllLatFields()
        }
        if textField == self.DMSLonDeg {
            checkLonFields()
            if isNumeric(a: DMSLonDeg.text!) {
                survey?.location?.longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
            }
            else {
                DMSLonDeg.text = ""
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonMin {
            checkLonFields()
            if isNumeric(a: DMSLonMin.text!) {
                survey?.location?.longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
            }
            else {
                DMSLonMin.text = ""
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonSec {
            checkLonFields()
            if isNumeric(a: DMSLonSec.text!) {
                survey?.location?.longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
            }
            else {
                DMSLonSec.text = ""
            }
            updateAllLonFields()
        }
        if textField == self.DMSLonDir && DMSLonDir.text != "" {
            checkLonFields()
            survey?.location?.longitude = DMStoDD(latDeg: 0, latMin: 0, latSec: 0, latDir: "", longDeg: Double(DMSLonDeg.text!)!, longMin: Double(DMSLonMin.text!)!, longSec: Double(DMSLonSec.text!)!, longDir: DMSLonDir.text).longitude
            updateAllLonFields()
        }
        
        if textField == self.hikingDetails {
            survey?.hikingParty = hikingDetails.text
        }
        if textField == self.pilotName {
            survey?.pilot = pilotName.text
        }
        if textField == self.rwCallSign {
            survey?.rwCallSign = rwCallSign.text
        }
        
        if textField == self.windSpeed {
            if windSpeed.text == "" {
                windSpeed.text = "0"
            }
            if isNumeric(a: windSpeed.text!) {
                survey?.averageWindSpeed = Double(windSpeed.text!)!
            }
            windSpeed.text = String(format: "%.1f", (survey?.averageWindSpeed!)!)
        }
        if textField == self.temp {
            if temp.text == "" {
                temp.text = "0"
            }
            if isNumeric(a: temp.text!) {
                survey?.temperature = Double(temp.text!)!
            }
            temp.text = String(format: "%.1f", (survey?.temperature!)!)
        }
        if textField == self.baroPress {
            if baroPress.text == "" {
                baroPress.text = "0"
            }
            if isNumeric(a: baroPress.text!) {
                survey?.barometricPressure = Double(baroPress.text!)!
            }
            baroPress.text = String(format: "%.1f", (survey?.barometricPressure!)!)
        }
        if textField == self.gustSpeed {
            if gustSpeed.text == "" {
                gustSpeed.text = "0"
            }
            if isNumeric(a: gustSpeed.text!) {
                survey?.maximumGustSpeed = Double(gustSpeed.text!)!
            }
            gustSpeed.text = String(format: "%.1f", (survey?.maximumGustSpeed!)!)
        }
        if textField == self.humidity {
            if humidity.text == "" {
                humidity.text = "0"
            }
            if isNumeric(a: humidity.text!) {
                survey?.relativeHumidity = Double(humidity.text!)!
            }
            humidity.text = String(format: "%.1f", (survey?.relativeHumidity!)!)
        }
        if textField == self.wetBulb {
            if wetBulb.text == "" {
                wetBulb.text = "0"
            }
            if isNumeric(a: wetBulb.text!) {
                survey?.wetBulbReading = Double(wetBulb.text!)!
            }
            wetBulb.text = String(format: "%.1f", (survey?.wetBulbReading!)!)
        }

        if textField == self.locOtherInput {
            survey?.locOther = locOtherInput.text
        }
        if textField == self.camOtherInput {
            survey?.camOther = camOtherInput.text
        }
        
        if textField == self.elevMetres {
            if elevMetres.text == "" {
                elevMetres.text = "0"
            }
            elevMetres.text = elevMetres.text?.replacingOccurrences(of: ",", with: "")
            if isNumeric(a: elevMetres.text!) {
                survey?.elevationMetres = Double(elevMetres.text!)
            }
            updateElevation()
        }
        if textField == self.elevFT {
            if elevFT.text == "" {
                elevFT.text = "0"
            }
            elevFT.text = elevFT.text?.replacingOccurrences(of: ",", with: "")
            if isNumeric(a: elevFT.text!) {
                survey?.elevationMetres = Double(elevFT.text!)! / 3.28084
            }
            updateElevation()
        }
        if textField == self.elevComments {
            survey?.elevationComments = elevComments.text
        }
        
        if textField == self.cardNumber {
            if cardNumber.text == "" {
                cardNumber.text = "0"
            }
            if isNumeric(a: cardNumber.text!) {
                survey?.cardNumber = Int(cardNumber.text!)
            }
            else {
                cardNumber.text = String(format: "%d", (survey?.cardNumber)!)
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
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            textView.selectAll(nil)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.stationNarrative {
            survey?.stationNarrative = stationNarrative.text
            if (survey?.author == nil || survey?.author == "") && survey?.hikingParty != nil && textView.text != "" {
                let possibleAuthors = survey?.hikingParty?.characters.split(separator: ",").map(String.init)
                let alert = UIAlertController(title: "Author?", message: "Who authored this narrative?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                for author in possibleAuthors! {
                    alert.addAction(UIAlertAction(title: author, style: .default, handler: { (action: UIAlertAction!) in
                        self.survey?.stationNarrative = (self.survey?.stationNarrative)! + "\n~\(author)"
                        self.stationNarrative.text = self.survey?.stationNarrative
                    }))
                }
                // show the alert
                present(alert, animated: true, completion: nil)
            }
        }
        
        if textView == self.weatherNarrative {
            survey?.weatherNarrative = weatherNarrative.text
            if (survey?.author == nil || survey?.author == "") && survey?.hikingParty != nil && textView.text != "" {
                let possibleAuthors = survey?.hikingParty?.characters.split(separator: ",").map(String.init)
                let alert = UIAlertController(title: "Author?", message: "Who authored this narrative?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                for author in possibleAuthors! {
                    alert.addAction(UIAlertAction(title: author, style: .default, handler: { (action: UIAlertAction!) in
                        self.survey?.weatherNarrative = (self.survey?.weatherNarrative)! + "\n~\(author)"
                        self.weatherNarrative.text = self.survey?.weatherNarrative
                    }))
                }
                // show the alert
                present(alert, animated: true, completion: nil)
            }
        }
        
        let touchPoint = (textView).convert(CGPoint.zero, to: self.LocationDataTable)
        let indexPath = LocationDataTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let cell = LocationDataTable.cellForRow(at: indexPath!) as! LocationDataTableViewCell
            if textView == cell.LocationNarrative {
                survey?.locationsData?[(indexPath?.row)!].locationNarrative = textView.text!
                if (survey?.author == nil || survey?.author == "") && survey?.hikingParty != nil && textView.text != ""  {
                    let possibleAuthors = survey?.hikingParty?.characters.split(separator: ",").map(String.init)
                    let alert = UIAlertController(title: "Author?", message: "Who authored this narrative?", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add the actions (buttons)
                    for author in possibleAuthors! {
                        alert.addAction(UIAlertAction(title: author, style: .default, handler: { (action: UIAlertAction!) in
                            self.survey?.locationsData?[(indexPath?.row)!].locationNarrative = (self.survey?.locationsData?[(indexPath?.row)!].locationNarrative)! + "\n~\(author)"
                            textView.text = self.survey?.locationsData?[(indexPath?.row)!].locationNarrative
                        }))
                    }
                    // show the alert
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    //MARK: SaveButton controls
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.hikingDetails {
            performSegue(withIdentifier: "popoverSegue", sender: nil)
        }
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
        // Disable the Save button while editing.
        saveButton.isEnabled = false
        saveButtonBottom.isEnabled = false
    }
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text1 = HistoricSurveyName.text ?? ""
        let text2 = SurveyYear.text ?? ""
        let text3 = StationName.text ?? ""
        
        saveButton.isEnabled = !text1.isEmpty && !text2.isEmpty && !text3.isEmpty
        saveButtonBottom.isEnabled = !text1.isEmpty && !text2.isEmpty && !text3.isEmpty
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        survey?.location = center
        updateAllLatFields()
        updateAllLonFields()
        narrativeMap.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
}

//MARK: Extend DetailViewController to conform to collectionView protocols
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LocationsData[collectionView.tag].locationPhotos!.count
    }
    
    // Display images in Collection Cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationPhotosCollectionViewCell", for: indexPath) as! LocationPhotosCollectionViewCell
        
        cell.imageView.image = LocationsData[collectionView.tag].locationPhotos![indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        let touchPoint = (collectionView.cellForItem(at: indexPath) as AnyObject).convert(CGPoint.zero, to: self.LocationDataTable)
        rowSelectedInLocations = (LocationDataTable.indexPathForRow(at: touchPoint)?.row)!
        isALocationPhotoClicked = true
        isAddLocationPhotoClicked = true
        locationPhotoClickedRow = rowSelectedInLocations
        locationPhotoClickedIndexPath = indexPath.row
        let imagePickerController = UIImagePickerController()
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePickerController, animated: true, completion: nil)
    }
}
