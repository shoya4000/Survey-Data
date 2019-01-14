//
//  SurveyorsViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-05-25.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class SurveyorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var surveyorsTable: UITableView!
    @IBAction func deselectAll(_ sender: Any) {
        for surveyor in selectedSurveyors {
            let index = Int(surveyors.index(of: surveyor)!)
            self.surveyorsTable.deselectRow(at: IndexPath(row: index, section: 0), animated: false)
        }
        selectedSurveyors = [String]()
    }
    var surveyors = [String]()
    var selectedSurveyors = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surveyorsTable.allowsMultipleSelection = true
        
        for surveyor in selectedSurveyors {
            let index = Int(surveyors.index(of: surveyor)!)
            self.surveyorsTable.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {         super.didReceiveMemoryWarning()
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
        return surveyors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyorTableViewCell", for: indexPath) as! SurveyorTableViewCell
        
        // Configure the cell...
        cell.surveyor.text = surveyors[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.blue
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
        selectedSurveyors.insert(surveyors[indexPath.row], at: 0)
    }
    func tableView(_ tableView: UITableView,didDeselectRowAt indexPath: IndexPath) {
        selectedSurveyors = selectedSurveyors.filter{$0 != surveyors[indexPath.row]}
    }
}
