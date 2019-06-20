//
//  EventsListVC.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class EventsListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnClick(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
