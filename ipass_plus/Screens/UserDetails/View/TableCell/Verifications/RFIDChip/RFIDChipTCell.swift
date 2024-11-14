//
//  RFIDChipTCell.swift
//  ipass_plus
//
//  Created by Mobile on 24/02/24.
//

import UIKit

class RFIDChipTCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgStatus.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
