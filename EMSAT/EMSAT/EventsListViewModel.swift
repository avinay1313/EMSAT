//
//  EventsListViewModel.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

/// Protocols for communication between Model & ViewController
protocol EventsListViewModelDelegate {
    func reloadTable()
}

class EventsListViewModel: NSObject {
    
    let arrType = ["Electrician","Retailer","Nukked"]
    var intPage = 1
    var userData: UserData!
    var arrEventList = [EventList]()
    
    var delegate:EventsListViewModelDelegate!
    
    func callUserLoginAPI(){
        let loginParser = UserLoginAPIParser()
        let credentials = ["mobile":"8888888888","password":"123456","device_token":"12122112"]
        
        loginParser.callAPI(credentials) { (userLoginModel, status, message) in
            if status {
                if userLoginModel?.data != nil {
                    self.userData = (userLoginModel?.data)!
                    self.callEventListAPI(self.userData)
                }
            }
        }
    }
    
    func callEventListAPI(_ userData: UserData) {
        let eventListAPI = EventListAPIParser()
        let eventListParams = ["user_id":userData.user_id,"auth_token":userData.auth_token,"page":intPage,"limit":10,"events_type":"all","filter_event_id":"","from_date":"","to_date":"","location":"","filter_event_type": arrType] as [String : Any]
        
        eventListAPI.callAPI(eventListParams) { (eventListModel, status, message) in
            if status {
                if status {
                    if eventListModel?.data != nil {
                        if let eventList = eventListModel?.data.event_list {
                            for list in eventList {
                                self.arrEventList.append(list)
                            }
                            self.delegate.reloadTable()
                        }
                    }
                }
            }
        }
    }
    
    /// This method is used to populated content of cell
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - indexPath: indexPath
    func populate(cell:EventListCell,at indexPath:IndexPath){
        let eventList = arrEventList[indexPath.row]
        
        cell.lblTitle.text = eventList.title
        cell.lblLocation.text = eventList.location
        cell.lblDate.text = eventList.date
        cell.lblTime.text = "\(eventList.from_time) : \(eventList.to_time)"
        cell.lblType.text = eventList.type
        
        cell.viewType.layer.cornerRadius = 5.0
        cell.viewType.layer.borderWidth = 1.0
        cell.viewType.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewType.clipsToBounds = true
        
//        if indexPath.row == arrEventList.count - 1 {
//            self.intPage = self.intPage + 1
//            self.callEventListAPI(self.userData)
//        }
    }

}
