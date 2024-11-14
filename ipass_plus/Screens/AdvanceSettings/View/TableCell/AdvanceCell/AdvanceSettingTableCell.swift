//
//  AdvanceSettingTableCell.swift
//  ipass_plus
//
//  Created by Mobile on 05/02/24.
//

import UIKit

class AdvanceSettingTableCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDisable: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var bottomline: UILabel!
    @IBOutlet weak var backgroundVw: UIView!
    @IBOutlet weak var hideVw: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundVw.layer.cornerRadius = 10
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    
    
    
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
