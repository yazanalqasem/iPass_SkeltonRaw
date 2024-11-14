//
//  UserCardCollectionCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit
import Alamofire



class UserCardCollectionCell: UICollectionViewCell,CardCellScrollDelegate{
  
    func didTapLeftScroll(in cell: CardCollectionCell) {
       
        self.cardCollectionVw.isScrollEnabled = true
        if let indexPath = cardCollectionVw.indexPathsForVisibleItems.first {
                let currentIndex = max(0, indexPath.item)
                let newIndex = max(0, currentIndex - 1)
                let newIndexPath = IndexPath(item: newIndex, section: 0)
                cardCollectionVw.scrollToItem(at: newIndexPath, at: .left, animated: true)

            }
    }
    
    func didTapRighScroll(in cell: CardCollectionCell) {
        self.cardCollectionVw.isScrollEnabled = true
        if let indexPath = cardCollectionVw.indexPathsForVisibleItems.first {
               let currentIndex = max(0, indexPath.item)
               let newIndex = min(cardCollectionVw.numberOfItems(inSection: 0) - 1, currentIndex + 1)
               let newIndexPath = IndexPath(item: newIndex, section: 0)
               cardCollectionVw.scrollToItem(at: newIndexPath, at: .right, animated: true)

           }
    }
    
    
    @IBOutlet weak var cardCollectionVw: UICollectionView!
    @IBOutlet weak var lblcardType: UILabel!
    @IBOutlet weak var UserDetailTableVw: UITableView!
    
    var dataArray = [NSDictionary]()
    var cardImg:[UIImage] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
     
        
    
        // Initialization code
        cardCollectionVw.dataSource = self
        cardCollectionVw.delegate = self
        
        UserDetailTableVw.dataSource = self
        UserDetailTableVw.delegate = self
       
        let cardNib = UINib(nibName: "CardCollectionCell", bundle: nil)
        self.cardCollectionVw.register(cardNib, forCellWithReuseIdentifier: "CardCollectionCell")
        
        let userDetail = UINib(nibName: "PersonalDetailTCell", bundle: nil)
        self.UserDetailTableVw.register(userDetail, forCellReuseIdentifier: "PersonalDetailTCell")
        
       
    }

}

extension UserCardCollectionCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailTCell", for: indexPath) as! PersonalDetailTCell
        
        var dd = NSMutableDictionary()
        dd = dataArray[indexPath.row] as! NSMutableDictionary
        let dateIssue = dd["Date of issue"] as? String
        let dateExpiry = dd["Date of expiry"] as? String
        
        cell.lblTitle.text = dd.allKeys[0] as? String
        cell.ImgWaring.isHidden = true

        cell.lbluserDetail.textColor = UIColor.black
       
        cell.lblTitle.textColor = UIColor.black
        cell.dataTextView.textColor = UIColor.black
        
        
        
        if(UserLocalStore.shared.clickedIndex == 3) {
            cell.lbluserDetail.isHidden = true
            cell.dataTextView.isHidden = false
        }
        else {
            cell.lbluserDetail.isHidden = false
            cell.dataTextView.isHidden = true
        }
        cell.lbluserDetail.text = dd[dd.allKeys[0] as? String as Any] as? String
        cell.dataTextView.text = dd[dd.allKeys[0] as? String as Any] as? String

        
        if let dateIssueString = dateIssue {
//            cell.lbluserDetail.textColor = UIColor.red
//            cell.lblTitle.textColor = UIColor.red
        } else if let dateExpiryString = dateExpiry {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            if let expiryDate = dateFormatter.date(from: dateExpiryString) {
                let now = Date()
                DispatchQueue.main.async { 
                    if expiryDate < now {
                        // Expired
                        cell.lbluserDetail.textColor = UIColor.red
                        cell.lblTitle.textColor = UIColor.red
                        cell.ImgWaring.isHidden = false
                    } else {
                        // Not expired
                        cell.lbluserDetail.textColor = UIColor.black
                        cell.lblTitle.textColor = UIColor.black
                        cell.ImgWaring.isHidden = true
                    }
                }
            }
        }
        
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalDetailTCell", for: indexPath) as! PersonalDetailTCell
//        
////        var fullName: String = dataArray[indexPath.row] as! String
////        let fullNameArr = fullName.components(separatedBy: "++++")
//        
//        var dd = NSMutableDictionary()
//        dd = dataArray[indexPath.row] as! NSMutableDictionary
//        
//        cell.lblTitle.text = dd.allKeys[0] as? String
//        cell.lbluserDetail.text = dd[dd.allKeys[0] as? String as Any] as? String
//        cell.ImgWaring.isHidden = true
//        
//        print(dd.allKeys[0]as? String)
//        
//        if(dd.allKeys[0] as? String == "Date of expiry") {
//            let date = dd["Date of expiry"] as? String
//            if let expiryDateString = date {
//                       let dateFormatter = DateFormatter()
//                       dateFormatter.dateFormat = "yyyy/MM/dd" // Ensure this matches your date format
//                       if let expiryDate = dateFormatter.date(from: expiryDateString) {
//                           let now = Date()
//                           DispatchQueue.main.async { // Ensure UI updates are on the main thread
//                               if expiryDate < now {
//                                   // Expired
//                                   cell.lbluserDetail.textColor = UIColor.red
//                                   cell.lblTitle.textColor = UIColor.red
//                               } else {
//                                   // Not expired
//                                   cell.lbluserDetail.textColor = UIColor.black
//                                   cell.lblTitle.textColor = UIColor.black
//                               }
//                           }
//                       }
//                   }
//        }
//       
//     
//        
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserLocalStore.shared.clickedIndex == 3 {
            return 180
        }else if UserLocalStore.shared.clickedIndex == 1{
            return UITableView.automaticDimension
        }else{
            return 25
        }
        
    }
}


extension UserCardCollectionCell: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as! CardCollectionCell
         cell.delegate = self
         if cardImg.count <= 1 {
             cell.btnLeftScroll.isHidden = true
             cell.btnRightScroll.isHidden = true
             cell.lblTotalPage.isHidden = true
             cell.lblCurrentPage.isHidden = true
             cell.lblseparator.isHidden = true
         }else{
             cell.lblseparator.isHidden = false
             cell.lblCurrentPage.isHidden = false
             cell.lblTotalPage.isHidden = false
             cell.lblTotalPage.text = "\(cardImg.count)"
         }
        
         cell.imgCard.image = cardImg[indexPath.row]

         return cell
     }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cardCell = cell as? CardCollectionCell {
              cardCell.lblCurrentPage.text = "\(indexPath.item + 1)"
          }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            self.cardCollectionVw.isScrollEnabled = false
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if let collectionView = scrollView as? UICollectionView {
//            let visibleIndexPaths = collectionView.indexPathsForVisibleItems
//            for indexPath in visibleIndexPaths {
//                if let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionCell {
//                    let width = scrollView.frame.width - (scrollView.contentInset.left * 2)
//                    let index = scrollView.contentOffset.x / width
//                    let roundedIndex = Int(round(index))
//                    print("roundedIndex", roundedIndex)
//                    cell.lblCurrentPage.text = "\(roundedIndex + 1)"
//                }
//            }
//        }
    }
    
}

//    MARK: - UICollection VIew Delegate Flow Layouts

extension UserCardCollectionCell: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//            let collectionwidth = collectionView.bounds.width
//        let heights = collectionView.bounds.height
//        return CGSize(width: collectionwidth / 1, height: heights / 1)
        return CGSize (width: collectionView.frame.width, height: collectionView.frame.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 0

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            return 0

    }

}
