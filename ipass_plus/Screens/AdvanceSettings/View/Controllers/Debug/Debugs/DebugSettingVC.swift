//
//  DebugSettingVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class DebugSettingVC: UIViewController {

    @IBOutlet weak var debugTableVw: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    var sections = ["",""]
    var titles = [[
        "save_event_logs".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_images".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_cropped_images".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_rfid_session".localizeString(string: HomeDataManager.shared.languageCodeString),
        "report_event_logs".localizeString(string: HomeDataManager.shared.languageCodeString),],
                  
                  ["show_metadata".localizeString(string: HomeDataManager.shared.languageCodeString)]]
    
     var descriptions = [[
        "save_event_logs_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_images_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_cropped_images_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
        "save_rfid_session_desc".localizeString(string: HomeDataManager.shared.languageCodeString),
        ""],["",""]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.debugTableVw.delegate = self
        self.debugTableVw.dataSource = self
        
        headingLabel.text = "debug_settings".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        let debugNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.debugTableVw.register(debugNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
extension DebugSettingVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingTableCell", for: indexPath) as! AdvanceSettingTableCell
        cell.lblTitle.text = titles[indexPath.section][indexPath.row]
        cell.lblDescription.text = descriptions[indexPath.section][indexPath.row]
        let tagValue = indexPath.section * 1000 + indexPath.row
        cell.btnSwitch.tag = tagValue
        cell.btnSwitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        if indexPath.row == 0 {
            cell.bottomline.isHidden = true
        }

        let clearView = UIView()
               clearView.backgroundColor = UIColor.clear
               cell.selectedBackgroundView = clearView
        
        if(titles[indexPath.section].count - 1 == indexPath.row) {
            cell.bottomline.isHidden = true
        }else {
            cell.bottomline.isHidden = false
        }

        
        
        if indexPath.section == 0 {
            cell.btnSwitch.isHidden = false
            cell.lblDescription.isHidden = false
            if indexPath.row == 0 {
                cell.btnSwitch.isOn = UserLocalStore.shared.SaveEventLogs
            }else if indexPath.row == 1 {
                cell.btnSwitch.isOn = UserLocalStore.shared.SaveImages
            }else if indexPath.row == 2 {
                cell.btnSwitch.isOn = UserLocalStore.shared.SaveCroppedImages
            }else if indexPath.row == 3 {
                cell.btnSwitch.isOn = UserLocalStore.shared.SaveRFIDSession
            }else {
                cell.btnDropDown.isHidden = false
                cell.btnSwitch.isHidden = true
                cell.lblDescription.isHidden = true
            }
        }else {
            cell.btnSwitch.isHidden = false
            cell.btnDropDown.isHidden = true
            cell.lblDescription.isHidden = true
            cell.lblDisable.isHidden = true
            cell.btnSwitch.isOn = UserLocalStore.shared.ShowMetadata
                
 
//            else{
//                cell.btnSwitch.isOn = UserLocalStore.shared.ShowCompleteListOfScenarios
//            }
        }
        return cell
    }
    
    
    @objc func buttonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        print("Button tapped in Section: \(section), Row: \(row)")
        if section == 0 {
             let indexPath = IndexPath(row: row, section: section)
              if let cell = debugTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                  if indexPath.row == 0 {
                      UserLocalStore.shared.SaveEventLogs = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 1 {
                      UserLocalStore.shared.SaveImages = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 2 {
                      UserLocalStore.shared.SaveCroppedImages = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 3 {
                      UserLocalStore.shared.SaveRFIDSession = cell.btnSwitch.isOn ? true : false
                  }
              }
        }else if section == 1 {
            let indexPath = IndexPath(row: row, section: section)
             if let cell = debugTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                 if indexPath.row == 0 {
                     UserLocalStore.shared.ShowMetadata = cell.btnSwitch.isOn ? true : false
                 }
//                 else if indexPath.row == 1 {
//                     UserLocalStore.shared.ShowCompleteListOfScenarios = cell.btnSwitch.isOn ? true : false
//                 }
             }
        }else{
            print("comming soon..")
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 25))
        headerView.backgroundColor = self.view.backgroundColor

       let label = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 20))
        label.font = UIFont.systemFont(ofSize: 12)
       label.text = "  " + sections[section]
       label.textColor = UIColor.lightGray
       
       headerView.addSubview(label)
       return headerView
   }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 25
        
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 4{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventLogVC") as! EventLogVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            print("Comming soon...")
        }
    }
}
