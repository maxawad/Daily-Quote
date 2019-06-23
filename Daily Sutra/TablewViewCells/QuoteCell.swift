//
//  QuoteCell.swift
//  Daily Quote
//
//  Created by Moustafa Awad on 6/17/19.
//  Copyright © 2019 Moustafa Awad. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {

    @IBOutlet weak var Quote: UILabel!
    @IBOutlet weak var Author: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
