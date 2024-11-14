//
//  PersonalDetailTCell.swift
//  ipass_plus
//
//  Created by MOBILE on 23/02/24.
//

import UIKit

class PersonalDetailTCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ImgWaring: UIImageView!
    @IBOutlet weak var lbluserDetail: UILabel!
    
    @IBOutlet weak var dataTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
