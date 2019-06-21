//
//  EventsListVC.swift
//  EMSAT
//
//  Created by Avinay K on 20/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class EventsListVC: UIViewController {
    
    @IBOutlet weak var tblEventList: UITableView!
    
    let model = EventsListViewModel()
    
    var customViewPopupVC:CustomViewPopupVC?
    var indexPath:IndexPath?
    var activityIndicator = UIActivityIndicatorView()

    // MARK: - UIViewController Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event List"
        model.delegate = self
        startBarButtonIndicator()
        model.callUserLoginAPI()
        self.tblEventList.tableFooterView = UIView()
    }
    
    //MARK: - Private Methods -
    func startBarButtonIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.style = .gray
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        activityIndicator.startAnimating()
    }
    
    func stopBarButtonIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}

extension EventsListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrEventList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell") as! EventListCell
        model.populate(cell: cell, at: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MapVC")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension EventsListVC: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset <= 5.0) {
            startBarButtonIndicator()
            model.loadMore()
        }
    }
}

extension EventsListVC: EventsListViewModelDelegate {
    func reloadTable(status: Bool) {
        stopBarButtonIndicator()
        if status{
            DispatchQueue.main.async {
                self.tblEventList.reloadData()
            }
        }
    }
    
    func openCustomPopup(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        self.indexPath = indexPath
        let cell = self.tblEventList.cellForRow(at: indexPath) as! EventListCell
        var frame = cell.frame
        let offset = self.tblEventList.contentOffset
        
        if let lastCell = self.tblEventList.visibleCells.last as? EventListCell {
            if lastCell == cell{
                print("Last visible cell")
            }
        }
        
        var upperSpace:CGFloat = 0.0
        
        if UIApplication.shared.statusBarFrame.height >= CGFloat(44) {
            //upperSpace = upperSpace + 10
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let topPadding = window?.safeAreaInsets.top
                let bottomPadding = window?.safeAreaInsets.bottom
                
                if let top = topPadding, let bottom = bottomPadding{
                    upperSpace = top + bottom + upperSpace + 10
                }else{
                    upperSpace = 78 + upperSpace + 10
                }
            }
        }else{
            upperSpace = 64 + upperSpace //UIApplication.shared.statusBarFrame.height
        }
        
        var totalHeight = 0.0
        var halfHeightOfCell  = 0.0
        var totalHeightYpos = 0.0
        
        totalHeight = Double(cell.frame.origin.y + cell.frame.size.height)
        halfHeightOfCell = Double(cell.frame.size.height)/2
        
        totalHeight = totalHeight - Double(offset.y)
        
        totalHeightYpos = totalHeight
        
        totalHeight  = totalHeight + 182
        
        let hieghtTableView = Double(self.tblEventList.frame.size.height)
        
        if hieghtTableView > totalHeight{
            totalHeight = totalHeight - halfHeightOfCell
            totalHeightYpos =  totalHeightYpos - halfHeightOfCell
            totalHeightYpos = totalHeightYpos + Double(upperSpace)
            totalHeightYpos = totalHeightYpos - 10
            frame.origin.y = CGFloat(totalHeightYpos)
        }else{
            totalHeightYpos =  totalHeightYpos - 182
            totalHeightYpos =  totalHeightYpos - halfHeightOfCell
            totalHeightYpos = totalHeightYpos + Double(upperSpace)
            totalHeightYpos = totalHeightYpos - 10
            frame.origin.y = CGFloat(totalHeightYpos)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        customViewPopupVC = storyboard.instantiateViewController(withIdentifier: "CustomViewPopupVC") as? CustomViewPopupVC
        customViewPopupVC?.delegate = self
        customViewPopupVC?.view.frame = UIScreen.main.bounds
        customViewPopupVC?.arrType = model.arrType
        customViewPopupVC?.presentCustomAlert(with: frame)
    }
}

extension EventsListVC:CustomViewPopupDelegate{
    func selectdType(strType: String!) {
        if let indexPath = self.indexPath{
            model.strTypeValue = strType
            self.tblEventList.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
