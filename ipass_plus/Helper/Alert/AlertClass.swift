//
//  AlertClass.swift
//  ipass_plus
//
//  Created by MOBILE on 20/02/24.
//

import Foundation
import UIKit


class Alert : NSObject {


    static var shared = Alert()
    func displayMyAlertMessage(title: String, message : String, actionTitle : String, actions: @escaping (() ->  Void)) {
        let myAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: { (action: UIAlertAction) -> Void in
            actions()
        })
        myAlert.addAction(alertAction)
        if let vc = UIApplication.shared.windows.first?.rootViewController as UIViewController? {
            vc.present(myAlert, animated: true, completion: nil)
        }
    }
}
