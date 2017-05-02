//
//  LocationPhotosCollectionViewCell.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-04-25.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class LocationPhotosCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 202, height: 202))
        super.init(frame: frame)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        contentView.addSubview(imageView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let frame = CGRect(x: 0, y: 0, width: 202, height: 202)
        self.init(frame: frame)
    }
}
