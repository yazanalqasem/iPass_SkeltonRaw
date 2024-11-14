//
//  AuthenticationVC.swift
//  ipass_plus
//
//  Created by Mobile on 07/02/24.
//

import UIKit

class AuthenticationVC: UIViewController {
    
    
    @IBOutlet weak var authTableVw: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    
    var isCommingFrom:String = ""
    var isTitle:String = ""
    var firstArr = [
        "Standard inspection procedure",
        "Advance inspection procedure",
        "General inspection procedure"
    ]
    
    var firstVisibleArr = [
        "standard_inspection_procedure".localizeString(string: HomeDataManager.shared.languageCodeString),
        "advance_inspection_procedure".localizeString(string: HomeDataManager.shared.languageCodeString),
        "general_inspection_procedure".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]
    
    var secondArr = [
        "BAC",
        "PACE"
    ]
    
    var secondVisibleArr = [
        "only_bac".localizeString(string: HomeDataManager.shared.languageCodeString),
        "only_pace".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]
    
    
    var thirdArr = ["MRZ",
                    "Profiler type",
                    "ISO protocol",
                    "of external CSCA"
    ]
    
    var thirdVisibleArr = [
        "mrz_title".localizeString(string: HomeDataManager.shared.languageCodeString),
        "profiler_type".localizeString(string: HomeDataManager.shared.languageCodeString),
        "iso_protocol".localizeString(string: HomeDataManager.shared.languageCodeString),
        "of_external_csca".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]
    
    var fourthArr = [
        
        "Doc 9303, 6th edition, 2006",
        "LSD and PKI Maintenance, v2.0, May21, 2014"
        
    ]
    
    var fourthVisibleArr = [
        
        "2006".localizeString(string: HomeDataManager.shared.languageCodeString),
        "2014".localizeString(string: HomeDataManager.shared.languageCodeString),
        
    ]
    
    
    var firstSwichArr = [
                         "Read elD",
                         "Data groups",
                         "Document type (DG1)",
                         "Issuing state (DG2)",
                         "Date of expiry (DG3)",
                         "Given name (DG4)",
                         "Family name (DG5)",
                         "Pseudonym (DG6)",
                         "Academic title (DG7)",
                         "Date of birth (DG8)",
                         "Place of birth (DG9)",
                         "Nationality (DG10)",
                         "Sex (DG11)",
                         "Optional details (DG12)",
                         "Undefined (DG13)",
                         "Undefined (DG14)",
                         "Undefined (DG15)",
                         "Undefined (DG16)",
                         "Place of registration (DG17)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeading.text = isTitle
        authTableVw.delegate = self
        authTableVw.dataSource = self
        
        let authNib = UINib(nibName: "ProcessingModeTableCell", bundle: nil)
        self.authTableVw.register(authNib, forCellReuseIdentifier: "ProcessingModeTableCell")
    }
    

    @IBAction func bnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
  
}
extension AuthenticationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCommingFrom == "one"{
            return firstArr.count
        }else if isCommingFrom == "two"{
            return secondArr.count
        }else if isCommingFrom == "three"{
            return thirdArr.count
        }else{
            return fourthArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell


           let clearView = UIView()
                  clearView.backgroundColor = UIColor.clear
                  cell.selectedBackgroundView = clearView
           
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
               cell.bottomLine.isHidden = true
           } else {
               cell.bottomLine.isHidden = false
           }
           
        
        if isCommingFrom == "one"{
            let shouldShowCheckmark = firstArr[indexPath.row] == UserLocalStore.shared.AuthenticationProcedureType
            cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
            
            cell.lblTitle.text = firstVisibleArr[indexPath.row]
        }else if  isCommingFrom == "two"{
            let shouldShowCheckmark = secondArr[indexPath.row] == UserLocalStore.shared.BasicSecurityMessagingProcedure
            cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
            cell.lblTitle.text = secondVisibleArr[indexPath.row]
        }else if isCommingFrom == "three"{
            cell.lblTitle.text = thirdVisibleArr[indexPath.row]
        }else{
            let shouldShowCheckmark = fourthArr[indexPath.row] ==  UserLocalStore.shared.ProfilerType
            cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
            cell.lblTitle.text = fourthVisibleArr[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProcessingModeTableCell
        if isCommingFrom == "one"{
            UserLocalStore.shared.AuthenticationProcedureType = firstArr[indexPath.row]
        }else if isCommingFrom == "two"{
            UserLocalStore.shared.BasicSecurityMessagingProcedure = secondArr[indexPath.row]
        }else if isCommingFrom == "three"{
            UserLocalStore.shared.AuthDataAccesKey = thirdArr[indexPath.row]
        }else{
            UserLocalStore.shared.ProfilerType = fourthArr[indexPath.row]
        }
        self.authTableVw.reloadData()
    }
}
