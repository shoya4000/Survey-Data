//
//  MapViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-05-19.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var surveysText = [SurveyTextOnly]()
    var subsetOfSurveys = [SurveyTextOnly]()
    var isSubSetEmpty = false
    var selectedMonths = [1, 12]
    
    @IBOutlet weak var map: MKMapView!
    @IBAction func showAll(_ sender: Any) {
        subsetOfSurveys = surveysText
        self.viewDidLoad()
    }

    @IBAction func unwindToMapViewFromSurveyors(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? SurveyorsViewController {
            let selectedSurveyors = sourceViewController.selectedSurveyors
            if !sourceViewController.selectedSurveyors.isEmpty {
                subsetOfSurveys = [SurveyTextOnly]()
                for surveyor in selectedSurveyors {
                    for survey in surveysText {
                        if survey.historicSurvey == surveyor {
                            subsetOfSurveys.append(survey)
                        }
                    }
                }
            }
        }
        self.viewDidLoad()
    }
    @IBAction func unwindToMapViewFromSurveys(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? SurveysViewController {
            if !sourceViewController.selectedSurveys.isEmpty {
                subsetOfSurveys = sourceViewController.selectedSurveys
            }
        }
        self.viewDidLoad()
    }
    @IBAction func unwindToMapViewFromDates(sender:UIStoryboardSegue){
        if let sourceViewController = sender.source as? DatesViewController {
            var years = sourceViewController.selectedYears
            let months = sourceViewController.selectedMonths
            selectedMonths = sourceViewController.selectedMonths
            years[0] = (years[0] * 100) + months[0]
            years[1] = (years[1] * 100) + months[1]
            let ifEmpty = subsetOfSurveys
            subsetOfSurveys = [SurveyTextOnly]()
            for survey in surveysText {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                var year = Int(dateFormatter.string(from: survey.repeatDate as Date))!
                dateFormatter.dateFormat = "MM"
                let month = Int(dateFormatter.string(from: survey.repeatDate as Date))!
                year = (year * 100) + month
                if year >= years[0] && year <= years[1] {
                    subsetOfSurveys.append(survey)
                }
            }
            isSubSetEmpty = subsetOfSurveys.isEmpty
            if subsetOfSurveys.isEmpty {
                subsetOfSurveys = ifEmpty
            }
        }
        self.viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var annotations = [MKAnnotation]()
        for survey in subsetOfSurveys {
            if survey.location.latitude == 0 && survey.location.longitude == 0 {
                continue
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = survey.location
            annotation.title = survey.historicSurvey
            annotation.subtitle = survey.stationName
            annotations.append(annotation)
        }
        map.showAnnotations(annotations, animated: true) //this centers the view and shows all the annotated points
        
        if isSubSetEmpty {
            let thePresentedVC : UIViewController? = self.presentedViewController as UIViewController?
            let alert = UIAlertController(title: "No Surveys in this range", message: "", preferredStyle: UIAlertController.Style.alert)
            thePresentedVC?.present(alert, animated: true, completion: nil)
            //Alert is presented from the popover
            
            isSubSetEmpty = false
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "popoverToSurveyors" {
            let popoverViewController = segue.destination as! SurveyorsViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self as? UIPopoverPresentationControllerDelegate
            var surveyors = [String]()
            for survey in surveysText {
                surveyors.append(survey.historicSurvey)
            }
            popoverViewController.surveyors = surveyors
            var selectedSurveyors = [String]()
            for survey in subsetOfSurveys {
                selectedSurveyors.append(survey.historicSurvey)
            }
            popoverViewController.selectedSurveyors = selectedSurveyors
        }
        else if segue.identifier == "popoverToSurveys" {
            let popoverViewController = segue.destination as! SurveysViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self as? UIPopoverPresentationControllerDelegate
            popoverViewController.surveys = surveysText
            popoverViewController.surveysSearchResults = surveysText
            popoverViewController.selectedSurveys = subsetOfSurveys
            popoverViewController.shownSelectedSurveys = subsetOfSurveys
        }
        else if segue.identifier == "popoverToDates" {
            let popoverViewController = segue.destination as! DatesViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self as? UIPopoverPresentationControllerDelegate
            var years = [Int]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            for survey in surveysText {
                years.append(Int(dateFormatter.string(from: survey.repeatDate as Date))!)
            }
            years = Array(Set(years))
            years.sort()
            popoverViewController.years = years
            popoverViewController.selectedMonths = selectedMonths
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            for survey in surveysText {
                if survey.location.latitude == view.annotation?.coordinate.latitude && survey.location.longitude == view.annotation?.coordinate.longitude {
                    subsetOfSurveys = [survey]
                }
            }
            performSegue(withIdentifier: "unwindToMasterViewFromMap", sender: control)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        let button = UIButton(type: UIButton.ButtonType.detailDisclosure) as UIButton
        
        pinView?.rightCalloutAccessoryView = button
        
        return pinView
    }
}
