//
//  SettingCell.swift
//  ipass_plus
//
//  Created by MOBILE on 31/01/24.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImg: UIImageView!
    @IBOutlet weak var bottomLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
