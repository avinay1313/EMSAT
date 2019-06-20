//
//  UserLoginModel.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import Foundation

struct UserLoginModel: Codable {
    
    let code: Int
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let user_id: String
    let auth_token: String
}
