//
//  SoundVC.swift
//  ipass_plus
//
//  Created by Mobile on 07/02/24.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var soundTableVw: UITableView!
    var sections = ["sound_settings".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "select_sound".localizeString(string: HomeDataManager.shared.languageCodeString)]
    var soundArr = [["sound_enabled".localizeString(string: HomeDataManager.shared.languageCodeString)],
                    
                    ["beep1".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "beep2".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "beep3".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "beep4".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "beep5".localizeString(string: HomeDataManager.shared.languageCodeString)]
    
    ]
    
    var soundsName = ["beep1".localizeString(string: HomeDataManager.shared.languageCodeString),"beep2".localizeString(string: HomeDataManager.shared.languageCodeString),"beep3".localizeString(string: HomeDataManager.shared.languageCodeString),"beep4".localizeString(string: HomeDataManager.shared.languageCodeString),"beep5".localizeString(string: HomeDataManager.shared.languageCodeString),]
    var audioPlayer: AVAudioPlayer?
    var indexPathValue = IndexPath()
    var isSoundSwitchOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.soundTableVw.delegate = self
        self.soundTableVw.dataSource = self
        headingLabel.text = "sound".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        let soundNib = UINib(nibName: "AdvanceSettingTableCell", bundle: nil)
        self.soundTableVw.register(soundNib, forCellReuseIdentifier: "AdvanceSettingTableCell")
        
        let switchNib = UINib(nibName: "ProcessingModeTableCell", bundle: nil)
        self.soundTableVw.register(switchNib, forCellReuseIdentifier: "ProcessingModeTableCell")
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension SoundVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundArr[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdvanceSettingTableCell", for: indexPath) as! AdvanceSettingTableCell
            cell.lblTitle.text = soundArr[indexPath.section][indexPath.row]
            cell.btnSwitch.isHidden = false
            cell.btnSwitch.isOn = UserLocalStore.shared.SoundEnabled
             indexPathValue = IndexPath(row: indexPath.row, section: indexPath.section)
            cell.btnSwitch.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            if indexPath.row == 0 {
                cell.bottomline.isHidden = true
            }

            let clearView = UIView()
                   clearView.backgroundColor = UIColor.clear
                   cell.selectedBackgroundView = clearView
            
            if(soundArr[indexPath.section].count - 1 == indexPath.row) {
                cell.bottomline.isHidden = true
            }else {
                cell.bottomline.isHidden = false
            }

            
            
            return cell
        }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell
            if UserLocalStore.shared.SoundEnabled == false{
                if indexPath.section != 0 {
                cell.isUserInteractionEnabled = isSoundSwitchOn
                }
            }else{
                cell.isUserInteractionEnabled = true
            }

            let shouldShowCheckmark = soundsName[indexPath.row] == UserLocalStore.shared.SelectedSound
            cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
            cell.lblTitle.text = soundsName[indexPath.row]
            
            if indexPath.row == 0 {
                   cell.bottomLine.isHidden = true
               }

               let clearView = UIView()
                      clearView.backgroundColor = UIColor.clear
                      cell.selectedBackgroundView = clearView
               
               if(soundArr[indexPath.section].count - 1 == indexPath.row) {
                   cell.bottomLine.isHidden = true
               }else {
                   cell.bottomLine.isHidden = false
               }
            
            
           
            return cell
        }
    }
    
    
    @objc func buttonTapped(_ sender: UISwitch) {
        if indexPathValue.section == 0 {
            let indexPath = IndexPath(row: indexPathValue.row, section: indexPathValue.section)
            if let cell = soundTableVw.cellForRow(at: indexPath) as? AdvanceSettingTableCell {
                if indexPath.row == 0 {
                    
                    isSoundSwitchOn = sender.isOn
                    UserLocalStore.shared.SoundEnabled = cell.btnSwitch.isOn ? true : false
                    soundTableVw.reloadData()
                    
                }
            }
        }
        
    }
            func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
                headerView.backgroundColor = .clear
                
                let label = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.frame.width - 40, height: 20))
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
                if indexPath.section == 0 {
                    return UITableView.automaticDimension
                }else{
                    return 45
                }
                
            }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {

            let soundFileName = soundArr[indexPath.section][indexPath.row]

                   // Load the sound file
                   if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
                       do {
                           audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                           audioPlayer?.play()
                       } catch {
                           print("Error loading sound file: \(error.localizedDescription)")
                       }
                   }
            
            let cell = soundTableVw.cellForRow(at: indexPath) as! ProcessingModeTableCell
            
            UserLocalStore.shared.SelectedSound = cell.lblTitle.text ?? ""
            self.soundTableVw.reloadData()
        }
        print(UserLocalStore.shared.SelectedSound)
    }
}
