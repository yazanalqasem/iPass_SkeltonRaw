//
//  DateFormatVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class DateFormatVC: UIViewController {
    
    
    @IBOutlet weak var dateTableVw: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    
    
    var dataFormatArr = ["default".localizeString(string: HomeDataManager.shared.languageCodeString),
                       "dd/mm/yyyy".localizeString(string: HomeDataManager.shared.languageCodeString),
                       "mm/dd/yyyy".localizeString(string: HomeDataManager.shared.languageCodeString),
                       "dd-mm-yyyy".localizeString(string: HomeDataManager.shared.languageCodeString),
                       "mm-dd-yyyy".localizeString(string: HomeDataManager.shared.languageCodeString),
                       "dd/mm/yy".localizeString(string: HomeDataManager.shared.languageCodeString),
    ]
    
    var dataFormatValues = ["Default",
                         "dd/mm/yyyy",
                         "mm/dd/yyyy",
                         "dd-mm-yyyy",
                         "mm-dd-yyyy",
                         "dd/mm/yy"]

    override func viewDidLoad() {
        super.viewDidLoad()

        dateTableVw.delegate = self
        dateTableVw.dataSource = self
        headingLabel.text = "date_format".localizeString(string: HomeDataManager.shared.languageCodeString)
        let dateNib = UINib(nibName: "ProcessingModeTableCell", bundle: nil)
        self.dateTableVw.register(dateNib, forCellReuseIdentifier: "ProcessingModeTableCell")
    }
    

    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension DateFormatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFormatArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProcessingModeTableCell", for: indexPath) as! ProcessingModeTableCell
        let shouldShowCheckmark = dataFormatArr[indexPath.row] == UserLocalStore.shared.DateFormat
        cell.imgCheckMark.image = shouldShowCheckmark ? UIImage(named: "checks") : nil

        cell.lblTitle.text = dataFormatArr[indexPath.row]
      
        if indexPath.row == 0 {
                  cell.bottomLine.isHidden = true
              }

              let clearView = UIView()
                     clearView.backgroundColor = UIColor.clear
                     cell.selectedBackgroundView = clearView
              
              if(dataFormatArr[indexPath.section].count - 1 == indexPath.row) {
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
        let cell = tableView.cellForRow(at: indexPath) as! ProcessingModeTableCell
        UserLocalStore.shared.DateFormat = dataFormatValues[indexPath.row]
        self.dateTableVw.reloadData()
    }
  
}
