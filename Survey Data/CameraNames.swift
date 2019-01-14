//
//  CameraNames.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-07-11.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class CameraNames: NSObject, NSCoding {
    var cameras = ["Fuji GFX", "Nikon D810", "Nikon D800"]
    
    override init() {
        self.cameras = ["Fuji GFX", "Nikon D810", "Nikon D800"]
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Cameras")
    
    struct PropertyKey {
        static let cameras = "cameras"
    }
    
    init(cameras: [String]) {
        self.cameras = cameras
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cameras, forKey: PropertyKey.cameras)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let cameras = aDecoder.decodeObject(forKey: PropertyKey.cameras) as? [String]
        
        self.init(cameras: cameras!)
    }
}
