//
//  SettingViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 31/01/24.
//

import UIKit
import Cosmos
import SafariServices
import StoreKit


class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: IBoutlets
    @IBOutlet weak var ratingVw: CosmosView!
    @IBOutlet weak var popUpBackVw: UIView!
    @IBOutlet weak var mainPopUpView: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var settingTV: UITableView!
    
    @IBOutlet weak var headingLabel: UILabel!
    //MARK: Properties
    
    let sections = ["general".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "get_in_touch".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "learn_more".localizeString(string: HomeDataManager.shared.languageCodeString),
                    "legal".localizeString(string: HomeDataManager.shared.languageCodeString)]
       let data = [
           ["settings".localizeString(string: HomeDataManager.shared.languageCodeString),
            "verification_statuses".localizeString(string: HomeDataManager.shared.languageCodeString),
            "about_app".localizeString(string: HomeDataManager.shared.languageCodeString),
            "review_the_app".localizeString(string: HomeDataManager.shared.languageCodeString),
            "share_the_app".localizeString(string: HomeDataManager.shared.languageCodeString)],
           ["contact_us".localizeString(string: HomeDataManager.shared.languageCodeString),
            "help_center".localizeString(string: HomeDataManager.shared.languageCodeString)],
           ["visit_website".localizeString(string: HomeDataManager.shared.languageCodeString),
            "view_on_store".localizeString(string: HomeDataManager.shared.languageCodeString)],
           ["privacy_policy".localizeString(string: HomeDataManager.shared.languageCodeString)]
       ]
    var OthersImgs = [[UIImage(named: "setting"),UIImage(named: "verification"),UIImage(named: "about_us"),UIImage(named: "review"),UIImage(named: "share")],[UIImage(named: "contact"),UIImage(named: "help")],[UIImage(named: "visit"),UIImage(named: "app-store")],[UIImage(named: "pp")]]

    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadInitData()
        btnCancel.layer.cornerRadius = 22.5
        btnSubmit.layer.cornerRadius = 22.5
        mainPopUpView.layer.cornerRadius = 20
        popUpBackVw.isHidden = true
        mainPopUpView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadInitData(){
        settingTV.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        settingTV.estimatedRowHeight = UITableView.automaticDimension
    }
    
    //MARK: Button Actions
    
    @IBAction func btnHidePopUpVw(_ sender: Any) {
        popUpBackVw.isHidden = true
        mainPopUpView.isHidden = true
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func actionSubmitRating(_ sender: Any) {
        popUpBackVw.isHidden = true
        mainPopUpView.isHidden = true
    }
    
    
    
    
    @IBAction func actionCancelRating(_ sender: Any) {
        popUpBackVw.isHidden = true
        mainPopUpView.isHidden = true
    }
    
    //MARK: UItableView Delegate and Datasource Method

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
      // return UITableView.automaticDimension
    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
            return sections.count
        }

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data[section].count
        }

         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             var cell: SettingCell! = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
                    if cell == nil {
                        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
                        cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
                    }
             if indexPath.row == 0 {
                 cell.bottomLine.isHidden = true
             }

             let clearView = UIView()
                    clearView.backgroundColor = UIColor.clear
                    cell.selectedBackgroundView = clearView

             cell.txtLabel.text =  data[indexPath.section][indexPath.row]
             cell.leftImg.image = OthersImgs[indexPath.section][indexPath.row]
             if(data[indexPath.section].count - 1 == indexPath.row) {
                 cell.bottomLine.isHidden = true
                 cell.holderView.clipsToBounds = true
                 cell.holderView.layer.cornerRadius = 10
                 cell.holderView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
             }
             else {
                 cell.bottomLine.isHidden = false
             }
             
             if(indexPath.row == 0) {
                 cell.holderView.clipsToBounds = true
                 cell.holderView.layer.cornerRadius = 10
                 cell.holderView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
             }
            
             
             
                    return cell
        }

         func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
             headerView.backgroundColor = self.view.backgroundColor

            let label = UILabel(frame: CGRect(x: 15, y: 5, width: tableView.frame.width - 30, height: 20))
             label.font = UIFont.systemFont(ofSize: 14)
            label.text = "  " + sections[section]
            label.textColor = UIColor.lightGray
            
            headerView.addSubview(label)
            return headerView
        }
    
         func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 35
        }
    
    
    func requestReview() {
            if #available(iOS 14.0, *) {
                if let windowScene = view.window?.windowScene {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Add delay to avoid calling it too early
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                } else {
                    // Handle the case where windowScene is nil
                    print("windowScene is nil")
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    SKStoreReviewController.requestReview()
                }
            }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OtherSettingVC") as! OtherSettingVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerificationStatusVC") as! VerificationStatusVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            }else if indexPath.row == 2 {
             
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutAppVC") as! AboutAppVC
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            } else if indexPath.row == 3 {
//                popUpBackVw.isHidden = false
//                mainPopUpView.isHidden = false
                
                requestReview()
            }
            else{
                
                let textToShare = "iPass Mena"

                    if let myWebsite = NSURL(string: "https://apps.apple.com/us/app/ipass-mena/id6479610756") {
                        let objectsToShare: [Any] = [textToShare, myWebsite]
                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        self.present(activityVC, animated: true, completion: nil)
                    }
            }
        }else if indexPath.section == 1 {
            openURLInSafari(urlString: "https://ipass-mena.com/contact/")

            
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                openURLInSafari(urlString: "https://ipass-mena.com")

            }else{
                if let url = URL(string: "https://apps.apple.com/us/app/ipass-mena/id6479610756")
                {
                           if #available(iOS 10.0, *) {
                              UIApplication.shared.open(url, options: [:], completionHandler: nil)
                           }
                           else {
                                 if UIApplication.shared.canOpenURL(url as URL) {
                                    UIApplication.shared.openURL(url as URL)
                                }
                           }
                }
            }
        }else{
            openURLInSafari(urlString: "https://ipass-mena.com")
        }

        

    }
    
    
    func openURLInSafari(urlString: String) {
          if let url = URL(string: urlString) {
              let safariViewController = SFSafariViewController(url: url)
              present(safariViewController, animated: true, completion: nil)
          }
      }
    
}
