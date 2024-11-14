//
//  UserDetailCollectionCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit
import DocumentReader

class UserDetailCollectionCell: UICollectionViewCell {

    
    @IBOutlet weak var userInfoTableVw: UITableView!

    var sections = [Section]()
    var newsections = [NewSection]()
    

    
    var resultsDataValues: DocumentReaderResults!
    
    var isMrz = false
    
    var selecedIndex = -1
    var isExpandCell = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        userInfoTableVw.delegate = self
        userInfoTableVw.dataSource = self
       
        let userInfoNib = UINib(nibName: "UserDetailTableCell", bundle: nil)
        self.userInfoTableVw.register(userInfoNib, forCellReuseIdentifier: "UserDetailTableCell")
        
        let subDetail = UINib(nibName: "UserSubDetailTCell", bundle: nil)
        self.userInfoTableVw.register(subDetail, forCellReuseIdentifier: "UserSubDetailTCell")
        
//        gettingData()

    }
    


}
extension UserDetailCollectionCell: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      var count = newsections.count
       
       for section in newsections {
           count += section.subtitle.count
       }
       
       return count
   }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       let section = getSectionIndex(indexPath.row)
       let row = getRowIndex(indexPath.row)

       if row ==  0 {
           return UITableView.automaticDimension
       }

       return newsections[section].isExpandCell ?  0 : UITableView.automaticDimension
   }
   

   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let section = getSectionIndex(indexPath.row)
       let row = getRowIndex(indexPath.row)
       
       if row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "UserDetailTableCell") as! UserDetailTableCell
           cell.lblDetail1.text = newsections[section].detail as? String
           cell.lblTitile1.text = newsections[section].title
           cell.btnExpandCell.tag = section
           cell.btnExpandCell.setImage(newsections[section].isExpandCell ? UIImage(named: "right arrow") : UIImage(named: "dropdwn"), for: UIControl.State())
           cell.btnExpandCell.addTarget(self, action: #selector(UserDetailCollectionCell.toggleCollapse), for: .touchUpInside)
           
           
//           let arr = newsections[section].subDetail
//           let allItemsEqual = arr.allSatisfy { $0 == arr.first }
//           
//           
//           if(allItemsEqual == true) {
//               cell.imgCheck.image = UIImage(named: "imgCheck")
//               cell.lblDetail1.textColor = .black
//               cell.lblTitile1.textColor = .black
//           }
//           else {
//               cell.imgCheck.image = UIImage(named: "imgCross")
//               cell.lblDetail1.textColor = .red
//               cell.lblTitile1.textColor = .red
//           }
           
           
           if(newsections[section].topStatus == 0)  {
               cell.imgCheck.image = UIImage(named: "imgCross")
                cell.lblDetail1.textColor = .red
               cell.lblTitile1.textColor = .gray
           }
          else if(newsections[section].topStatus == 1)  {
              cell.imgCheck.image = UIImage(named: "imgCheck")
               cell.lblDetail1.textColor = UIColor(named: "greenClr")
              cell.lblTitile1.textColor = .gray
           }
           if(newsections[section].topStatus == 2)  {
               cell.imgCheck.image = UIImage(named: "minus")
                cell.lblDetail1.textColor = .black
               cell.lblTitile1.textColor = .gray
           }
           
           
           
           return cell
       } else {
           let cell = tableView.dequeueReusableCell(withIdentifier: "UserSubDetailTCell", for: indexPath) as! UserSubDetailTCell
           if(newsections[section].subtitle[row - 1].lowercased().contains("mrz")) {
               cell.lblTitle.text = "MRZ"
           }
           else if(newsections[section].subtitle[row - 1].lowercased().contains("visual")) {
               cell.lblTitle.text = "Visual Zone"
           }
           else if(newsections[section].subtitle[row - 1].lowercased().contains("rfid")) {
               cell.lblTitle.text = "NFC"
           }
           else if(newsections[section].subtitle[row - 1].lowercased().contains("bar")) {
               cell.lblTitle.text = "Bar Code"
           }
           else {
               cell.lblTitle.text = newsections[section].subtitle[row - 1]
           }

           
//           let arr = newsections[section].subDetail
//           let allItemsEqual = arr.allSatisfy { $0 == arr.first }
//           
//           
//           if(allItemsEqual == true) {
//               cell.imgStatus.image = UIImage(named: "imgCheck")
//               cell.lblTitle.textColor = .black
//               cell.lblValue.textColor = .black
//           }
//           else {
//              
//               cell.imgStatus.image = UIImage(named: "imgCross")
//               cell.lblTitle.textColor = .red
//               cell.lblValue.textColor = .red
//           }
           
           if(newsections[section].internalStatus == 0)  {
               cell.imgStatus.image = UIImage(named: "imgCross")
                    cell.lblTitle.textColor = .gray
                cell.lblValue.textColor = .red
           }
          else if(newsections[section].internalStatus == 1)  {
               cell.imgStatus.image = UIImage(named: "imgCheck")
                    cell.lblTitle.textColor = .gray
                cell.lblValue.textColor = UIColor(named: "greenClr")
           }
           if(newsections[section].internalStatus == 2)  {
               cell.imgStatus.image = UIImage(named: "minus")
                    cell.lblTitle.textColor = .gray
                cell.lblValue.textColor = .black
           }
           
           
           
          // cell.lblTitle.text = newsections[section].subtitle[row - 1]
           cell.lblValue.text = newsections[section].subDetail[row - 1]
           return cell
       }
   }
    
     func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    //
    // MARK: - Event Handlers
    //
    @objc func toggleCollapse(_ sender: UIButton) {
         let section = sender.tag
         let collapsed = newsections[section].isExpandCell
         
         // Toggle collapse
         newsections[section].isExpandCell = !collapsed
         
         // Update button image based on collapse state
         if collapsed {
             sender.setImage(UIImage(named: "dropdwn"), for: .normal)
         } else {
             sender.setImage(UIImage(named: "right arrow"), for: .normal)
         }
         
         let indices = getHeaderIndices()
         
         let start = indices[section]
         let end = start + newsections[section].subtitle.count
         
         userInfoTableVw.beginUpdates()
         for i in start ..< end + 1 {
             userInfoTableVw.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
         }
         userInfoTableVw.endUpdates()
     }
    
    //
    // MARK: - Helper Functions
    //
    func getSectionIndex(_ row: NSInteger) -> Int {
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                return i
            }
        }
        
        return -1
    }
    
    func getRowIndex(_ row: NSInteger) -> Int {
        var index = row
        let indices = getHeaderIndices()
        
        for i in 0..<indices.count {
            if i == indices.count - 1 || row < indices[i + 1] {
                index -= indices[i]
                break
            }
        }
        
        return index
    }
    
    func getHeaderIndices() -> [Int] {
        var index = 0
        var indices: [Int] = []
        
        for section in newsections {
            indices.append(index)
            index += section.subtitle .count + 1
        }
        
        return indices
    }

}


struct Section {
    var title1: String!
    var detail1: [String]!
    var collapsed: Bool!
    
    init(title1: String, detail1: [String], collapsed: Bool = true) {
        self.title1 = title1
        self.detail1 = detail1
        self.collapsed = collapsed
    }
}

struct NewSection{
    var title:String
    var detail:Any
    var subtitle:[String]
    var subDetail:[String]
    var isExpandCell:Bool
    var topStatus : Int
    var internalStatus : Int
    
    init(title: String, detail: Any, subtitle: [String], subDetail: [String], isExpandCell: Bool = true,
         topStatus: Int, internalStatus: Int) {
        self.title = title
        self.detail = detail
        self.subtitle = subtitle
        self.subDetail = subDetail
        self.isExpandCell = isExpandCell
        self.topStatus = topStatus
        self.internalStatus = internalStatus
    }
}
