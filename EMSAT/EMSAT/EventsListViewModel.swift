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
    func reloadTable(status:Bool)
    func openCustomPopup(sender: UIButton)
}

class EventsListViewModel: NSObject {
    
    let arrType = ["Electrician","Retailer","Nukked"]
    var intPage = 1
    var userData: UserData!
    var arrEventList = [EventList]()
    var strTypeValue = ""
    
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
                            self.delegate.reloadTable(status: true)
                        }else{
                            self.delegate.reloadTable(status: false)
                        }
                    }else{
                        self.delegate.reloadTable(status: false)
                    }
                }else{
                    self.delegate.reloadTable(status: false)
                }
            }else{
                self.delegate.reloadTable(status: false)
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
        
        cell.selectionStyle = .none
        cell.lblTitle.text = eventList.title
        cell.lblLocation.text = eventList.location
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy-mm-dd"
        
        if let date = dateFormate.date(from: eventList.date){
            dateFormate.dateFormat = "dd,MMM yyyy"
            let strDate = dateFormate.string(from: date)
            cell.lblDate.text = strDate
        }
        var strFromTime = ""
        var strToTime = ""
        dateFormate.dateFormat = "HH:mm"
        if let date = dateFormate.date(from: eventList.from_time){
            dateFormate.dateFormat = "hh:mm a"
            let strTime = dateFormate.string(from: date)
            strFromTime = strTime
        }
        dateFormate.dateFormat = "HH:mm"
        if let date = dateFormate.date(from: eventList.to_time){
            dateFormate.dateFormat = "hh:mm a"
            let strTime = dateFormate.string(from: date)
            strToTime = strTime
        }
        cell.lblTime.text = "\(strFromTime) : \(strToTime)"
        if strTypeValue.count == 0{
            cell.lblType.text = eventList.type
        }else{
            cell.lblType.text = strTypeValue
        }
        cell.viewType.layer.cornerRadius = 5.0
        cell.viewType.layer.borderWidth = 1.0
        cell.viewType.layer.borderColor = UIColor.darkGray.cgColor
        cell.viewType.clipsToBounds = true
        cell.btnAction.tag = indexPath.row
        cell.btnAction.addTarget(self, action: #selector(showList(sender:)), for: .touchUpInside)
    }
    func loadMore() {
        self.intPage = self.intPage + 1
        self.callEventListAPI(self.userData)
    }
    @objc func showList(sender:UIButton){
        print("Action Button")
        delegate.openCustomPopup(sender: sender)
    }
}
