//
//  SurveyTableViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-04-03.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var SurveyName: UILabel!
    @IBOutlet weak var Year: UILabel!
    @IBOutlet weak var Station: UILabel!
    @IBOutlet weak var RepeatDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
