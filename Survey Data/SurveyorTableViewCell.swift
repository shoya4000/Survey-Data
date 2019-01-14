//
//  SurveyorTableViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-05-25.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class SurveyorTableViewCell: UITableViewCell {

    @IBOutlet weak var surveyor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
