//
//  EventListModel.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import Foundation

struct EventListModel: Codable {
    
    let code: Int
    let message: String
    let data: EventsData
}

struct EventsData: Codable {
    let user_id: String
    let from_date: String
    let to_date: String
    let event_list: [EventList]
}

struct EventList: Codable {
    let event_id: String
    let title: String
    let type: String
    let date: String
    let from_time: String
    let to_time: String
    let location: String
    let event_status: String
    let filter_event_id: String
    let is_cancel: String
}
