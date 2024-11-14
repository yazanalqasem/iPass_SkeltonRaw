//
//  AboutAppVC.swift
//  ipass_plus
//
//  Created by Mobile on 07/02/24.
//

import UIKit

class AboutAppVC: UIViewController {
    
    
    @IBOutlet weak var textViews: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textViews.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30)
        
//        let texts =  """
//       This application allows you to read and verify data from identification documents (passports, ID cards, driver's licenses, residence permits, visas, boarding passes, etc.) and bank cards.
// 
//        Position a document fully inside the frame, and it will be automatically detected, cropped and recognized. The document type will be detected automatically. The MRZ, visual zone and barcodes will be recognized and parsed into text fields. Graphic fields will be automatically cropped.
// 
//        Data verification is performed after reading, where applicable, and overall verification status is displayed.
// 
//        All processing is performed completely offline, no data leaves your device.
// 
//        Please contact us if you have any questions, issues or suggestions.
// """
        
        
        let texts =  "" + "about_us".localizeString(string: HomeDataManager.shared.languageCodeString) +
        ""
                            
        textViews.text  = texts
    }
    
    
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnOpenFacebook(_ sender: Any) {
        let pageName = ""
              if let facebookURL = URL(string: "fb://profile/\(pageName)") {
                  // Open the Facebook app
                  if UIApplication.shared.canOpenURL(facebookURL) {
                      UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
                  } else {
                      // If the Facebook app is not installed, open the Facebook page in a web browser
                      let webURL = URL(string: "https://www.facebook.com/\(pageName)")
                      UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
                  }
              }
    }
    
    
    @IBAction func btnOpenLinkdin(_ sender: Any) {
        let linkedInProfileUsername = ""  // Replace with the actual username or profile ID
              
              if let linkedInURL = URL(string: "linkedin://profile/\(linkedInProfileUsername)") {
                  // Open the LinkedIn app
                  if UIApplication.shared.canOpenURL(linkedInURL) {
                      UIApplication.shared.open(linkedInURL, options: [:], completionHandler: nil)
                  } else {
                      // If the LinkedIn app is not installed, open the LinkedIn profile in a web browser
                      let webURL = URL(string: "https://www.linkedin.com/in/\(linkedInProfileUsername)")
                      UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
                  }
              }
    }
    
    
    
    @IBAction func btnOpenTwitter(_ sender: Any) {
        let twitterUsername = ""  // Replace with the actual Twitter username

              if let twitterURL = URL(string: "twitter://user?screen_name=\(twitterUsername)") {
                  // Open the Twitter app
                  if UIApplication.shared.canOpenURL(twitterURL) {
                      UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
                  } else {
                      // If the Twitter app is not installed, open the Twitter profile in a web browser
                      let webURL = URL(string: "https://twitter.com/\(twitterUsername)")
                      UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
                  }
              }
    }
    
    
    
    @IBAction func btnOpenGitHub(_ sender: Any) {
        let githubUsername = ""  // Replace with the actual GitHub username

              // Open the GitHub profile in a web browser
              let webURL = URL(string: "https://github.com/\(githubUsername)")
              UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
    }
    

}
