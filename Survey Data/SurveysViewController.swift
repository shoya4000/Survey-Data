//
//  SurveysViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-05-25.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class SurveysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var surveysTable: UITableView!
    @IBAction func deselectAll(_ sender: Any) {
        for survey in selectedSurveys {
            let index = Int(surveys.firstIndex(of: survey)!)
            self.surveysTable.deselectRow(at: IndexPath(row: index, section: 0), animated: false)
        }
        selectedSurveys = [SurveyTextOnly]()
    }
    var surveys = [SurveyTextOnly]()
    var selectedSurveys = [SurveyTextOnly]()
    var shownSelectedSurveys  = [SurveyTextOnly]()
    
    var surveysSearchResults  = [SurveyTextOnly]()
    
    var searchController: UISearchController!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        surveysTable.allowsMultipleSelection = true
        searchBar.delegate = self
        selectRows()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.surveysSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = self.surveysTable.dequeueReusableCell(withIdentifier: "SurveyTableViewCell", for: indexPath) as! SurveyTableViewCell
        
        let object = (surveysSearchResults[indexPath.row])
        
        cell.SurveyName.text = object.historicSurvey
        cell.Year.text = "\(object.year)"
        cell.Station.text = object.stationName
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        cell.RepeatDate.text = dateFormatter.string(from: object.repeatDate as Date)
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSurveys.insert(surveysSearchResults[indexPath.row], at: 0)
    }
    func tableView(_ tableView: UITableView,didDeselectRowAt indexPath: IndexPath) {
        selectedSurveys = selectedSurveys.filter{$0 != surveys[indexPath.row]}
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.surveysSearchResults = self.surveys.filter({( aSurvey: SurveyTextOnly) -> Bool in
            return aSurvey.allText.lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.text = ""
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.filterContentForSearchText(searchText: searchBar.text!)
        deselectAll(UISearchBar.self)
        surveysTable.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        selectRows()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        deselectAll(UISearchBar.self)
        selectedSurveys = shownSelectedSurveys
        surveysSearchResults = surveys
        surveysTable.reloadData()
        selectRows()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filterContentForSearchText(searchText: searchBar.text!)
        surveysTable.reloadData()
        searchBar.resignFirstResponder()
        selectRows()
    }
    
    func selectRows(){
        for survey in shownSelectedSurveys {
            if surveysSearchResults.firstIndex(of: survey) != nil {
                let index = Int(surveysSearchResults.firstIndex(of: survey)!)
            self.surveysTable.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
                selectedSurveys.insert(surveysSearchResults[index], at: 0)
            }
        }
    }
}
