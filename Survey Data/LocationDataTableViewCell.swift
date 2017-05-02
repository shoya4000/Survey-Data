//
//  LocationDataTableViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class LocationDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var LocationName: UITextField!
    @IBOutlet weak var LocationNarrative: UITextView!
    @IBOutlet weak var LocationPhotos: UICollectionView!
    @IBOutlet weak var CellContent: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        LocationPhotos.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: Extend the tableViewCell to allow for the collectionView
extension LocationDataTableViewCell {
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        
        LocationPhotos.delegate = dataSourceDelegate
        LocationPhotos.dataSource = dataSourceDelegate
        LocationPhotos.tag = row
        LocationPhotos.setContentOffset(LocationPhotos.contentOffset, animated:false) // Stops collection view if it was scrolling.
        LocationPhotos.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { LocationPhotos.contentOffset.x = newValue }
        get { return LocationPhotos.contentOffset.x }
    }
}
/* Managed to get textField and textView editable via:

func textFieldDidBeginEditing(_ textField: UITextField) {
    let touchPoint = (textField).convert(CGPoint.zero, to: self.LocationDataTable)
    let cell = LocationDataTable.cellForRow(at: (LocationDataTable.indexPathForRow(at: touchPoint))!) as! LocationDataTableViewCell
    if textField == cell.LocationName {
        debugPrint("selected textfield in row")
    }
}

func textFieldDidEndEditing(_ textField: UITextField) {
    let touchPoint = (textField).convert(CGPoint.zero, to: self.LocationDataTable)
    let indexPath = LocationDataTable.indexPathForRow(at: touchPoint)
    let cell = LocationDataTable.cellForRow(at: indexPath!) as! LocationDataTableViewCell
    if textField == cell.LocationName {
        debugPrint("changing locationname at: ")
        debugPrint(indexPath?.row)
        debugPrint("to: ")
        debugPrint(textField.text!)
        survey?.locationsData?[(indexPath?.row)!].locationName = textField.text!
    }
}

func textViewDidEndEditing(_ textView: UITextView) {
    let touchPoint = (textView).convert(CGPoint.zero, to: self.LocationDataTable)
    let indexPath = LocationDataTable.indexPathForRow(at: touchPoint)
    let cell = LocationDataTable.cellForRow(at: indexPath!) as! LocationDataTableViewCell
    if textView == cell.LocationNarrative {
        survey?.locationsData?[(indexPath?.row)!].locationNarrative = textView.text!
    }
}
*/
