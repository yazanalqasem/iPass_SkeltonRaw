//
//  ProcessingModeVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class ProcessingModeVC: UIViewController {
    
    @IBOutlet weak var processingTableVw: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    var selectedSectionIndexes = IndexPath()
    var processingModeArr = ["auto".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "video_processing".localizeString(string: HomeDataManager.shared.languageCodeString),
                             "frame_processing".localizeString(string: HomeDataManager.shared.languageCodeString)]

    override func viewDidLoad() {
        super.viewDidLoad()
        processingTableVw.delegate = self
        processingTableVw.dataSource = self
        headingLabel.text = "processing_modes".localizeString(string: HomeDataManager.shared.languageCodeString)
        let processingNib = UINib(nibName: "ProcessingModeTableCell", bundle: nil)
        self.processingTableVw.register(processingNib, forCellReuseIdentifier: "ProcessingModeTableCell")
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension ProcessingModeVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processingModeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = processingTableVw.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell
        let shouldShowCheckmark = processingModeArr[indexPath.row] == UserLocalStore.shared.ProcessingModes
        
        if indexPath.row == 0 {
               cell.bottomLine.isHidden = true
           }

           let clearView = UIView()
                  clearView.backgroundColor = UIColor.clear
                  cell.selectedBackgroundView = clearView
           
           if(processingModeArr[indexPath.section].count - 1 == indexPath.row) {
               cell.bottomLine.isHidden = true
           }else {
               cell.bottomLine.isHidden = false
           }
        
        
        cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil
        
        cell.lblTitle.text = processingModeArr[indexPath.row]
        if indexPath.row == 2{
//            cell.separatorInset = .zero
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width + 1, bottom: 0, right: 0)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = processingTableVw.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell
//        if let index = processingModeArr.firstIndex(where: { $0 == UserLocalStore.shared.ProcessingModes }) {
//            print("Index of matched value: \(index)")
//            if let cell = processingTableVw.cellForRow(at: IndexPath(row: index, section: indexPath.section)) as? ProcessingModeTableCell {
//            cell.imgCheckMark.image = UIImage(named: "checks")
//            }
//        } else {
//            print("Value not found in the array")
//        }
//
//        cell.lblTitle.text = processingModeArr[indexPath.row]
//
//
//
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ProcessingModeTableCell{
            UserLocalStore.shared.ProcessingModes = cell.lblTitle.text ?? ""
            
        }
        
        print(UserLocalStore.shared.ProcessingModes) //checks
        self.processingTableVw.reloadData()
         }

    
    

    
}
