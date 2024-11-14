//
//  UserDetailTableCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit


//protocol UserDetailCellDelegate:AnyObject{
//    func DidTapExpandCell(cell:UserDetailTableCell)
//}

class UserDetailTableCell: UITableViewCell {

    
//    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var btnExpandCell: UIButton!
    @IBOutlet weak var lblTitile1: UILabel!
    @IBOutlet weak var lblDetail1: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
//    @IBOutlet weak var lblVisualZone: UILabel!
    
//    var delegate:UserDetailCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func actionExpandCell(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        btnExpandCell.backgroundColor = UIColor.white
//        if sender.isSelected{
//            btnExpandCell.setImage(UIImage(named: "dropdwn"), for: .selected)
//        }else{
//            btnExpandCell.setImage(UIImage(named: "right arrow"), for: .selected)
//        }
//        
    }
    
    
    
}
