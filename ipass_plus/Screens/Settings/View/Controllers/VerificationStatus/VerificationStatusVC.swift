//
//  VerificationStatusVC.swift
//  ipass_plus
//
//  Created by Mobile on 05/02/24.
//

import UIKit

class VerificationStatusVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var statusTableVw: UITableView!
    //MARK: Properties
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var failedLabel: UILabel!
    var statusArr = ["id_document_verification".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "id_document_expiration".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "face_comparison".localizeString(string: HomeDataManager.shared.languageCodeString),
                     "liveness_check_str".localizeString(string: HomeDataManager.shared.languageCodeString)]
    
    var sucessImgArr = [UIImage(named: "status_ok"), UIImage(named: "ac"),UIImage(named: "imgMatch"), UIImage(named: "imgiveness")]
    
    var faildImgArr = [UIImage(named: "warning"), UIImage(named: "not_valid_data"),UIImage(named: "crs"), UIImage(named: "cross")]
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statusTableVw.delegate = self
        statusTableVw.dataSource = self
       
        headingLabel.text = "verification_statuses".localizeString(string: HomeDataManager.shared.languageCodeString)
        successLabel.text = "success".localizeString(string: HomeDataManager.shared.languageCodeString)
        failedLabel.text = "failed".localizeString(string: HomeDataManager.shared.languageCodeString)

        let statusNib = UINib(nibName: "VerificationStatusTableCell", bundle: nil)
        self.statusTableVw.register(statusNib, forCellReuseIdentifier: "VerificationStatusTableCell")
    }
    
    //MARK: Button Back
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
//MARK: Table View Delegate and Datasource Method

extension VerificationStatusVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerificationStatusTableCell", for: indexPath) as! VerificationStatusTableCell
        cell.lblTitle.text = statusArr[indexPath.row]
        cell.img1.image = sucessImgArr[indexPath.row]
        cell.img2.image = faildImgArr[indexPath.row]
        if indexPath.row == 1 {
            cell.img1.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
