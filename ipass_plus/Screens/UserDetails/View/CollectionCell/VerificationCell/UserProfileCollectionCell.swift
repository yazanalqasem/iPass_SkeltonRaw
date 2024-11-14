//
//  UserProfileCollectionCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit
import Alamofire

class UserProfileCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var topPortVsCameraLabel: UILabel!
    @IBOutlet weak var topComparisonLabel: UILabel!
    @IBOutlet weak var btnExpandCollapseImages: UIButton!
    @IBOutlet weak var comparisoncheckBtn: UIButton!
    @IBOutlet weak var cameraImgCheckBtn: UIButton!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideVwHyt: NSLayoutConstraint!
    @IBOutlet weak var documentImg: UIImageView!
    @IBOutlet weak var capturedImg: UIImageView!
    @IBOutlet weak var lblLiveness: UILabel!
    @IBOutlet weak var lblFaceMatching: UILabel!
    @IBOutlet weak var viewbarcodeImg: UIView!
    @IBOutlet weak var viewbarcodeDropdown: UIView!
    @IBOutlet weak var veiwhideshowliveness: UIView!
    @IBOutlet weak var viewlivenessScore: UIView!
    @IBOutlet weak var bardcodeImg: UIImageView!
    @IBOutlet weak var barcodeExpandCollapsebtn: UIButton!
    @IBOutlet weak var viewbarcodeHyt: NSLayoutConstraint!
    @IBOutlet weak var togglebutton: UIButton!
    @IBOutlet weak var nfcImg1: UIImageView!
    @IBOutlet weak var nfcImg2: UIImageView!
    @IBOutlet weak var lblNfcFaceMatchingScore: UILabel!
    @IBOutlet weak var nfcFaceMatchingScoreBtn: UIButton!
    @IBOutlet weak var nfcDetailVw: UIView!
    @IBOutlet weak var nfcDetailVwHyt: NSLayoutConstraint!
    @IBOutlet weak var nfcScoreVw: UIView!
    @IBOutlet weak var nfcScoreVwHyt: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        documentImg.layer.cornerRadius = 5
        capturedImg.layer.cornerRadius = 5
        bardcodeImg.layer.cornerRadius = 5
        viewbarcodeHyt.constant = 0
        togglebutton.isHidden = false
        viewbarcodeImg.isHidden = true
//        viewbarcodeDropdown.isHidden = true
        
        topComparisonLabel.text = "portrait_comparison".localizeString(string: HomeDataManager.shared.languageCodeString)
        topPortVsCameraLabel.text = "portrait_vs_camera".localizeString(string: HomeDataManager.shared.languageCodeString)
 
    }
    
    
    
    @IBAction func barcodeExpand(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            viewbarcodeImg.isHidden = false
            viewbarcodeHyt.constant = 300
            barcodeExpandCollapsebtn.setImage(UIImage(named: "right arrow"), for: .normal)

                  } else {
                      viewbarcodeImg.isHidden = true
                      viewbarcodeHyt.constant = 0
                      barcodeExpandCollapsebtn.setImage(UIImage(named: "dropdwn"), for: .normal)

                  }
              }
    
    
    
    @IBAction func barcodeToggleButton(_ sender: UIButton) {
        
//        let squareSize: CGFloat = 100
//                
//                // Define the x and y values for the position of the square
//                let xPosition: CGFloat = xValue
//                let yPosition: CGFloat = yValue  
//                
//                // Create the square box view
//                let squareView = UIView(frame: CGRect(x: xPosition, y: yPosition, width: squareSize, height: squareSize))
//                squareView.backgroundColor = .red // Set the background color to red for visibility
//                
//                // Add the square box view to the main view
//                self.bardcodeImg.addSubview(squareView)
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {

            sender.setImage(UIImage(named: "eye.slash"), for: .selected)
            sender.tintColor = UIColor.lightGray
        }else{
            sender.setImage(UIImage(named: "eye"), for: .normal)
        }
    
    }
    
    @IBAction func didDidExpandCollapse(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            hideView.isHidden = false
            hideVwHyt.constant = 200
            btnExpandCollapseImages.setImage(UIImage(named: "right arrow"), for: .normal)

                  } else {
                      hideView.isHidden = true
                      hideVwHyt.constant = 0
                      btnExpandCollapseImages.setImage(UIImage(named: "dropdwn"), for: .normal)

                  }
              }
        
}
