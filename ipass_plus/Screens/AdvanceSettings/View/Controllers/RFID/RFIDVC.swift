//
//  RFIDVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class RFIDVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var rfidTableVw: UITableView!
    @IBOutlet weak var vwLineFirst: UIView!
    @IBOutlet weak var vwLineSecond: UIView!
    @IBOutlet weak var segmentVw: UIView!
    @IBOutlet weak var segmentViewHyt: NSLayoutConstraint!
    @IBOutlet weak var btnAuthenticaton: UIButton!
    @IBOutlet weak var btnGroups: UIButton!
    
    @IBOutlet weak var headingLabel: UILabel!
    var isRFIDType = ""
    var visibleIndexPaths: [IndexPath] = []
    var ePassportSwitchOn = false
    var eIDSwitchOn = false
    var eDLSwitchOn = false
//    var indexPathValue = IndexPath()
    
    var authenticateArr = [
        "procedure_type".localizeString(string: HomeDataManager.shared.languageCodeString),
        "messaging_procedure".localizeString(string: HomeDataManager.shared.languageCodeString),
        "access_key".localizeString(string: HomeDataManager.shared.languageCodeString),
        "keys_value".localizeString(string: HomeDataManager.shared.languageCodeString),
        "ds_certificates".localizeString(string: HomeDataManager.shared.languageCodeString),
        "csca_certificates".localizeString(string: HomeDataManager.shared.languageCodeString),
        "pkd_certificates".localizeString(string: HomeDataManager.shared.languageCodeString),
        "passive_aAuthentication".localizeString(string: HomeDataManager.shared.languageCodeString),
        "aa_after_ca".localizeString(string: HomeDataManager.shared.languageCodeString),
        "profiler_type".localizeString(string: HomeDataManager.shared.languageCodeString),
        "strict_iso".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]
    
    var ePassPortArr = [String]()
    var eIDArr = [String]()
    var eDLArr = [String]()
    var segmentIndex = 0
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        headingLabel.text = "only_rfid".localizeString(string: HomeDataManager.shared.languageCodeString)
        btnGroups.setTitle("data_groups".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        btnAuthenticaton.setTitle("only_authentication".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        
        rfidTableVw.delegate = self
        rfidTableVw.dataSource = self
        vwLineFirst.layer.backgroundColor = UIColor(named: "blueColor")?.cgColor
        isRFIDType = "Auth"
        
        let rfidNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.rfidTableVw.register(rfidNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
        
        segmentController.selectedSegmentTintColor(UIColor.black)
        segmentController.unselectedSegmentTintColor(UIColor(red: 23/255, green: 112/255, blue: 69/255, alpha: 1.0))
        segmentController.backgroundColor = UIColor.white
        segmentIndex = segmentController.selectedSegmentIndex
        segmentController.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 14.0)! ], for: .normal)

        segmentController.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
    }
    
    
    // MARK: - Objective-c Function
      @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
          if sender.selectedSegmentIndex == 0 {
             let data = [
                "read_passport".localizeString(string: HomeDataManager.shared.languageCodeString),
                "machine_readable_zone".localizeString(string: HomeDataManager.shared.languageCodeString),
                "facial_data".localizeString(string: HomeDataManager.shared.languageCodeString),
                "fingerprints".localizeString(string: HomeDataManager.shared.languageCodeString),
                "iris_data".localizeString(string: HomeDataManager.shared.languageCodeString),
                "portrait_dg5".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg6".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg7".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg8".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg9".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg10".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg11".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg12".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg13".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg14".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg15".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg16".localizeString(string: HomeDataManager.shared.languageCodeString),
             ]
              ePassPortArr = data
          }else if sender.selectedSegmentIndex == 1  {
              let data = [
                "Read_elD".localizeString(string: HomeDataManager.shared.languageCodeString),
                "data_groups".localizeString(string: HomeDataManager.shared.languageCodeString),
                "document_type_dg1".localizeString(string: HomeDataManager.shared.languageCodeString),
                "issuing_state_dg2".localizeString(string: HomeDataManager.shared.languageCodeString),
                "date_of_expiry_dg3".localizeString(string: HomeDataManager.shared.languageCodeString),
                "given_name_dg4".localizeString(string: HomeDataManager.shared.languageCodeString),
                "family_name_dg5".localizeString(string: HomeDataManager.shared.languageCodeString),
                "pseudonym".localizeString(string: HomeDataManager.shared.languageCodeString),
                "academic_title".localizeString(string: HomeDataManager.shared.languageCodeString),
                "date_of_birthdg8".localizeString(string: HomeDataManager.shared.languageCodeString),
                "place_of_birth_dg9".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg10".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg11".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg12".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg13".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg14".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg15".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg16".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg17".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg18".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg19".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg20".localizeString(string: HomeDataManager.shared.languageCodeString),
                "2dg21".localizeString(string: HomeDataManager.shared.languageCodeString),
              ]
               eIDArr = data
          }else{
              let data = [
                "3read_eDL".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3data_groups".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3text_data_elements".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg2".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg3".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg4".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg5".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg6".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg7".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg8".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg9".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg10".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg11".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg12".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg13".localizeString(string: HomeDataManager.shared.languageCodeString),
                "3dg14".localizeString(string: HomeDataManager.shared.languageCodeString),
              ]
               eDLArr = data
          }
         
          DispatchQueue.main.async {
              self.segmentIndex = sender.selectedSegmentIndex
              self.rfidTableVw.reloadData()
          }
      }
    
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnActionsAuthGroups(_ sender: UIButton) {
        if sender.tag == 10 {
            isRFIDType = "Auth"
            vwLineSecond.layer.backgroundColor = UIColor.white.cgColor
            vwLineFirst.layer.backgroundColor = UIColor(named: "blueColor")?.cgColor
            segmentVw.isHidden = true
          //  DispatchQueue.main.async {
                self.rfidTableVw.reloadData()
          //  }
        }
        
        else{
            isRFIDType = "Group"
            vwLineFirst.layer.backgroundColor = UIColor.white.cgColor
            vwLineSecond.layer.backgroundColor = UIColor(named: "blueColor")?.cgColor
            segmentVw.isHidden = false
            

            
            let data = [
                "read_passport".localizeString(string: HomeDataManager.shared.languageCodeString),
                "machine_readable_zone".localizeString(string: HomeDataManager.shared.languageCodeString),
                "facial_data".localizeString(string: HomeDataManager.shared.languageCodeString),
                "fingerprints".localizeString(string: HomeDataManager.shared.languageCodeString),
                "iris_data".localizeString(string: HomeDataManager.shared.languageCodeString),
                "portrait_dg5".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg6".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg7".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg8".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg9".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg10".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg11".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg12".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg13".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg14".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg15".localizeString(string: HomeDataManager.shared.languageCodeString),
                "dg16".localizeString(string: HomeDataManager.shared.languageCodeString),
            
            ]
             ePassPortArr = data
            
            DispatchQueue.main.async {
                self.rfidTableVw.reloadData()
            }
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if isRFIDType == "Auth"{
            return authenticateArr.count
        }
        else{
            if segmentIndex == 1 {
                return eIDArr.count
            }else if segmentIndex == 2  {
                return eDLArr.count
            }else{
                return ePassPortArr.count
            }
           
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingTableCell", for: indexPath) as! AdvanceSettingTableCell
        
        cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 15)
        let tagValue = segmentIndex * 1000 + indexPath.row
        cell.btnSwitch.tag = tagValue
        cell.btnSwitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
               cell.bottomline.isHidden = true
           } else {
               cell.bottomline.isHidden = false
           }
           
        
            if isRFIDType == "Auth"{
                cell.lblTitle.text = authenticateArr[indexPath.row]
                cell.btnSwitch.isHidden = false
                if indexPath.row == 0 ||  indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 9 {
                    cell.btnSwitch.isHidden = true
                    cell.btnDropDown.isHidden = false
                }else if  indexPath.row == 2{
                    cell.btnSwitch.isHidden = true
                    cell.btnDropDown.isHidden = false
                    cell.lblDisable.isHidden = false
                    cell.lblDisable.text = "MRZ"
                }else if indexPath.row == 4 {
                    cell.btnSwitch.isOn = UserLocalStore.shared.PriorityUsingDSCertificates
                }else if indexPath.row == 5 {
                    cell.btnSwitch.isOn = UserLocalStore.shared.UseExternalCSCACertificates
                }else if indexPath.row == 6 {
                    cell.btnSwitch.isOn = UserLocalStore.shared.TrustPKDCertificates
                }else if indexPath.row == 7 {
                    cell.btnSwitch.isOn = UserLocalStore.shared.PassiveAuthentication
                }else if indexPath.row == 8 {
                    cell.btnSwitch.isOn = UserLocalStore.shared.PerformAAAfterCA
                }else if indexPath.row == 10{
                    cell.btnDropDown.isHidden = true
                    cell.lblDisable.isHidden = true
                    cell.btnSwitch.isOn = UserLocalStore.shared.StrictISOProtocol
                }
                
                
            }else if  isRFIDType == "Group"{

                
                     if segmentIndex == 1 {


                    cell.lblTitle.text = eIDArr[indexPath.row]
                    cell.btnSwitch.isHidden = false
                    cell.btnDropDown.isHidden = true
                    cell.lblDisable.isHidden = true
                         
                         
                         
                         if(UserLocalStore.shared.ReadElD == false) {
                             if indexPath.row != 0 {
                                 cell.btnSwitch.isEnabled = false
                             }
                             else {
                                 cell.btnSwitch.isEnabled = true
                             }
                         }
                         else {
                             cell.btnSwitch.isEnabled = true
                         }

                        
                         
                    if indexPath.row == 0 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.ReadElD
                    }else if indexPath.row == 1 {
                        cell.btnSwitch.isHidden = true
                        cell.lblTitle.textColor = UIColor.darkGray
                    }else if indexPath.row == 2 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.DocumentType
                    }else if indexPath.row == 3 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.IssuingState
                    }else if indexPath.row == 4 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.DateOfExpiry
                    }else if indexPath.row == 5{
                        cell.btnSwitch.isOn = UserLocalStore.shared.GivenName
                    }else if indexPath.row == 6{
                        cell.btnSwitch.isOn = UserLocalStore.shared.FamilyName
                    }else if indexPath.row == 7{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Pseudonym
                    }else if indexPath.row == 8{
                        cell.btnSwitch.isOn = UserLocalStore.shared.AcademicTitle
                    }else if indexPath.row == 9{
                        cell.btnSwitch.isOn = UserLocalStore.shared.DateOfBirth
                    }else if indexPath.row == 10{
                        cell.btnSwitch.isOn = UserLocalStore.shared.PlaceOfBirth
                    }else if indexPath.row == 11{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Nationality
                    }else if indexPath.row == 12{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Sex
                    }else if indexPath.row == 13{
                        cell.btnSwitch.isOn = UserLocalStore.shared.OptionalDetailsDG12
                    }else if indexPath.row == 14{
                        cell.btnSwitch.isOn = UserLocalStore.shared.UndefinedDG13
                    }else if indexPath.row == 15{
                        cell.btnSwitch.isOn = UserLocalStore.shared.UndefinedDG14
                    }else if indexPath.row == 16{
                        cell.btnSwitch.isOn = UserLocalStore.shared.UndefinedDG15
                    }else if indexPath.row == 17{
                        cell.btnSwitch.isOn = UserLocalStore.shared.UndefinedDG16
                    }else if indexPath.row == 18{
                        cell.btnSwitch.isOn = UserLocalStore.shared.PlaceOfRegistrationDG17
                    }else if indexPath.row == 19{
                        cell.btnSwitch.isOn = UserLocalStore.shared.PlaceOfRegistrationDG18
                    }else if indexPath.row == 20{
                        cell.btnSwitch.isOn = UserLocalStore.shared.ResidencePermit1DG19
                    }else if indexPath.row == 21{
                        cell.btnSwitch.isOn = UserLocalStore.shared.ResidencePermit2DG20
                    }else if indexPath.row == 22{
                        cell.btnSwitch.isOn = UserLocalStore.shared.OptionalDetailsDG21
                    }
                    
                    
                }else if segmentIndex == 2 {

                    cell.lblTitle.text = eDLArr[indexPath.row]
                    cell.btnSwitch.isHidden = false
                    cell.btnDropDown.isHidden = true
                    cell.lblDisable.isHidden = true
                    
                    
                    if(UserLocalStore.shared.ReadEDL == false) {
                        if indexPath.row != 0 {
                            cell.btnSwitch.isEnabled = false
                        }
                        else {
                            cell.btnSwitch.isEnabled = true
                        }
                    }
                    else {
                        cell.btnSwitch.isEnabled = true
                    }
                    
                    if indexPath.row == 0 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.ReadEDL
                    }else if indexPath.row == 1 {
                        cell.btnSwitch.isHidden = true
                        cell.lblTitle.textColor = UIColor.darkGray
                    }else if indexPath.row == 2 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.TextDataElementsDG1
                    }else if indexPath.row == 3 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.LicenseHolderInformationDG2
                    }else if indexPath.row == 4 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.IssuingAuthorityDetailsDG3
                    }else if indexPath.row == 5{
                        cell.btnSwitch.isOn = UserLocalStore.shared.PortraitImageDG4
                    }else if indexPath.row == 6{
                        cell.btnSwitch.isOn = UserLocalStore.shared.SignatureUsualMarkImageDG5
                    }else if indexPath.row == 7{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_FacialDataDG6
                    }else if indexPath.row == 8{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_FingerprintDG7
                    }else if indexPath.row == 9{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_IrisDataDG8
                    }else if indexPath.row == 10{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_OtherDG9
                    }else if indexPath.row == 11{
                        cell.btnSwitch.isOn = UserLocalStore.shared.EDL_NotDefinedDG10
                    }else if indexPath.row == 12{
                        cell.btnSwitch.isOn = UserLocalStore.shared.OptionalDomesticDataDG11
                    }else if indexPath.row == 13{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Non_MatchAlertDG12
                    }else if indexPath.row == 14{
                        cell.btnSwitch.isOn = UserLocalStore.shared.ActiveAuthenticationInfoDG13
                    }else if indexPath.row == 15{
                        cell.btnSwitch.isOn = UserLocalStore.shared.EACInfoDG14
                    }
                }else{

                    cell.lblTitle.text = ePassPortArr[indexPath.row]
                    cell.btnSwitch.isHidden = false
                    cell.btnDropDown.isHidden = true
                    cell.lblDisable.isHidden = true
                    
                    if(UserLocalStore.shared.ReadEPassport == false) {
                        if indexPath.row != 0 {
                            cell.btnSwitch.isEnabled = false
                        }
                        else {
                            cell.btnSwitch.isEnabled = true
                        }
                    }
                    else {
                        cell.btnSwitch.isEnabled = true
                    }
                    if indexPath.row == 0 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.ReadEPassport
                    }else if indexPath.row == 1 {
                        cell.btnSwitch.isHidden = true
                        cell.lblTitle.textColor = UIColor.darkGray
                    }else if indexPath.row == 2 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.MachineReadableZone
                    }else if indexPath.row == 3 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_FacialData
                    }else if indexPath.row == 4 {
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_Fingerprints
                    }else if indexPath.row == 5{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Biometry_IrisData
                    }else if indexPath.row == 6{
                        cell.btnSwitch.isOn = UserLocalStore.shared.Portrait
                    }else if indexPath.row == 7{
                        cell.btnSwitch.isOn = UserLocalStore.shared.NotDefinedDG6
                    }else if indexPath.row == 8{
                        cell.btnSwitch.isOn = UserLocalStore.shared.SignatureUsualMarkImage
                    }else if indexPath.row == 9{
                        cell.btnSwitch.isOn = UserLocalStore.shared.NotDefinedDG8
                    }else if indexPath.row == 10{
                        cell.btnSwitch.isOn = UserLocalStore.shared.NotDefinedDG9
                    }else if indexPath.row == 11{
                        cell.btnSwitch.isOn = UserLocalStore.shared.NotDefinedDG10
                    }else if indexPath.row == 12{
                        cell.btnSwitch.isOn = UserLocalStore.shared.AdditionalPersonalDetail
                    }else if indexPath.row == 13{
                        cell.btnSwitch.isOn = UserLocalStore.shared.AdditionalDocumentDetail
                    }else if indexPath.row == 14{
                        cell.btnSwitch.isOn = UserLocalStore.shared.OptionalDetail
                    }else if indexPath.row == 15{
                        cell.btnSwitch.isOn = UserLocalStore.shared.EACInfo
                    }else if indexPath.row == 16{
                        cell.btnSwitch.isOn = UserLocalStore.shared.ActiveAuthenticationInfo
                    }else if indexPath.row == 17{
                        cell.btnSwitch.isOn = UserLocalStore.shared.PersonToNotify
                    }
                    
                }
            }

        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let segmentIndex = sender.tag / 1000
        let row = sender.tag % 1000
        
        print("Button tapped in Section: \(segmentIndex), Row: \(row)")
        if isRFIDType == "Auth"{
            let indexPath = IndexPath(row: row, section: 0)
             if let cell = rfidTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                 if indexPath.row == 4 {
                     UserLocalStore.shared.PriorityUsingDSCertificates = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 5 {
                     UserLocalStore.shared.UseExternalCSCACertificates = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 6 {
                     UserLocalStore.shared.TrustPKDCertificates = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 7 {
                     UserLocalStore.shared.PassiveAuthentication = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 8 {
                     UserLocalStore.shared.PerformAAAfterCA = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 10 {
                     UserLocalStore.shared.StrictISOProtocol = cell.btnSwitch.isOn ? true : false
                 }
             }
       }
        
        else {
//           if indexPathValue.row == 0 {
//               eIDSwitchOn = sender.isOn
//               rfidTableVw.reloadData() rfidTableVw.reloadData()
//           }
          
            
           
                if segmentIndex == 1 {
                    let indexPath = IndexPath(row: row, section: 0)
                   
                    
                if let cell = rfidTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                    if indexPath.row == 0 {
                    UserLocalStore.shared.ReadElD = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 2 {
                        UserLocalStore.shared.DocumentType = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 3 {
                        UserLocalStore.shared.IssuingState = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 4 {
                        UserLocalStore.shared.DateOfExpiry = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 5{
                        UserLocalStore.shared.GivenName = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 6{
                        UserLocalStore.shared.FamilyName = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 7{
                        UserLocalStore.shared.Pseudonym = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 8{
                        UserLocalStore.shared.AcademicTitle = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 9{
                        UserLocalStore.shared.DateOfBirth = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 10{
                        UserLocalStore.shared.PlaceOfBirth = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 11{
                        UserLocalStore.shared.Nationality = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 12{
                        UserLocalStore.shared.Sex = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 13{
                        UserLocalStore.shared.OptionalDetailsDG12 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 14{
                        UserLocalStore.shared.UndefinedDG13 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 15{
                        UserLocalStore.shared.UndefinedDG14 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 16{
                        UserLocalStore.shared.UndefinedDG15 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 17{
                        UserLocalStore.shared.UndefinedDG16 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 18{
                        UserLocalStore.shared.PlaceOfRegistrationDG17 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 19{
                        UserLocalStore.shared.PlaceOfRegistrationDG18 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 20{
                        UserLocalStore.shared.ResidencePermit1DG19 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 21{
                        UserLocalStore.shared.ResidencePermit2DG20 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 22{
                        UserLocalStore.shared.OptionalDetailsDG21 = cell.btnSwitch.isOn ? true : false
                    }
                }
                    
                    if(indexPath.row == 0) {
                        rfidTableVw.reloadData()
                    }
           }
            
            else if segmentIndex == 2 {
               let indexPath = IndexPath(row: row, section: 0)
              
                if let cell = rfidTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                    if indexPath.row == 0 {
                        UserLocalStore.shared.ReadEDL = cell.btnSwitch.isOn ? true : false
//                        eDLSwitchOn = sender.isOn
//                        rfidTableVw.reloadData()
                    }else if indexPath.row == 2 {
                        UserLocalStore.shared.TextDataElementsDG1 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 3 {
                        UserLocalStore.shared.LicenseHolderInformationDG2 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 4 {
                        UserLocalStore.shared.IssuingAuthorityDetailsDG3 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 5{
                        UserLocalStore.shared.PortraitImageDG4 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 6{
                        UserLocalStore.shared.SignatureUsualMarkImageDG5 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 7{
                        UserLocalStore.shared.Biometry_FacialDataDG6 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 8{
                        UserLocalStore.shared.Biometry_FingerprintDG7 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 9{
                        UserLocalStore.shared.Biometry_IrisDataDG8 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 10{
                        UserLocalStore.shared.Biometry_OtherDG9 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 11{
                        UserLocalStore.shared.EDL_NotDefinedDG10 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 12{
                        UserLocalStore.shared.OptionalDomesticDataDG11 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 13{
                        UserLocalStore.shared.Non_MatchAlertDG12 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 14{
                        UserLocalStore.shared.ActiveAuthenticationInfoDG13 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 15{
                        UserLocalStore.shared.EACInfoDG14 = cell.btnSwitch.isOn ? true : false
                    }
                }
               if(indexPath.row == 0) {
                   rfidTableVw.reloadData()
               }
           }
            
            else{
               let indexPath = IndexPath(row: row, section: 0)
              
                if let cell = rfidTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                    if indexPath.row == 0 {
                        UserLocalStore.shared.ReadEPassport = cell.btnSwitch.isOn ? true : false
//                        ePassportSwitchOn = sender.isOn
//                        rfidTableVw.reloadData()
                    }else if indexPath.row == 2 {
                        UserLocalStore.shared.MachineReadableZone = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 3 {
                        UserLocalStore.shared.Biometry_FacialData = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 4 {
                        UserLocalStore.shared.Biometry_Fingerprints = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 5{
                        UserLocalStore.shared.Biometry_IrisData = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 6{
                        UserLocalStore.shared.Portrait = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 7{
                        UserLocalStore.shared.NotDefinedDG6 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 8{
                        UserLocalStore.shared.SignatureUsualMarkImage = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 9{
                        UserLocalStore.shared.NotDefinedDG8 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 10{
                        UserLocalStore.shared.NotDefinedDG9 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 11{
                        UserLocalStore.shared.NotDefinedDG10 = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 12{
                        UserLocalStore.shared.AdditionalPersonalDetail = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 13{
                        UserLocalStore.shared.AdditionalDocumentDetail = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 14{
                        UserLocalStore.shared.OptionalDetail = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 15{
                        UserLocalStore.shared.EACInfo = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 16{
                        UserLocalStore.shared.ActiveAuthenticationInfo = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 17{
                        UserLocalStore.shared.PersonToNotify = cell.btnSwitch.isOn ? true : false
                    }
                }
               if(indexPath.row == 0) {
                   rfidTableVw.reloadData()
               }
           }

        }
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = rfidTableVw.cellForRow(at: indexPath) as! AdvanceSettingTableCell
        if isRFIDType == "Auth"{
            if indexPath.row == 0 {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationVC
        vc.isCommingFrom = "one"
                vc.isTitle = "Authentication procedure type"
//        self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationVC
                vc.isCommingFrom = "two"
                        vc.isTitle = "Basic Security Messaging procedure"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationVC
                vc.isCommingFrom = "three"
                        vc.isTitle = "Data access key"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 3 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Data access key"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 9{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AuthenticationVC") as! AuthenticationVC
                vc.isCommingFrom = "four"
                vc.isTitle = "Profiler type"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                print("No data")
            }
        }else{
        }
        
           
    }
    
}



// MARK: - Segment Color
extension UISegmentedControl{
    func selectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .selected)
    }
    func unselectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .normal)
    }
}
