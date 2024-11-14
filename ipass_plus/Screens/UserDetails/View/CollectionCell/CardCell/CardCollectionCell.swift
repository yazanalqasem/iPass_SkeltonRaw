//
//  CardCollectionCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit

protocol CardCellScrollDelegate:AnyObject{
    func didTapLeftScroll(in cell: CardCollectionCell)
    func didTapRighScroll(in cell:CardCollectionCell)
}


class CardCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var btnLeftScroll: UIButton!
    @IBOutlet weak var btnRightScroll: UIButton!
    @IBOutlet weak var lblCurrentPage: UILabel!
    @IBOutlet weak var lblTotalPage: UILabel!
    
    @IBOutlet weak var lblseparator: UILabel!
    
    var delegate:CardCellScrollDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnRightScroll.layer.cornerRadius = 3
        btnLeftScroll.layer.cornerRadius = 3
        imgCard.layer.cornerRadius = 12
    }

    @IBAction func didLeftScroll(_ sender: Any) {
        delegate?.didTapLeftScroll(in: self)
    }
    
    
    @IBAction func didRightScroll(_ sender: Any) {
        delegate?.didTapRighScroll(in: self)
    }
    
    
    
    
}
