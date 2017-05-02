//
//  TeamNames.swift
//  Survey Data
//
//  Created by Mountain Legacy on 2017-04-27.
//  Copyright © 2017 Mountain Legacy. All rights reserved.
//

import UIKit

class TeamNames: NSObject, NSCoding {
    var mlpTeam = ["Rick Arthur", "Julie Fortin", "Sandra Frey", "Eric Higgs", "Mary Sanseverino", "Shō Ya Voorthuyzen", "Kristen Walsh", "Michael Whitney"]
    var lastNames = ["Arthur", "Fortin", "Frey", "Higgs", "Sanseverino", "Voorthuyzen", "Walsh", "Whitney"]
    
    override init() {
        self.mlpTeam = ["Rick Arthur", "Julie Fortin", "Sandra Frey", "Eric Higgs", "Mary Sanseverino", "Shō Ya Voorthuyzen", "Kristen Walsh", "Michael Whitney"]
        self.lastNames = ["Arthur", "Fortin", "Frey", "Higgs", "Sanseverino", "Voorthuyzen", "Walsh", "Whitney"]
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("TeamNames")
    
    struct PropertyKey {
        static let mlpTeam = "mlpTeam"
        static let lastNames = "lastNames"
    }
    
    init(mlpTeam: [String], lastNames: [String]) {
        self.mlpTeam = mlpTeam
        self.lastNames = lastNames
    }

    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mlpTeam, forKey: PropertyKey.mlpTeam)
        aCoder.encode(lastNames, forKey: PropertyKey.lastNames)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        let mlpTeam = aDecoder.decodeObject(forKey: PropertyKey.mlpTeam) as? [String]
        let lastNames = aDecoder.decodeObject(forKey: PropertyKey.lastNames) as? [String]
        
        self.init(mlpTeam: mlpTeam!, lastNames: lastNames!)
    }
}
