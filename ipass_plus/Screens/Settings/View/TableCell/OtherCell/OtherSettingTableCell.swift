//
//  OtherSettingTableCell.swift
//  ipass_plus
//
//  Created by Mobile on 02/02/24.
//

import UIKit

class OtherSettingTableCell: UITableViewCell {
    
    @IBOutlet weak var btnDropDownTop: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var lblTitleTop: NSLayoutConstraint!
    @IBOutlet weak var lblDisable: UILabel!
    @IBOutlet weak var btnRightdropdown: UIButton!
    @IBOutlet weak var lblLine: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
