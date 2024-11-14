//
//  ImageQualityVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class ImageQualityVC: UIViewController {
    
    
    @IBOutlet weak var imgeQtyTableVw: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    var imgQualityArr = ["glares".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "focus".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "color".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "dpi_threshold".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "angle_threshold".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "document_position".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = "image_quality".localizeString(string: HomeDataManager.shared.languageCodeString)
        imgeQtyTableVw.delegate = self
        imgeQtyTableVw.dataSource = self
        
        let imgNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.imgeQtyTableVw.register(imgNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
   
    }
    

    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ImageQualityVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgQualityArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingTableCell", for: indexPath) as! AdvanceSettingTableCell
        cell.lblTitle.text = imgQualityArr[indexPath.row]
        let tagValue = indexPath.section * 1000 + indexPath.row
        cell.btnSwitch.tag = tagValue
        cell.btnSwitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        if indexPath.row == 0 {
            cell.bottomline.isHidden = true
        }

        let clearView = UIView()
               clearView.backgroundColor = UIColor.clear
               cell.selectedBackgroundView = clearView
        
        if(imgQualityArr[indexPath.section].count - 1 == indexPath.row) {
            cell.bottomline.isHidden = true
        }else {
            cell.bottomline.isHidden = false
        }

        
        
        if indexPath.row == 0 {
            cell.btnSwitch.isHidden = false
            cell.btnSwitch.isOn = UserLocalStore.shared.ImgGlares
        }else if indexPath.row == 1 {
            cell.btnSwitch.isHidden = false
            cell.btnSwitch.isOn = UserLocalStore.shared.ImgFocus
        }
        else if indexPath.row == 2 {
            cell.btnSwitch.isHidden = false
            cell.btnSwitch.isOn = UserLocalStore.shared.ImgColor
        }
        else{
            cell.btnSwitch.isHidden = true
            cell.btnDropDown.isHidden = false
            if indexPath.row == 5 {
                cell.lblDescription.isHidden = false
                cell.lblDescription.text = "minimum_indent_from".localizeString(string: HomeDataManager.shared.languageCodeString)
            }
        }

        return cell
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        print("Button tapped in Section: \(section), Row: \(row)")
        if section == 0 {
             let indexPath = IndexPath(row: row, section: section)
              if let cell = imgeQtyTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                  if indexPath.row == 0 {
                      UserLocalStore.shared.ImgGlares = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 1 {
                      UserLocalStore.shared.ImgFocus = cell.btnSwitch.isOn ? true : false
                  }else if indexPath.row == 2 {
                      UserLocalStore.shared.ImgColor = cell.btnSwitch.isOn ? true : false
                  }
              }
        }else{
            print("comming soon..")
        }
       
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
            vc.commingFrom = "DPI threshold"
            vc.placeHolderValue = "150"
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 4 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
            vc.commingFrom = "Angle threshold"
            vc.placeHolderValue = "5"
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 5 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeOutVC") as! TimeOutVC
            vc.commingFrom = "Document position: Indent"
            vc.placeHolderValue = "5"
//            self.navigationController?.pushViewController(vc, animated: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            
        }
    }
    
}
