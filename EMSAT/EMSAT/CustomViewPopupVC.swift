//
//  CustomViewPopupVC.swift
//  EMSAT
//
//  Created by Avinay K on 21/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

protocol CustomViewPopupDelegate {
    func selectdType(strType:String!)
}
class CustomViewPopupVC: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var alertView: UIView!
    
    var arrType: [String]!
    
    var delegate:CustomViewPopupDelegate!
    
    @IBOutlet var tblType: UITableView!
    
    @IBOutlet weak var constraintYposAlertView: NSLayoutConstraint!
    private var tapGesture:UITapGestureRecognizer!
    
    
    var buttonHandler:((_ sender:UIButton)->())!
    
    // MARK: - UIViewController Methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 8.0
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 3, height: 3)
        alertView.layer.shadowOpacity = 0.2
        alertView.layer.shadowRadius = 4.0
        alertView.clipsToBounds = true
        
        self.tblType.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTapGesture()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFontAndText()
    }
    
    // MARK: - IBAction Methods -
    
    @IBAction func btnEditPressedFromCustomViewPopupVC(_ sender: Any) {
        buttonHandler(sender as! UIButton)
    }
    @IBAction func btnRelinkPressedFromCustomViewPopupVC(_ sender: Any) {
        buttonHandler(sender as! UIButton)
    }
    
    @IBAction func btnDeletePressedFromCustomViewPopupVC(_ sender: Any) {
        buttonHandler(sender as! UIButton)
    }
    
    //MARK: - Private Methods -
    
    /// This method used to add custom alert view into window
    ///
    /// - Parameter type: AlertType
    func presentCustomAlert(with frame:CGRect){
        self.view.frame = UIScreen.main.bounds
        var rootVC:UIViewController!
        if let vc = AppDelegate.shared.window?.rootViewController , vc is UINavigationController{
            rootVC = (vc as! UINavigationController).viewControllers.last!
        }else{
            rootVC = AppDelegate.shared.window!.rootViewController!
        }
        
        self.constraintYposAlertView.constant = frame.origin.y
        self.tblType.reloadData()
        rootVC.addChild(self)
        rootVC.view.addSubview((self.view)!)
        self.didMove(toParent: rootVC)
    }
    
    /// This method is used to add tapgesture on backgroundview
    private func addTapGesture(){
        if tapGesture != nil{
            viewContainer.removeGestureRecognizer(tapGesture)
            tapGesture = nil
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        self.viewContainer.isUserInteractionEnabled = true
        self.viewContainer.addGestureRecognizer(tapGesture)
    }
    
    /// This method used to set color and font
    private func setFontAndText(){
    }
    
    /// This method used to handle tap gesture
    ///
    /// - Parameter gesture: gesture
    @objc func handleTap(gesture:UITapGestureRecognizer){
        self.view.removeFromSuperview()
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: tblType))!{
            return false
        }
        return true
    }
}
extension CustomViewPopupVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrType[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.removeFromSuperview()
        delegate.selectdType(strType: arrType[indexPath.row])
    }
    
    
}
