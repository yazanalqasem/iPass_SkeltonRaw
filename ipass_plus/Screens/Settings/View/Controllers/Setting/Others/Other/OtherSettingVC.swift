//
//  OtherSettingVC.swift
//  ipass_plus
//
//  Created by Mobile on 02/02/24.
//

import UIKit
import AVFoundation
import SafariServices

class OtherSettingVC: UIViewController {
    
    
    //MARK: IBoutlets
    @IBOutlet weak var settingTableVw: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    //MARK: Properties
    
  
    let sections = ["identity_verification".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "scanning_settings".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "sound_vibration".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "instructions".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "",
                    ""]
    
    
       let Titles = [
           ["face_matching_title".localizeString(string: HomeDataManager.shared.languageCodeString),
            "liveness".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["multipage_processing".localizeString(string: HomeDataManager.shared.languageCodeString),
            "double_page".localizeString(string: HomeDataManager.shared.languageCodeString),
            "rfid_chip_processing".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["sound".localizeString(string: HomeDataManager.shared.languageCodeString),
            "vibration".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["show_instructions".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["advanced".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["reset_all_settings".localizeString(string: HomeDataManager.shared.languageCodeString)]
       ]
    
    let Desriptions = [
       
        ["portrait_with_selfie".localizeString(string: HomeDataManager.shared.languageCodeString),
         "liveness_check".localizeString(string: HomeDataManager.shared.languageCodeString)],
      
        ["multipage_processing_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
         "double_page_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
         "rfid_chip_processing_desc".localizeString(string: HomeDataManager.shared.languageCodeString)],
        
        ["sound_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
         "vibration_desc".localizeString(string: HomeDataManager.shared.languageCodeString)],
        
        ["show_identity_desc".localizeString(string: HomeDataManager.shared.languageCodeString)],
        
        [""],
        
        [""]
    ]

    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableVw.delegate = self
        settingTableVw.dataSource = self
        headingLabel.text = "settings".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        let settingNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.settingTableVw.register(settingNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
        settingTableVw.estimatedRowHeight = UITableView.automaticDimension
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
   

}
 //MARK: UItableView Delegate and Datasource Method

extension OtherSettingVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingTableCell", for: indexPath) as! AdvanceSettingTableCell
        cell.lblTitle.text = Titles[indexPath.section][indexPath.row]
        cell.lblDescription.text = Desriptions[indexPath.section][indexPath.row]
        let tagValue = indexPath.section * 1000 + indexPath.row
        cell.btnSwitch.tag = tagValue
        cell.btnSwitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        if indexPath.row == 0 {
            cell.bottomline.isHidden = true
        }

        let clearView = UIView()
               clearView.backgroundColor = UIColor.clear
               cell.selectedBackgroundView = clearView
        
        if(Titles[indexPath.section].count - 1 == indexPath.row) {
            cell.bottomline.isHidden = true
        }else {
            cell.bottomline.isHidden = false
        }

        
        if indexPath.section == 0 {
            cell.lblTitle.textColor = UIColor.black
            cell.lblDescription.isHidden = false
            cell.lblDisable.isHidden = true
            cell.btnDropDown.isHidden = true
            cell.btnSwitch.isHidden = false
            if indexPath.row == 0 {
                cell.btnSwitch.isOn = UserLocalStore.shared.FaceMatching
            }else{
               
                cell.btnSwitch.isOn = UserLocalStore.shared.Liveness
            }
    
        }else if indexPath.section == 1 {
            cell.btnSwitch.isHidden = false
            cell.lblDescription.isHidden = false
            cell.btnDropDown.isHidden = true
            cell.lblDisable.isHidden = true
            
            if indexPath.row == 0 {
                cell.btnSwitch.isOn = UserLocalStore.shared.MultipageProcessing
            }else if indexPath.row == 1 {
                cell.btnSwitch.isOn = UserLocalStore.shared.DoublePageSpreadProcessing
            }else{
                cell.btnSwitch.isOn = UserLocalStore.shared.RFIDChipProcessing
            }
            
            
        }else if indexPath.section == 2 {
            cell.lblDescription.isHidden = false
            
            if indexPath.row == 0 {
                cell.lblDisable.isHidden = false
                cell.btnDropDown.isHidden = false
                cell.btnSwitch.isHidden = true
                if UserLocalStore.shared.SoundEnabled == true{
                    cell.lblDisable.text = "enable".localizeString(string: HomeDataManager.shared.languageCodeString)
                }else{
                    cell.lblDisable.text = "disable".localizeString(string: HomeDataManager.shared.languageCodeString)
                }
                
                
            } else if indexPath.row == 1 {
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.btnSwitch.isOn = UserLocalStore.shared.Vibration
            }
            
        } else if indexPath.section == 3 {
            cell.lblDescription.isHidden = false
            cell.btnSwitch.isHidden = true

        }else if indexPath.section == 4 {
            cell.lblDescription.isHidden = true
            cell.btnDropDown.isHidden = false
            cell.lblTitle.textColor = UIColor.black
            
        }else if indexPath.section == 5{
            cell.lblTitle.textColor =  UIColor.red
            cell.btnSwitch.isHidden = true
            cell.lblDescription.isHidden = true
            cell.btnDropDown.isHidden = true
            cell.lblDisable.isHidden = true
        }

        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        print("Button tapped in Section: \(section), Row: \(row)")
        if section == 0 {
             let indexPath = IndexPath(row: row, section: section)
              if let cell = settingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                  if indexPath.row == 0 {
                      UserLocalStore.shared.FaceMatching = cell.btnSwitch.isOn ? true : false
                  } else {
                      UserLocalStore.shared.Liveness = cell.btnSwitch.isOn ? true : false
                  }
              }
        }else if section == 1 {
            let indexPath = IndexPath(row: row, section: section)
             if let cell = settingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                 if indexPath.row == 0 {
                     UserLocalStore.shared.MultipageProcessing = cell.btnSwitch.isOn ? true : false
                 } else if indexPath.row == 1 {
                     UserLocalStore.shared.DoublePageSpreadProcessing = cell.btnSwitch.isOn ? true : false
                 }else{
                     UserLocalStore.shared.RFIDChipProcessing = cell.btnSwitch.isOn ? true : false
                 }
             }
        }else if section == 2 {
            let indexPath = IndexPath(row: row, section: section)
             if let cell = settingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                    if indexPath.row == 1 {
                        if cell.btnSwitch.isOn == true{
                            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                        }
                     UserLocalStore.shared.Vibration = cell.btnSwitch.isOn ? true : false
                 }
             }
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 15, height: 35))
        headerView.backgroundColor = self.view.backgroundColor

        
       let label = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.frame.width - 40, height: 20))
        label.font = UIFont.systemFont(ofSize: 12)
       // label.backgroundColor = .green
       label.text = "  " + sections[section]
       label.textColor = UIColor.lightGray
       
       headerView.addSubview(label)
       return headerView
   }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 35
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {

        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SoundVC") as! SoundVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            
        }else if indexPath.section == 3{
            
            openURLInSafari(urlString: "https://ipass-mena.com")
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OpenWebUrlVC") as! OpenWebUrlVC
////            self.navigationController?.pushViewController(vc, animated: true)
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
        }
        else if indexPath.section == 4{
            if indexPath.row == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AdVanceSettingVC") as!AdVanceSettingVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            UserLocalStore.shared.resetAllData()
            self.settingTableVw.reloadData()
        }
    }
    
    func openURLInSafari(urlString: String) {
          if let url = URL(string: urlString) {
              let safariViewController = SFSafariViewController(url: url)
              present(safariViewController, animated: true, completion: nil)
          }
      }
    
}
