//
//  KeywordTableViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-22.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class KeywordTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var keyword: UILabel!
    @IBOutlet weak var descriptionComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
