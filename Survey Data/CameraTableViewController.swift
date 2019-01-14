//
//  CameraTableViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-07-11.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class CameraTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newCamera: UITextField!
    @IBOutlet weak var cameraTable: UITableView!
    var selectedCamera = String()
    
    var cameras = CameraNames()
    var cameraNames = [String]()
    
    @IBOutlet weak var navigation: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cameras = loadCameras(){
            cameraNames = cameras.cameras
        }
        else{
            cameraNames = cameras.cameras
        }
        
        //cameraNames = ["Fuji GFX", "Nikon D810", "Nikon D800"]//(cameras?.cameras)!
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewCamera(_:)))
        navigation.rightBarButtonItem = addButton
        
        newCamera.returnKeyType = UIReturnKeyType.go
        
        self.hideKeyboardWhenTappedAround()
    }
    @objc func insertNewCamera(_ sender: Any) {
        if newCamera.text != "" {
            cameraNames.insert(newCamera.text!, at: 0)
            
            cameraTable.reloadData()
            cameras.cameras = cameraNames
            saveCameras()
        }
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
        return cameraNames.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CamerasTableViewCell", for: indexPath) as! CamerasTableViewCell
        
        // Configure the cell...
        cell.name.text = cameraNames[indexPath.row]
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
            cameraNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveCameras()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCamera = cameraNames[indexPath.row]
    }
    func tableView(_ tableView: UITableView,didDeselectRowAt indexPath: IndexPath) {
        selectedCamera = ""
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
    private func saveCameras() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cameras, toFile: CameraNames.ArchiveURL.path)
        if isSuccessfulSave {
            debugPrint("saved cameras")
        }
        else {
            debugPrint("failed to save cameras")
        }
    }
    private func loadCameras() -> CameraNames? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: CameraNames.ArchiveURL.path) as? CameraNames
    }
}
