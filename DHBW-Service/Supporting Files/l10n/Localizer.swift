//
//  Localizer.swift
//  DHBW-Service
//
//  Created by Patrick Müller on 22.12.20.
//

import Foundation

private class Localizer {
    
    static let sharedInstance = Localizer()
    
    func localize(string: String, tableName: String, plural: Bool) -> String {
        var localizedString: String
        if plural{
            localizedString = NSLocalizedString(string, tableName: tableName, value:"**\(self)**", comment: "plural")
        }else{
            localizedString = NSLocalizedString(string, tableName: tableName, value:"**\(self)**", comment: "")
        }
        
        return localizedString
    }
}

extension String {
    func localized(tableName: String = "Localizable", plural: Bool = false) -> String {
        return Localizer.sharedInstance.localize(string: self, tableName: tableName, plural: plural)
    }
}
