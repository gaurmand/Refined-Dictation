//
//  HistoryTableViewCell.swift
//  Refined Dictation
//
//  Created by Serran N on 11/27/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    //Properties
    @IBOutlet weak var TextLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var FavouriteImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
