//
//  TesteRFIDTableViewCell.swift
//  ipass_plus
//
//  Created by MOBILE on 26/03/24.
//

import UIKit

class TesteRFIDTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img: UIImageView!
   
    
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
