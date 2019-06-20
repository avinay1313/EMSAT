//
//  MyLibrary.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class MyLibrary: NSObject {
    
    static let shared = MyLibrary()//singleton object
    
    let prefs = UserDefaults.standard
    
    /// enum for holding keys for URLS in preferences
    enum URLPreferences:String {
        case StoredUserLoginURL = "StoredUserLoginURL"
        case StoredGetEventListURL = "StoredGetEventListURL"
    }
    
    //Enum for specify application url
    enum ApplicationURLType{
        case LOCAL
        case TEST
        case LIVE
    }
    
    /// Set API Urls as per App URL Type
    ///
    /// - Parameter urlType: This could be from ApplicationURLTYpe
    func setApplicationURL(_ urlType: ApplicationURLType) {
        let prefs = UserDefaults.standard
        
        var strBaseUrl = ""
        
        switch urlType {
        case .LIVE:
            strBaseUrl = "https://staging.boardingpass.bandhanstar.com/api/web/v1/users/"
            break
        case .TEST:
            strBaseUrl = ""
            break
        default:
            strBaseUrl = ""
        }
        
        
        setURL(url: strBaseUrl + "login", key: .StoredUserLoginURL)
        setURL(url: strBaseUrl + "geteventlist", key: .StoredGetEventListURL)
        
        prefs.synchronize()
    }
    
    fileprivate func setURL(url:String,key:URLPreferences){
        UserDefaults.standard.set(url, forKey: key.rawValue)
    }
    
    /// This method is used to get URL for given url Preference
    func apiURL(for url:URLPreferences) -> String {
        let prefs = UserDefaults.standard
        return prefs.object(forKey: url.rawValue) as! String
    }

}
