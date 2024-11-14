//
//  SplashViewController.swift
//  ipass_plus
//
//  Created by Mobile on 07/03/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.0) {
            
            if( UserLocalStore.shared.TutorialViewed == true) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            

            
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Lock orientation to portrait
           UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
           UINavigationController.attemptRotationToDeviceOrientation()
       }

}
