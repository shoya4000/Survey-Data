//
//  RepeatImageDataViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-15.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class RepeatImageDataViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var originalPhotoNumberField: UILabel!
    @IBOutlet weak var repeatImageNumberField: UILabel!
    @IBOutlet weak var azimuthField: UILabel!
    @IBOutlet weak var notesField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
