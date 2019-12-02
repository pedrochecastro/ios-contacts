//
//  CustomCell.swift
//  Contacts
//
//  Created by Pedro Sánchez Castro on 07/10/2019.
//  Copyright © 2019 checastro.com. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    

}
