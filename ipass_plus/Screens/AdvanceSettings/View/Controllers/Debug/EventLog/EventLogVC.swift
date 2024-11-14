//
//  EventLogVC.swift
//  ipass_plus
//
//  Created by Mobile on 06/02/24.
//

import UIKit

class EventLogVC: UIViewController {

    @IBOutlet weak var noEventLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = "event_logs".localizeString(string: HomeDataManager.shared.languageCodeString)
        noEventLabel.text = "no_data_found".localizeString(string: HomeDataManager.shared.languageCodeString)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    

}
