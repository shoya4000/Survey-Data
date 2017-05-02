//
//  KeywordData.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-03-22.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit
import os.log

class KeywordData: NSObject, NSCoding, NSCopying {
    
    //MARK: Properties
    
    var category: String
    var keyword: String
    var comment: String?
    
    struct PropertyKey {
        static let category = "category"
        static let keyword = "keyword"
        static let comment = "comment"
    }
    
    init?(category: String, keyword: String, comment: String?) {
        
        // Initialization should fail if there is no location, originalPhotoNumber, or repeatPhotonumber.
        guard !category.isEmpty || !keyword.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.category = category
        self.keyword = keyword
        self.comment = comment
        
        super.init()
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(keyword, forKey: PropertyKey.keyword)
        aCoder.encode(comment, forKey: PropertyKey.comment)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The category and keyword are required. If we cannot decode them, the initializer should fail.
        guard let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String, let keyword = aDecoder.decodeObject(forKey: PropertyKey.keyword) as? String else {
            os_log("Unable to decode KeywordData", log: OSLog.default, type: .debug)
            return nil
        }
        // Because the comment is optional, just use conditional cast.
        let comment = aDecoder.decodeObject(forKey: PropertyKey.comment) as? String
        
        self.init(category: category, keyword: keyword, comment: comment)
    }
    
    //MARK: NSCopying
    init(copy:KeywordData) {
        category = copy.category
        keyword = copy.keyword
        comment = copy.comment
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        return KeywordData(copy: self)
    }
}
