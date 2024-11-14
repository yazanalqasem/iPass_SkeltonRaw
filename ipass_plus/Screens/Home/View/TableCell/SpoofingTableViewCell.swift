//
//  SpoofingTableViewCell.swift
//  ipass_plus
//
//  Created by MOBILE on 27/09/24.
//

import UIKit

class SpoofingTableViewCell: UITableViewCell {

    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
