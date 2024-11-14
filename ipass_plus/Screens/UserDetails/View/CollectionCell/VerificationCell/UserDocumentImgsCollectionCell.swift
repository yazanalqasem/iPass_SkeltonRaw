//
//  UserDocumentImgsCollectionCell.swift
//  ipass_plus
//
//  Created by Mobile on 07/03/24.
//

import UIKit

class UserDocumentImgsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var documetImgCollectionVw: UICollectionView!
    
    var documentImgsArr = [UIImage(named: "img3"),UIImage(named: "img3"),UIImage(named: "img3"),UIImage(named: "img3"),UIImage(named: "img3")]

    override func awakeFromNib() {
        super.awakeFromNib()
        documetImgCollectionVw.delegate = self
        documetImgCollectionVw.dataSource = self
        
        let cardNib = UINib(nibName: "CardCollectionCell", bundle: nil)
        self.documetImgCollectionVw.register(cardNib, forCellWithReuseIdentifier: "CardCollectionCell")
    }

}
extension UserDocumentImgsCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documentImgsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
        cell.btnLeftScroll.isHidden = true
        cell.btnRightScroll.isHidden = true
        cell.lblseparator.isHidden = true
        cell.lblTotalPage.isHidden = true
        cell.lblCurrentPage.isHidden = true
        cell.imgCard.image = documentImgsArr[indexPath.row]
        return cell
    }

}

//    MARK: - UICollection VIew Delegate Flow Layouts

extension UserDocumentImgsCollectionCell: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let collectionwidth = collectionView.bounds.width
        let heights = collectionView.bounds.height
        return CGSize(width: collectionwidth / 1 - 10, height: heights / 1)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 10

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            return 0

    }

}
