//
//  EventListAPIParser.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class EventListAPIParser: NSObject {
    /// Completion Handler for passing result to back
    typealias APICompletionHandler = ((_ data:EventListModel?,_ success:Bool,_ message:String?)->())
    
    private var request:URLRequest!
    
    func callAPI(_ data: [String : Any]?, completion: @escaping APICompletionHandler) {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: data!, options: .prettyPrinted)
            
            let strURL = MyLibrary.shared.apiURL(for: .StoredGetEventListURL)
            
            request = URLRequest(url: URL(string:strURL)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = data
            request.timeoutInterval = 60
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (error == nil){
                    if let httpResponse = response as? HTTPURLResponse{
                        if httpResponse.statusCode == 200{
                            if(data != nil){
                                self.parseData(data: data!, completion: completion)
                            }else{
                                DispatchQueue.main.async {
                                    completion(nil,false,"Failed to get response")
                                }
                            }
                        }else{
                            DispatchQueue.main.async {
                                completion(nil,false,"Failed to get response")
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(nil,false,"Failed to get response")
                    }
                }
            }
            dataTask.resume()
            
        } catch {
            DispatchQueue.main.async {
                completion(nil,false,error.localizedDescription)
            }
        }
    }
    
    func parseData(data: Data, completion: @escaping APICompletionHandler) {
        let eventListModel : EventListModel?
        do {
            eventListModel = try JSONDecoder().decode(EventListModel.self, from: data)
            completion(eventListModel,true,"Parsed Sucessful")
        } catch  {
            completion(nil,false,"Failed to get response")
        }
    }

}
