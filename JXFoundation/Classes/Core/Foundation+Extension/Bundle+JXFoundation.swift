//
//  Bundle+JXFoundation.swift
//  JXFoundation
//
//  Created by 飞亦 on 10/12/19.
//

import Foundation

public extension Bundle {
   
    func jxLocalizedString(forKey key: String) -> String {
        return self.jxLocalizedString(forKey: key, value: nil, table: nil)
    }
    func jxLocalizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = self.getBundle() {
            
            guard var language = NSLocale.preferredLanguages.first else { return "" }
            if language.hasPrefix("en") {
                language = "en"
            } else if language.hasPrefix("zh") {
                language = "zh-Hans"
            } else if language.hasPrefix("ko") {
                language = "ko"
            } else if language.hasPrefix("ja") {
                language = "ja"
            } else {
                language = "en"
            }
            guard let path = bundle.path(forResource: language, ofType: "lproj") else {
                return ""
            }
            let languageBundle = Bundle(path: path)
            let value = languageBundle?.localizedString(forKey: key, value: value, table: tableName)
            return Bundle.main.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return self.localizedString(forKey: key, value: value, table: tableName)
        }
       
    }
    func getBundle() -> Bundle? {
        
        guard
            let path = Bundle.init(for: Bundle.self).path(forResource: "JXFoundation", ofType: "bundle"),
            let customBundle = Bundle(path: path) else {
          
            return nil
        }
    
        return customBundle
    }
    
}
