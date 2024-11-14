//
//  AdVanceSettingVC.swift
//  ipass_plus
//
//  Created by Mobile on 05/02/24.
//

import UIKit

class AdVanceSettingVC: UIViewController {
    //MARK: IBoutlets
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var backgroundPopUpVw: UIView!
    @IBOutlet weak var lang_popUpVw: UIView!
    @IBOutlet weak var SettingTableVw: UITableView!
    
    @IBOutlet weak var languageHeading: UILabel!
    @IBOutlet weak var languageCancelBtn: UIButton!
    @IBOutlet weak var languageDesc: UILabel!
    @IBOutlet weak var languagePoints: UILabel!
    //MARK: Properties
    
    @IBOutlet weak var headingLabel: UILabel!
    let sections = ["","interface_settings".localizeString(string: HomeDataManager.shared.languageCodeString), "", "","","",""]
    
       let Titles = [
           ["debug".localizeString(string: HomeDataManager.shared.languageCodeString)],
          
           ["capture_button".localizeString(string: HomeDataManager.shared.languageCodeString),
            "camera_switch".localizeString(string: HomeDataManager.shared.languageCodeString),
            "hint_messages".localizeString(string: HomeDataManager.shared.languageCodeString),
            "help".localizeString(string: HomeDataManager.shared.languageCodeString),
            "language".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["timeout".localizeString(string: HomeDataManager.shared.languageCodeString),
            "timeout_detection".localizeString(string: HomeDataManager.shared.languageCodeString),
            "timeout_identification".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["motion_detection".localizeString(string: HomeDataManager.shared.languageCodeString),
            "focusing_detection".localizeString(string: HomeDataManager.shared.languageCodeString),
            "processing_modes".localizeString(string: HomeDataManager.shared.languageCodeString),
            "camera_resolution".localizeString(string: HomeDataManager.shared.languageCodeString),
            "adiust_zoom".localizeString(string: HomeDataManager.shared.languageCodeString),
            "zoom_level".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["manual_crop".localizeString(string: HomeDataManager.shared.languageCodeString),
            "minimum_dpi".localizeString(string: HomeDataManager.shared.languageCodeString),
            "perspective_angle".localizeString(string: HomeDataManager.shared.languageCodeString),
            "integral_image".localizeString(string: HomeDataManager.shared.languageCodeString),
            "hologram_detection".localizeString(string: HomeDataManager.shared.languageCodeString),
            "image_quality".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["date_format".localizeString(string: HomeDataManager.shared.languageCodeString),
            "document_filter".localizeString(string: HomeDataManager.shared.languageCodeString),
            "custom_parameters".localizeString(string: HomeDataManager.shared.languageCodeString)],
           
           ["rfid_chip".localizeString(string: HomeDataManager.shared.languageCodeString)]
       ]
    
    let Desriptions = [
        [""],
        
        ["button_for_capturing".localizeString(string: HomeDataManager.shared.languageCodeString),
         "button_for_switching".localizeString(string: HomeDataManager.shared.languageCodeString),
         "hints_during_video".localizeString(string: HomeDataManager.shared.languageCodeString),
         "instructional_animation".localizeString(string: HomeDataManager.shared.languageCodeString),
         "application_language".localizeString(string: HomeDataManager.shared.languageCodeString)],
        
        ["","",""],
        
        ["pause_scanning".localizeString(string: HomeDataManager.shared.languageCodeString),
         "camera_is_focusing".localizeString(string: HomeDataManager.shared.languageCodeString),
         "","","",""],
        
        ["","","","","",""],
        
        ["select_date_format".localizeString(string: HomeDataManager.shared.languageCodeString),
         "","",""],
        [""]
    ]

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingTableVw.delegate = self
        SettingTableVw.dataSource = self
        
        headingLabel.text = "advanced_settings".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        languageHeading.text = "set_application_language".localizeString(string: HomeDataManager.shared.languageCodeString)
        languagePoints.text = "language_points".localizeString(string: HomeDataManager.shared.languageCodeString)
        languageDesc.text = "language_desc".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        btnContinue.setTitle("continue".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        languageCancelBtn.setTitle("cancel".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        
        let settingNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.SettingTableVw.register(settingNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
        
        backgroundPopUpVw.isHidden = true
        lang_popUpVw.isHidden = true
        btnContinue.layer.cornerRadius = 10
        lang_popUpVw.layer.cornerRadius = 20
    }
    

    @IBAction func BntBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnActionForLang(_ sender: UIButton) {
        openLanguangeTab()

    }
    
    
    
    @IBAction func btnCancelPopUp(_ sender: Any) {
        backgroundPopUpVw.isHidden = true
        lang_popUpVw.isHidden = true
    }
    
    
    
    func openLanguangeTab(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    
   
}
    //MARK: UItableView Delegate and Datasource Method
extension AdVanceSettingVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
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
        
        let clearView = UIView()
               clearView.backgroundColor = UIColor.clear
               cell.selectedBackgroundView = clearView
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
               cell.bottomline.isHidden = true
           } else {
               cell.bottomline.isHidden = false
           }

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = true
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden = false
            }
        }else if indexPath.section == 1 {
            cell.lblDescription.isHidden = false
            cell.btnSwitch.isHidden = false
            cell.lblDisable.isHidden = true
            if indexPath.row == 0  {
                cell.btnDropDown.isHidden  = true
                cell.btnSwitch.isOn = UserLocalStore.shared.CaptureButton

            }else if indexPath.row == 1 {
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden  = true
                cell.btnSwitch.isOn = UserLocalStore.shared.CameraSwitchButton

            }
            else if indexPath.row == 2 {
                cell.btnDropDown.isHidden  = true
                cell.btnSwitch.isOn = UserLocalStore.shared.HintMessages
            }else if indexPath.row == 3 {
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden  = true
                cell.btnSwitch.isOn = UserLocalStore.shared.Help
            }
            else if indexPath.row == 4 {
                cell.btnSwitch.isHidden = true
            }
        }else if indexPath.section == 2 {
            cell.lblDisable.isHidden = true
            cell.btnSwitch.isHidden = true
            cell.btnDropDown.isHidden = false
            if indexPath.row == 0 {
            }else if indexPath.row == 1 {
                cell.lblDescription.isHidden = true
                }
            else if indexPath.row == 2 {
            }
        }else if indexPath.section == 3 {
         
            if indexPath.row == 0 {
                cell.btnDropDown.isHidden = true
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.lblDescription.isHidden = false
                cell.btnSwitch.isOn = UserLocalStore.shared.MotionDetection
            }else if  indexPath.row == 1 {
                cell.btnDropDown.isHidden = true
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.lblDescription.isHidden = false
                cell.btnSwitch.isOn = UserLocalStore.shared.FocusingDetection
            }
            else if indexPath.row == 2 {
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
                cell.lblDisable.isHidden = false
                cell.lblDisable.text = UserLocalStore.shared.ProcessingModes

            }else if indexPath.row == 3 {
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
                cell.lblDisable.isHidden = false
                cell.lblDisable.text = UserLocalStore.shared.CameraResolution
                
            }else if indexPath.row == 4 {
                cell.btnSwitch.isHidden = false
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden = true
                cell.btnSwitch.isOn = UserLocalStore.shared.AdiustZoomLevel
            
            }else if indexPath.row == 5 {
                cell.btnSwitch.isHidden = true
                cell.lblDisable.isHidden = false
                cell.lblDisable.text = UserLocalStore.shared.ZoomLevel
                cell.btnDropDown.isHidden = false
                cell.lblDescription.isHidden = true
            }
        }else if indexPath.section == 4 {
            cell.lblDescription.isHidden = true
            if indexPath.row == 0 {
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.btnDropDown.isHidden = true
                cell.btnSwitch.isOn = UserLocalStore.shared.ManualCrop
            }else if indexPath.row == 1 {
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
            }else if indexPath.row == 2{
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
            }
            else if indexPath.row == 3 {
                cell.btnDropDown.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isOn = UserLocalStore.shared.IntegralImage
            }else if indexPath.row == 4{
                cell.btnDropDown.isHidden = true
                cell.btnSwitch.isHidden = false
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isOn = UserLocalStore.shared.HologramDetection
            }
            else if indexPath.row == 5 {
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
            }
        } else if indexPath.section == 5 {
            cell.btnSwitch.isHidden = true
            if indexPath.row == 0{
                cell.lblDescription.isHidden = false
                cell.btnDropDown.isHidden = false
                cell.lblDisable.isHidden = false
                cell.lblDisable.text = UserLocalStore.shared.DateFormat

            }else if indexPath.row == 1{
                cell.btnDropDown.isHidden = false

            }else if indexPath.row == 2 {
                cell.lblDisable.isHidden = true
                cell.btnDropDown.isHidden = false

            }
        }else {
           
            if indexPath.row == 0 {
                cell.lblDisable.isHidden = true
                cell.btnSwitch.isHidden = true
                cell.btnDropDown.isHidden = false
                cell.lblDescription.isHidden = true
            }
        }

        return cell
    }

    @objc func buttonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        print("Button tapped in Section: \(section), Row: \(row)")
        if section == 1 {
             let indexPath = IndexPath(row: row, section: section)
              if let cell = SettingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                  if indexPath.row == 0 {
                      UserLocalStore.shared.CaptureButton = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 1 {
                      UserLocalStore.shared.CameraSwitchButton = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 2 {
                      UserLocalStore.shared.HintMessages = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 3 {
                      UserLocalStore.shared.Help = cell.btnSwitch.isOn ? true : false
                  }
              }
        }else if section == 3 {
            let indexPath = IndexPath(row: row, section: section)
             if let cell = SettingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                 if indexPath.row == 0 {
                     UserLocalStore.shared.MotionDetection = cell.btnSwitch.isOn ? true : false
                 } else if indexPath.row == 1 {
                     UserLocalStore.shared.FocusingDetection = cell.btnSwitch.isOn ? true : false
                 }else if indexPath.row == 4 {
                     UserLocalStore.shared.AdiustZoomLevel = cell.btnSwitch.isOn ? true : false
                 }
             }
        }else if section == 4 {
            let indexPath = IndexPath(row: row, section: section)
             if let cell = SettingTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                    if indexPath.row == 0 {
                     UserLocalStore.shared.ManualCrop = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 3{
                        UserLocalStore.shared.IntegralImage = cell.btnSwitch.isOn ? true : false
                    }else if indexPath.row == 4 {
                        UserLocalStore.shared.HologramDetection = cell.btnSwitch.isOn ? true : false
                    }
             }
        }else{
            print("comming soon..")
        }
       
    }

    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width - 15, height: 25))
        headerView.backgroundColor = UIColor(named: "cellBackClr")
       let label = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.frame.width - 40, height: 20))
        label.font = UIFont.systemFont(ofSize: 12)
       label.text = "  " + sections[section]
       label.textColor = UIColor.gray
       
       headerView.addSubview(label)
       return headerView
   }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 35
        
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DebugSettingVC") as! DebugSettingVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1 {
                 if indexPath.row == 4 {
                backgroundPopUpVw.isHidden = false
                lang_popUpVw.isHidden = false
            }
        } else if indexPath.section == 2{
            if indexPath.row == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Timeout"
                vc.value = "20"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Timeout starting from document detection"
                vc.value = "5"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Timeout starting from document type identification"
                vc.value = "3"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 2{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProcessingModeVC") as! ProcessingModeVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 3 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraResolutionVC") as! CameraResolutionVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 5 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Zoom Level"
                vc.value = "1.0"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Minimum DPI"
                vc.placeHolderValue = "100"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Perspective angle"
                vc.placeHolderValue = "0"
                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 5 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageQualityVC") as! ImageQualityVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else if indexPath.section == 5 {
            if indexPath.row == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateFormatVC") as! DateFormatVC
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else if indexPath.row == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Document filter"
                vc.placeHolderValue = "-274257313, -2004898043"
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
                vc.commingFrom = "Custom parameters"
                vc.placeHolderValue = "{key1:Value,key2:true}"
                vc.isCustomParams = true
//                self.navigationController?.pushViewController(vc, animated: true)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else if indexPath.section == 6 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RFIDVC") as! RFIDVC
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            
        }
    }
}
