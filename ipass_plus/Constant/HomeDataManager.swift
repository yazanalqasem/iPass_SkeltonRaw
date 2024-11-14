//  LocalStore.swift
//  cc
//  Created by Mobile on 09/06/23.

import UIKit

class HomeDataManager : NSObject {
    
    static let shared = HomeDataManager()
    
    
    var tokenKey = "tokenKey"
    
    let dictionary1: [String: Any] = ["id": "1", "key2": 42]
    
    var languageCodeString = "en"
    
    
    
   
    
    var getHomeData: [[String: String]] {
        var dictionaries = [[String: String]]()
        
        
        var currentLanguage = "en"
        if let preferredLanguageCode = Locale.preferredLanguages.first {
             currentLanguage = Locale(identifier: preferredLanguageCode).languageCode ?? "en"
            print("Device's preferred language code: \(currentLanguage)")
            languageCodeString = currentLanguage
          
        } else {
            print("Unable to determine the device's preferred language code.")
        }
        
//
        // Create a dictionary and add it to the array.
        let object1: [String: String] = ["id": "1", "title" : "full_process_title".localizeString(string: currentLanguage), "desc" : "full_process_desc".localizeString(string: currentLanguage), "image" : "full_process"]
        dictionaries.append(object1)

        let object2: [String: String] = ["id": "2", "title" : "bank_card_title".localizeString(string: currentLanguage), "desc" : "bank_card_desc".localizeString(string: currentLanguage), "image" : "bank_card"]
        dictionaries.append(object2)
        
        let object3: [String: String] = ["id": "3", "title" : "mrz_title".localizeString(string: currentLanguage), "desc" : "mrz_desc".localizeString(string: currentLanguage), "image" : "mrz"]
        dictionaries.append(object3)
        
        let object4: [String: String] = ["id": "4", "title" : "id_spoffing_title".localizeString(string: currentLanguage), "desc" : "id_spoffing_desc".localizeString(string: currentLanguage), "image" : "spoofing"]
        dictionaries.append(object4)
        
        
        let object5: [String: String] = ["id": "5", "title" : "passive_liveness_title".localizeString(string: currentLanguage), "desc" : "passive_liveness_desc".localizeString(string: currentLanguage), "image" : "passive"]
        dictionaries.append(object5)
        
        let object6: [String: String] = ["id": "6", "title" : "face_matching_title".localizeString(string: currentLanguage), "desc" : "face_matching_desc".localizeString(string: currentLanguage), "image" : "matching"]
        dictionaries.append(object6)
        
        
        return dictionaries
       
      
    }

   
 
    
    var token: String {
        get { return UserDefaults.standard.string(forKey: tokenKey) ?? "" }
       set { UserDefaults.standard.set(newValue, forKey: tokenKey) }
    }
    
   
    
}


