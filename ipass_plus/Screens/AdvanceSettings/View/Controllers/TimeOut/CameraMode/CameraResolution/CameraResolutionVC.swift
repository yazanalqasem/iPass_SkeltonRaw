//
//  CameraResolutionVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class CameraResolutionVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var cameraTableVw: UITableView!
    var selectedSectionIndexes = IndexPath()
    var CameraModeArr = [
        "photo".localizeString(string: HomeDataManager.shared.languageCodeString),
                        "high".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "medium".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "low".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "352_288".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "640_480".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "iframe960_540".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "iframe1280_720".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "1280_720".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "1920_1080".localizeString(string: HomeDataManager.shared.languageCodeString),
                         "3840_2160".localizeString(string: HomeDataManager.shared.languageCodeString),]
    
    var dataSettingArray = [
         "Photo",
                        "High",
                         "Medium",
                         "Low",
         "352×288",
                         "640×480",
                         "iFrame960×540",
                         "iFrame1280×720",
                         "1280×720",
                         "1920×1080",
                         "3840×2160",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraTableVw.delegate = self
        cameraTableVw.dataSource = self
    
        headingLabel.text = "video_settings".localizeString(string: HomeDataManager.shared.languageCodeString)
        let cameraNib = UINib(nibName: "ProcessingModeTableCell", bundle: nil)
        self.cameraTableVw.register(cameraNib, forCellReuseIdentifier: "ProcessingModeTableCell")
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
}


extension CameraResolutionVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CameraModeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell
        let shouldShowCheckmark = CameraModeArr[indexPath.row] == UserLocalStore.shared.CameraResolution
        cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
        cell.lblTitle.text = CameraModeArr[indexPath.row]

        if indexPath.row == 0 {
               cell.bottomLine.isHidden = true
           }

           let clearView = UIView()
                  clearView.backgroundColor = UIColor.clear
                  cell.selectedBackgroundView = clearView
           
           if(CameraModeArr[indexPath.section].count - 1 == indexPath.row) {
               cell.bottomLine.isHidden = true
           }else {
               cell.bottomLine.isHidden = false
           }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProcessingModeTableCell{
            UserLocalStore.shared.CameraResolution = dataSettingArray[indexPath.row]
        }
        print(UserLocalStore.shared.CameraResolution)
        self.cameraTableVw.reloadData()
    }
}
