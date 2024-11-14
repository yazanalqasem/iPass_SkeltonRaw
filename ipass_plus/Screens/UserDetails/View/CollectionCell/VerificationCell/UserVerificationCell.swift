//
//  UserVerificationCell.swift
//  ipass_plus
//
//  Created by Mobile on 01/02/24.
//

import UIKit
import DocumentReader

class UserVerificationCell: UICollectionViewCell,MYTableCellDelegate {
    func didtapCellExpand(cell: DocVerificationTCell) {
        guard let indexPath = self.documentTableVw.indexPath(for: cell) else {
            return
        }
        print("ROWS",indexPath.row, indexPath.section)
        cell.btnExPandCell.tag = indexPath.row
        documentTableVw.deselectRow(at: indexPath, animated: true)

        if selectedIndex == indexPath.row {
            isExpandCell = !isExpandCell
        } else {
            isExpandCell = true
        }

        selectedIndex = indexPath.row
        documentTableVw.reloadRows(at: [indexPath], with: .automatic)
        if UserLocalStore.shared.clickedIndex == 0 {
            
            if UserLocalStore.shared.RFIDChipProcessing == false {
                if isExpandCell {
                    scrollVwHyt.constant = 920
                    cell.btnExPandCell.setImage(UIImage(named:"right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 670
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
            }else{
                if isExpandCell {
                    scrollVwHyt.constant = 1300
                    cell.btnExPandCell.setImage(UIImage(named: "right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 1050
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
            }
            
        }else if UserLocalStore.shared.clickedIndex == 1 {
            
            if isExpandCell {
                scrollVwHyt.constant = 720
            } else {
                scrollVwHyt.constant = 470
            }
      
        }else if UserLocalStore.shared.clickedIndex == 2 {
            if UserLocalStore.shared.RFIDChipProcessing == false{
                if isExpandCell {
                    scrollVwHyt.constant = 470
                    cell.btnExPandCell.setImage(UIImage(named:"right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 470
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
                
            }else{
                if isExpandCell {
                    scrollVwHyt.constant = 850
                    cell.btnExPandCell.setImage(UIImage(named:"right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 850
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
            }
            
            
          
      
        }else if UserLocalStore.shared.clickedIndex == 3 {
            if isExpandCell {
                scrollVwHyt.constant = 470
            } else {
                scrollVwHyt.constant = 470
            }
      
        } else {
            
            if UserLocalStore.shared.RFIDChipProcessing == false{
                if isExpandCell {
                    scrollVwHyt.constant = 720
                    cell.btnExPandCell.setImage(UIImage(named:"right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 470
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
            }else{
                if isExpandCell {
                    scrollVwHyt.constant = 1100
                    cell.btnExPandCell.setImage(UIImage(named:"right arrow"), for: .normal)
                } else {
                    scrollVwHyt.constant = 850
                    cell.btnExPandCell.setImage(UIImage(named: "dropdwn"), for: .normal)
                }
            }
            
           
        }
}

    @IBOutlet weak var biometricTableVw: UITableView!
    @IBOutlet weak var documentTableVw: UITableView!
    @IBOutlet weak var rfidTableVw: UITableView!
    @IBOutlet weak var metadataTableView: UITableView!
    @IBOutlet weak var scrollVwHyt: NSLayoutConstraint!
    @IBOutlet weak var rfidTHyt: NSLayoutConstraint!
    @IBOutlet weak var metadataTHyt: NSLayoutConstraint!
    
    var biometricData = ["face_matching".localizeString(string: HomeDataManager.shared.languageCodeString),"liveness_check".localizeString(string: HomeDataManager.shared.languageCodeString)]
    var documentdata = ["optical".localizeString(string: HomeDataManager.shared.languageCodeString),
                        "document_type".localizeString(string: HomeDataManager.shared.languageCodeString),
                        "text_fields".localizeString(string: HomeDataManager.shared.languageCodeString),
                        "image_quality".localizeString(string: HomeDataManager.shared.languageCodeString),
                        "authenticity".localizeString(string: HomeDataManager.shared.languageCodeString)]
    
    var rFIDdata:[String] = ["bac".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "pace".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "ca".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "ta".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "aa".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "pa".localizeString(string: HomeDataManager.shared.languageCodeString),]
    
    var metaData = ["optical_processing".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "rfid_chip_processing".localizeString(string: HomeDataManager.shared.languageCodeString),]
    
    
    var metaDataValues = [String]()
    var rfidValues = [String]()
    var rfidProcessedOrNot = "2"
    var selectedIndex = -1
    var isExpandCell = false
    
    var faceMatching = ""
    var faceLiveness = ""
    var resultsDataValues: DocumentReaderResults!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        biometricTableVw.delegate = self
        biometricTableVw.dataSource = self
        
        documentTableVw.delegate = self
        documentTableVw.dataSource = self

        rfidTableVw.delegate = self
        rfidTableVw.dataSource = self
        
        metadataTableView.delegate = self
        metadataTableView.dataSource = self
        
        
        let bioNib = UINib(nibName: "DocVerificationTCell", bundle: nil)
        self.biometricTableVw.register(bioNib, forCellReuseIdentifier: "DocVerificationTCell")

        let docNib = UINib(nibName: "DocVerificationTCell", bundle: nil)
        self.documentTableVw.register(docNib, forCellReuseIdentifier: "DocVerificationTCell")
        
        let rifNib = UINib(nibName: "DocVerificationTCell", bundle: nil)
        self.rfidTableVw.register(rifNib, forCellReuseIdentifier: "DocVerificationTCell")
        
        let metaNib = UINib(nibName: "DocVerificationTCell", bundle: nil)
        self.metadataTableView.register(metaNib, forCellReuseIdentifier: "DocVerificationTCell")
        
        documentTableVw.estimatedRowHeight = 330
        documentTableVw.rowHeight = UITableView.automaticDimension
        
       

   
            if UserLocalStore.shared.clickedIndex == 0 {
                if UserLocalStore.shared.RFIDChipProcessing == false{
                    rfidTHyt.constant = 0
                    scrollVwHyt.constant = 670
                }else{
                    scrollVwHyt.constant = 1050
                }
                
            }else if UserLocalStore.shared.clickedIndex == 1 {
                scrollVwHyt.constant = 470
                rfidTHyt.constant = 0
                metadataTHyt.constant = 0
            }else if UserLocalStore.shared.clickedIndex == 2 {
                if UserLocalStore.shared.RFIDChipProcessing == false{
                    rfidTHyt.constant = 0
                    scrollVwHyt.constant = 470
                    metadataTHyt.constant = 0
                }else{
                    scrollVwHyt.constant = 850
                    metadataTHyt.constant = 0
                }

            }else if UserLocalStore.shared.clickedIndex == 3 {
                scrollVwHyt.constant = 470
                rfidTHyt.constant = 0
                metadataTHyt.constant = 0
            }else {
                if UserLocalStore.shared.RFIDChipProcessing == false{
                    rfidTHyt.constant = 0
                    metadataTHyt.constant = 0
                    scrollVwHyt.constant = 470
                }else{
                    metadataTHyt.constant = 0
                    scrollVwHyt.constant = 850
                }
                

            }
        
    }

}

extension UserVerificationCell: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserLocalStore.shared.clickedIndex == 0 {
            if tableView == biometricTableVw {
                return biometricData.count
            } else if tableView == documentTableVw {
                return documentdata.count
            } else if tableView == rfidTableVw {
               
                return rFIDdata.count
            }else {
                return metaData.count
            }
        }
        
        else if UserLocalStore.shared.clickedIndex == 1 {
            if tableView == biometricTableVw {
                return biometricData.count
            } else {
                return documentdata.count
            }
            
        }else if UserLocalStore.shared.clickedIndex == 2{
            if tableView == biometricTableVw {
                return biometricData.count
            } else if tableView == documentTableVw {
                return documentdata.count
            } else {
               
                return rFIDdata.count
            }
        }else if UserLocalStore.shared.clickedIndex == 3 {
            if tableView == biometricTableVw {
                return biometricData.count
            } else {
                return documentdata.count
            }
        }else{
            if tableView == biometricTableVw {
                return biometricData.count
            } else if tableView == documentTableVw {
                return documentdata.count
            } else {
                
                return rFIDdata.count
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = UIColor.white
        sectionView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
        let label = UILabel(frame: CGRect(x: 25, y: 0, width: tableView.bounds.width/2, height: 20))
        var sectionTitle: String = ""
        
        
        if UserLocalStore.shared.clickedIndex == 0 {
            if tableView == biometricTableVw && biometricData.count > 0 {
                sectionTitle = "biometric_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
            if tableView == documentTableVw && documentdata.count > 0 {
                sectionTitle = "document_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
            if UserLocalStore.shared.RFIDChipProcessing == true {
                if tableView == rfidTableVw && rFIDdata.count > 0 {
                    sectionTitle = "rfid_chip".localizeString(string: HomeDataManager.shared.languageCodeString)
                    label.textColor = UIColor.gray
                }
            }
            if tableView == metadataTableView && metaData.count > 0 {
                sectionTitle = "metadata".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
        }else if UserLocalStore.shared.clickedIndex == 1 {
            if tableView == biometricTableVw && biometricData.count > 0 {
                sectionTitle = "biometric_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
            if tableView == documentTableVw && documentdata.count > 0 {
                sectionTitle = "document_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
            
        }else if UserLocalStore.shared.clickedIndex == 2 {
            if tableView == biometricTableVw && biometricData.count > 0 {
                sectionTitle = "biometric_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
            if tableView == documentTableVw && documentdata.count > 0 {
                sectionTitle = "document_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
            if UserLocalStore.shared.RFIDChipProcessing == true {
                if tableView == rfidTableVw && rFIDdata.count > 0 {
                    sectionTitle = "rfid_chip".localizeString(string: HomeDataManager.shared.languageCodeString)
                    label.textColor = UIColor.gray
                }
            }
        }else if UserLocalStore.shared.clickedIndex == 3 {
            if tableView == biometricTableVw && biometricData.count > 0 {
                sectionTitle = "biometric_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
            if tableView == documentTableVw && documentdata.count > 0 {
                sectionTitle = "document_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
        }else if UserLocalStore.shared.clickedIndex == 4 {
            if tableView == biometricTableVw && biometricData.count > 0 {
                sectionTitle = "biometric_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
            if tableView == documentTableVw && documentdata.count > 0 {
                sectionTitle = "document_verification".localizeString(string: HomeDataManager.shared.languageCodeString)
                label.textColor = UIColor.black
            }
            if UserLocalStore.shared.RFIDChipProcessing == true {
                if tableView == rfidTableVw && rFIDdata.count > 0 {
                    sectionTitle = "rfid_chip".localizeString(string: HomeDataManager.shared.languageCodeString)
                    label.textColor = UIColor.gray
                }
            }
        }
        
        label.text = sectionTitle
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        sectionView.addSubview(label)
        return sectionView
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserLocalStore.shared.clickedIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocVerificationTCell", for: indexPath) as! DocVerificationTCell
            cell.delegate = self
//            cell.btnExPandCell.isSelected = yourDataModel[indexPath.row].isExpanded
//               cell.btnExPandCell.setImage(cell.btnExPandCell.isSelected ? UIImage(named: "dropdwn") : UIImage(named: "right arrow"), for: .normal)
            cell.lblMetadata.isHidden = true
            cell.selectionStyle = .none
            cell.btnExPandCell.isHidden = true
            
            if tableView == biometricTableVw {
                
                cell.lblTitle.text = biometricData[indexPath.row]
                if indexPath.row == 0 {
                    
                    if faceMatching == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceMatching == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else if indexPath.row == 1 {
                    
                    if faceLiveness == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceLiveness == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else{
                    cell.imgStatus.isHidden = true
                }
                
            }
            
            else if tableView == documentTableVw {
                cell.lblTitle.text = documentdata[indexPath.row]
                if indexPath.row == 0 {
                    cell.imgStatus.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Medium", size: 16)
                    cell.lblTitle.textColor = UIColor.gray
                    
                }
                else if  indexPath.row == 1 {
                    if(resultsDataValues.status.detailsOptical.docType.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 2 {
                    if(resultsDataValues.status.detailsOptical.text.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 3 {
                    var imgQualiyt = true
                    
                   
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 0 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 0 {
                            cell.imgFocus.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 1 {
                            cell.imgFocus.image = UIImage(named: "imgCheck")
                            
                        }else{
                            imgQualiyt = false
                            cell.imgFocus.image = UIImage(named: "minus")
                        }
                    }else{
                        cell.imgFocus.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 1 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 0 {
                            cell.imgGlare.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 1 {
                            cell.imgGlare.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgGlare.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgGlare.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 2 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 0 {
                            cell.imgPotrait.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 1 {
                            cell.imgPotrait.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPotrait.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPotrait.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 3 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 0 {
                            cell.imgBounds.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 1 {
                            cell.imgBounds.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgBounds.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgBounds.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 4 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 0 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 1 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 5 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 0 {
                            cell.imgFrame.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 1 {
                            cell.imgFrame.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgFrame.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgFrame.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                  
                    cell.btnExPandCell.isHidden = false
                    
                  
                    
                    if(imgQualiyt == true) {
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                }
                
               else if  indexPath.row == 4 {
                   
                    if(resultsDataValues.authenticityResults?.status.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.authenticityResults?.status.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else{
                    cell.btnExPandCell.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 14)
                    cell.lblTitle.textColor = UIColor.darkGray
                    cell.imgStatus.isHidden = false
                    cell.imgStatus.image = UIImage(named: "minus")
                }
                
            }
            
            
            else if tableView == rfidTableVw {

                cell.lblTitle.text = rFIDdata[indexPath.row]
                if( UserLocalStore.shared.haveNFCChip == false) {
                    cell.imgStatus.image = UIImage(named: "minus")
                }
                else {
                    if let rfidV = Int(rfidValues[indexPath.row]){
                        if rfidV == 2 {
                            cell.imgStatus.image = UIImage(named: "imgCross")
                        }
                        else {
                            cell.imgStatus.image = UIImage(named: "imgCheck")
                        }
                    }
                }
                
               
            }
            
            else{
                
                cell.lblMetadata.isHidden = false
                cell.imgStatus.isHidden = true
                cell.lblTitle.text = metaData[indexPath.row]
                print(resultsDataValues.elapsedTime)
                print(metaDataValues)
                cell.lblMetadata.text = "\(metaDataValues[indexPath.row])s"
                
            }
            return cell
        }
        
        else if UserLocalStore.shared.clickedIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocVerificationTCell", for: indexPath) as! DocVerificationTCell
            cell.lblMetadata.isHidden = true
            cell.delegate = self
            cell.selectionStyle = .none
            if tableView == biometricTableVw {

                cell.lblTitle.text = biometricData[indexPath.row]
                if indexPath.row == 0 {
                    
                    if faceMatching == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceMatching == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else if indexPath.row == 1 {
                    
                    if faceLiveness == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceLiveness == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else{
                    cell.imgStatus.isHidden = true
                }
            
            }
            else{
                cell.lblTitle.text = documentdata[indexPath.row]
                if indexPath.row == 0 {
                    cell.imgStatus.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Medium", size: 16)
                    cell.lblTitle.textColor = UIColor.gray
                    
                }
                else if  indexPath.row == 1 {
                    if(resultsDataValues.status.detailsOptical.docType.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 2 {
                    if(resultsDataValues.status.detailsOptical.text.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 3 {
                    var imgQualiyt = true
                    
                   
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 0 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 0 {
                            cell.imgFocus.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 1 {
                            cell.imgFocus.image = UIImage(named: "imgCheck")
                            
                        }else{
                            imgQualiyt = false
                            cell.imgFocus.image = UIImage(named: "minus")
                        }
                    }else{
                        cell.imgFocus.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 1 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 0 {
                            cell.imgGlare.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 1 {
                            cell.imgGlare.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgGlare.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgGlare.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 2 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 0 {
                            cell.imgPotrait.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 1 {
                            cell.imgPotrait.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPotrait.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPotrait.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 3 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 0 {
                            cell.imgBounds.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 1 {
                            cell.imgBounds.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgBounds.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgBounds.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 4 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 0 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 1 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 5 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 0 {
                            cell.imgFrame.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 1 {
                            cell.imgFrame.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgFrame.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgFrame.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                  
                    cell.btnExPandCell.isHidden = false
                    
                  
                    
                    if(imgQualiyt == true) {
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                }
                
               else if  indexPath.row == 4 {
                    if(resultsDataValues.authenticityResults?.status.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.authenticityResults?.status.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else{
                    cell.btnExPandCell.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 14)
                    cell.lblTitle.textColor = UIColor.darkGray
                    cell.imgStatus.isHidden = false
                    cell.imgStatus.image = UIImage(named: "minus")
                }
            }
            return cell
        }
        
        else if UserLocalStore.shared.clickedIndex == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocVerificationTCell", for: indexPath) as! DocVerificationTCell
            cell.delegate = self
            cell.lblMetadata.isHidden = true
            cell.selectionStyle = .none
            cell.btnExPandCell.isHidden = true
            
            if tableView == biometricTableVw {
                cell.lblTitle.text = biometricData[indexPath.row]
                
                if indexPath.row == 0 {
                    
                    if faceMatching == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceMatching == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else if indexPath.row == 1 {
                    
                    if faceLiveness == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceLiveness == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else{
                    cell.imgStatus.isHidden = true
                }
              
            }else if tableView == documentTableVw {

                cell.lblTitle.text = documentdata[indexPath.row]
                if indexPath.row == 0 {
                    cell.imgStatus.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Medium", size: 16)
                    cell.lblTitle.textColor = UIColor.gray
                    
                }else if  indexPath.row == 1 {
                    if(resultsDataValues.status.detailsOptical.docType.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                else if  indexPath.row == 2 {
                    if(resultsDataValues.status.detailsOptical.text.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                else if  indexPath.row == 4 {
                    if(resultsDataValues.authenticityResults?.status.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.authenticityResults?.status.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                else{
                    cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 14)
                    cell.lblTitle.textColor = UIColor.darkGray
                    cell.imgStatus.isHidden = false
                    cell.imgStatus.image = UIImage(named: "minus")
                }
             
                
            }else {
                
                cell.lblTitle.text = rFIDdata[indexPath.row]
                if let rfidV = Int(rfidValues[indexPath.row]){
                    if rfidV == 2 {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                }
                
            }
            return cell
        }else if UserLocalStore.shared.clickedIndex == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocVerificationTCell", for: indexPath) as! DocVerificationTCell
            cell.delegate = self
            cell.lblMetadata.isHidden = true
            cell.selectionStyle = .none
            cell.btnExPandCell.isHidden = true
            
            if tableView == biometricTableVw {

                cell.lblTitle.text = biometricData[indexPath.row]
                if indexPath.row == 0 {
                    
                    if faceMatching == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceMatching == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
 
                }else if indexPath.row == 1 {
                    
                    if faceLiveness == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceLiveness == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else{
                    cell.imgStatus.isHidden = true
                }
                return cell
                
            }else {
                
                cell.lblTitle.text = documentdata[indexPath.row]
                if indexPath.row == 0 {
                    cell.imgStatus.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Medium", size: 16)
                    cell.lblTitle.textColor = UIColor.gray
                    
                }
                else if  indexPath.row == 1 {
                    if(resultsDataValues.status.detailsOptical.docType.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                else {
                    cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 14)
                    cell.lblTitle.textColor = UIColor.darkGray
                    cell.imgStatus.isHidden = false
                    cell.imgStatus.image = UIImage(named: "minus")
                }
               
                
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocVerificationTCell", for: indexPath) as! DocVerificationTCell
            cell.delegate = self
            cell.lblMetadata.isHidden = true
            cell.selectionStyle = .none
            cell.btnExPandCell.isHidden = true
            
            if tableView == biometricTableVw {
                cell.lblTitle.text = biometricData[indexPath.row]
                if indexPath.row == 0 {
                    
                    if faceMatching == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceMatching == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else if indexPath.row == 1 {
                    
                    if faceLiveness == "1"{
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                      
                    }
                    else if faceLiveness == "2" {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }else{
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                    
                    
                    
                }else{
                    cell.imgStatus.isHidden = true
                }
              
            }else if tableView == documentTableVw {
                cell.lblTitle.text = documentdata[indexPath.row]
                if indexPath.row == 0 {
                    cell.imgStatus.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Medium", size: 16)
                    cell.lblTitle.textColor = UIColor.gray
                    
                }
                else if  indexPath.row == 1 {
                    if(resultsDataValues.status.detailsOptical.docType.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 2 {
                    if(resultsDataValues.status.detailsOptical.text.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.status.detailsOptical.text.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else if  indexPath.row == 3 {
                    var imgQualiyt = true
                    
                   
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 0 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 0 {
                            cell.imgFocus.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[0].result.rawValue == 1 {
                            cell.imgFocus.image = UIImage(named: "imgCheck")
                            
                        }else{
                            imgQualiyt = false
                            cell.imgFocus.image = UIImage(named: "minus")
                        }
                    }else{
                        cell.imgFocus.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 1 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 0 {
                            cell.imgGlare.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[1].result.rawValue == 1 {
                            cell.imgGlare.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgGlare.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgGlare.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 2 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 0 {
                            cell.imgPotrait.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[2].result.rawValue == 1 {
                            cell.imgPotrait.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPotrait.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPotrait.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 3 {
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 0 {
                            cell.imgBounds.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[3].result.rawValue == 1 {
                            cell.imgBounds.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgBounds.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgBounds.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 4 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 0 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[4].result.rawValue == 1 {
                            cell.imgPerspectiveAngle.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgPerspectiveAngle.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                    
                    
                    if resultsDataValues.imageQualityGroup![0].imageQualityList.count > 5 {
                        
                        if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 0 {
                            cell.imgFrame.image = UIImage(named: "imgCross")
                            imgQualiyt = false
                        }else if resultsDataValues.imageQualityGroup![0].imageQualityList[5].result.rawValue == 1 {
                            cell.imgFrame.image = UIImage(named: "imgCheck")
                        }else{
                            cell.imgFrame.image = UIImage(named: "minus")
                            imgQualiyt = false
                        }
                    }else{
                        cell.imgFrame.image = UIImage(named: "minus")
                        imgQualiyt = false
                    }
                  
                    cell.btnExPandCell.isHidden = false
                    
                  
                    
                    if(imgQualiyt == true) {
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                }
                
               else if  indexPath.row == 4 {
                    if(resultsDataValues.authenticityResults?.status.rawValue == 1){
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                   else if(resultsDataValues.authenticityResults?.status.rawValue == 0){
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "minus")
                    }
                }
                
                else{
                    cell.btnExPandCell.isHidden = true
                    cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 14)
                    cell.lblTitle.textColor = UIColor.darkGray
                    cell.imgStatus.isHidden = false
                    cell.imgStatus.image = UIImage(named: "minus")
                }
            }else {
                
                cell.lblTitle.text = rFIDdata[indexPath.row]
                if let rfidV = Int(rfidValues[indexPath.row]){
                    if rfidV == 2 {
                        cell.imgStatus.image = UIImage(named: "imgCross")
                    }
                    else {
                        cell.imgStatus.image = UIImage(named: "imgCheck")
                    }
                }
               
            }
            return cell
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserLocalStore.shared.clickedIndex == 0 {
            if tableView == documentTableVw {
                if selectedIndex == indexPath.row && isExpandCell == true {
                    return 330
                }else {
                    return 45
                }
                
            }else{
                return UITableView.automaticDimension
            }
        } else if UserLocalStore.shared.clickedIndex == 1 {
            if tableView == documentTableVw {
                if selectedIndex == indexPath.row && isExpandCell == true {
                    return 330
                }else {
                    return 45
                }
                
            }else{
                return UITableView.automaticDimension
            }
        }else if UserLocalStore.shared.clickedIndex == 2 {
            if tableView == documentTableVw {
                return 45
            }else{
                return UITableView.automaticDimension
            }
        }else if UserLocalStore.shared.clickedIndex == 3 {
            if tableView == documentTableVw {
                return 45
            }else{
                return UITableView.automaticDimension
            }
        }else {
            if tableView == documentTableVw {
                if selectedIndex == indexPath.row && isExpandCell == true {
                    return 330
                }else {
                    return 45
                }
                
            }else{
                return UITableView.automaticDimension
            }
        }
        
    }
    
}

