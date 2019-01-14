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
    @IBOutlet weak var elevation: UITextField!
    @IBOutlet weak var getGPS: UIButton!
    @IBOutlet weak var gpsLatDeg: UITextField!
    @IBOutlet weak var gpsLatMin: UITextField!
    @IBOutlet weak var gpsLatDir: UITextField!
    @IBOutlet weak var gpsLonDeg: UITextField!
    @IBOutlet weak var gpsLonMin: UITextField!
    @IBOutlet weak var gpsLonDir: UITextField!
    @IBOutlet weak var LocationPhotos: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gpsLatDeg.keyboardType = UIKeyboardType.numberPad
        gpsLatMin.keyboardType = UIKeyboardType.numberPad
        gpsLonDeg.keyboardType = UIKeyboardType.numberPad
        gpsLonMin.keyboardType = UIKeyboardType.numberPad
        
        getGPS.backgroundColor = .clear
        getGPS.layer.cornerRadius = 3
        getGPS.layer.borderWidth = 2
        getGPS.layer.borderColor = UIColor.blue.cgColor
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
