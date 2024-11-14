//
//  DocVerificationTCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit


protocol MYTableCellDelegate:AnyObject{
    func didtapCellExpand(cell:DocVerificationTCell)
}

class DocVerificationTCell: UITableViewCell {
    
    @IBOutlet weak var resolutionHeading: UILabel!
    @IBOutlet weak var angleHeading: UILabel!
    @IBOutlet weak var boundHeading: UILabel!
    @IBOutlet weak var potraitHeading: UILabel!
    @IBOutlet weak var glareHeading: UILabel!
    @IBOutlet weak var focusHeading: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblMetadata: UILabel!
    @IBOutlet weak var btnExPandCell: UIButton!
    @IBOutlet weak var imgFocus: UIImageView!
    @IBOutlet weak var imgGlare: UIImageView!
    @IBOutlet weak var imgPotrait: UIImageView!
    @IBOutlet weak var imgBounds: UIImageView!
    @IBOutlet weak var imgPerspectiveAngle: UIImageView!
    @IBOutlet weak var imgFrame: UIImageView!
    
    var delegate:MYTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnExPandCell.isSelected = false
        btnExPandCell.setImage(UIImage(named: "right arrow"), for: .normal)
        focusHeading.text = "focus".localizeString(string: HomeDataManager.shared.languageCodeString)
        glareHeading.text = "glares".localizeString(string: HomeDataManager.shared.languageCodeString)
        potraitHeading.text = "potrait".localizeString(string: HomeDataManager.shared.languageCodeString)
        boundHeading.text = "bounds".localizeString(string: HomeDataManager.shared.languageCodeString)
        angleHeading.text = "angle".localizeString(string: HomeDataManager.shared.languageCodeString)
        resolutionHeading.text = "resolution".localizeString(string: HomeDataManager.shared.languageCodeString)
    }
    
    
    
    @IBAction func actionDidTap(_ sender: UIButton) {

        delegate?.didtapCellExpand(cell: self)
    }
    
}

    
    


