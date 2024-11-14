//
//  UserSubDetailTCell.swift
//  ipass_plus
//
//  Created by Mobile on 24/02/24.
//

import UIKit

class UserSubDetailTCell: UITableViewCell {
    
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
