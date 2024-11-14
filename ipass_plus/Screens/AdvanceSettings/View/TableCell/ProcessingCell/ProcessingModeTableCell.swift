//
//  ProcessingModeTableCell.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class ProcessingModeTableCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var bottomLine: UILabel!
    
    var isCheckMark:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
