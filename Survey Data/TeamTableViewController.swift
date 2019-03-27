//
//  MLPTeamTableViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-04-27.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class TeamTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var teamTable: UITableView!
    @IBOutlet weak var newName: UITextField!
    var selectedPeople = [String]()
    var names = TeamNames()
    var mlpTeam = [String]()
    var lastNames = [String]()
    var order: Dictionary<String, String> = [:]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        selectedPeople = selectedPeople.sorted(by:<)
        if selectedPeople.count != 0 {
            for index in 0...selectedPeople.count-1 {
            selectedPeople[index] = order[selectedPeople[index]]!
            }
        }
    }
    @IBOutlet weak var navigation: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        teamTable.allowsMultipleSelection = true
        
        if let names = loadNames() {
            mlpTeam = names.mlpTeam
            lastNames = names.lastNames
        }
        else {
            mlpTeam = names.mlpTeam
            lastNames = names.lastNames
        }
        for index in 0...mlpTeam.count-1 {
            order[lastNames[index]] = mlpTeam[index]
        }
        for people in selectedPeople {
            if mlpTeam.firstIndex(of: people) != nil {
                teamTable.selectRow(at: IndexPath(row: mlpTeam.firstIndex(of: people)!, section: 0), animated: true, scrollPosition: .none)
            }
            else {
                mlpTeam.insert(people, at: 0)
                let split = people.characters.split(separator: " ")
                let newLastName = String(split.suffix(1).joined(separator: [" "]))
                
                lastNames.insert(newLastName, at: 0)
                
                for index in 0...mlpTeam.count-1 {
                    order[lastNames[index]] = mlpTeam[index]
                }
                alphabetSortLastNames()
                newName.text = ""
                teamTable.reloadData()
                names.mlpTeam = mlpTeam
                names.lastNames = lastNames
                saveNames()
                teamTable.selectRow(at: IndexPath(row: mlpTeam.firstIndex(of: people)!, section: 0), animated: true, scrollPosition: .none)
            }
        }
        if selectedPeople.count != 0 {
            for index in 0...selectedPeople.count-1 {
            let split = selectedPeople[index].characters.split(separator: " ")
            let newLastName = String(split.suffix(1).joined(separator: [" "]))
            selectedPeople[index] = newLastName
            }
        }
                
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewTeamMember(_:)))
        navigation.rightBarButtonItem = addButton
        
        newName.returnKeyType = UIReturnKeyType.go
        
        self.hideKeyboardWhenTappedAround() 
    }
    @objc func insertNewTeamMember(_ sender: Any) {
        if newName.text != "" {
            mlpTeam.insert(newName.text!, at: 0)
            let split = newName.text?.characters.split(separator: " ")
            let newLastName = String(split!.suffix(1).joined(separator: [" "]))

            lastNames.insert(newLastName, at: 0)
            for index in 0...mlpTeam.count-1 {
                order[lastNames[index]] = mlpTeam[index]
            }
            alphabetSortLastNames()
            newName.text = ""
            teamTable.reloadData()
            names.mlpTeam = mlpTeam
            names.lastNames = lastNames
            saveNames()
        }
    }
    func alphabetSortLastNames(){
        var sortedNames = Array(order.keys).sorted(by:<)
        lastNames = sortedNames
        for index in 0...mlpTeam.count-1 {
            sortedNames[index] = order[sortedNames[index]]!
        }
        mlpTeam = sortedNames
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mlpTeam.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MLPTeamTableViewCell", for: indexPath) as! MLPTeamTableViewCell
        
        // Configure the cell...
        cell.name.text = mlpTeam[indexPath.row]
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
            mlpTeam.remove(at: indexPath.row)
            lastNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            names.mlpTeam = mlpTeam
            names.lastNames = lastNames
            saveNames()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPeople.insert(lastNames[indexPath.row], at: 0)
    }
    func tableView(_ tableView: UITableView,didDeselectRowAt indexPath: IndexPath) {
        selectedPeople = selectedPeople.filter{$0 != lastNames[indexPath.row]}
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func saveNames() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(names, toFile: TeamNames.ArchiveURL.path)
        if isSuccessfulSave {
            debugPrint("saved names")
        }
        else {
            debugPrint("failed to save names")
        }
    }
    private func loadNames() -> TeamNames? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: TeamNames.ArchiveURL.path) as? TeamNames
    }
}
