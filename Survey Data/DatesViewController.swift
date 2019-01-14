//
//  DatesViewController.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-05-25.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class DatesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var datePicker1: UIPickerView!
    @IBOutlet weak var datePicker2: UIPickerView!
    var years = [Int]()
    var selectedYears = [0, 0]
    var selectedMonths = [1, 12]
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    override func viewDidLoad() {
        self.datePicker2.selectRow(years.count - 1, inComponent: 0, animated: true)
        self.datePicker1.selectRow(selectedMonths[0] - 1, inComponent: 1, animated: true)
        self.datePicker2.selectRow(selectedMonths[1] - 1, inComponent: 1, animated: true)
        super.viewDidLoad()
        selectedYears[0] = years[0]
        selectedYears[1] = years[years.count - 1]
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
    
    //MARK: Pickerview Controls
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        }
        else {
            return 12
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(years[row])
        }
        else {
            return months[row]
        }
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if pickerView == datePicker1 {
            if component == 0 {
                let selected = years[row]
                if selected <= selectedYears[1] {
                    selectedYears[0] = selected
                }
                else {
                    selectedYears[0] = selectedYears[1]
                    selectedYears[1] = selected
                }
            }
            else {
                selectedMonths[0] = row + 1
            }
        }
        if pickerView == datePicker2 {
            if component == 0 {
                let selected = years[row]
                if selected >= selectedYears[0] {
                    selectedYears[1] = selected
                }
                else {
                    selectedYears[1] = selectedYears[0]
                    selectedYears[0] = selected
                }
            }
            else {
                selectedMonths[1] = row + 1
            }
        }
    }
}
