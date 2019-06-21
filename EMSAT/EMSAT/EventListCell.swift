//
//  EventListCell.swift
//  EMSAT
//
//  Created by Avinay K on 21/06/19.
//  Copyright © 2019 avinay. All rights reserved.
//

import UIKit

class EventListCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var viewType: UIView!
    @IBOutlet var lblType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
