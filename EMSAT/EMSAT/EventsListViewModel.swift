//
//  EventsListViewModel.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class EventsListViewModel: NSObject {
    
    func callUserLoginAPI(){
        let loginParser = UserLoginAPIParser()
        let credentials = ["mobile":"8888888888","password":"123456","device_token":"12122112"]
        
        loginParser.callAPI(credentials) { (userLoginModel, status, message) in
            if status {
                if userLoginModel?.data != nil {
                    self.callEventListAPI((userLoginModel?.data)!)
                }
            }
        }
    }
    
    func callEventListAPI(_ userData: UserData) {
        let eventListAPI = EventListAPIParser()
        let eventListParams = ["user_id":userData.user_id,"auth_token":userData.auth_token,"page":1,"limit":10,"events_type":"all"] as [String : Any]
        
        eventListAPI.callAPI(credentials) { (eventListModel, status, message) in
            if status {
                
            }
        }
    }

}
