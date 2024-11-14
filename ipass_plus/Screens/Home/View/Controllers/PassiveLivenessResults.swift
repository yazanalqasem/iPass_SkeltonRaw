//
//  PassiveLivenessResults.swift
//  ipass_plus
//
//  Created by MOBILE on 23/09/24.
//

import UIKit
import Alamofire
import Amplify
import SwiftUI

class PassiveLivenessResults: UIViewController {
    
    @IBOutlet weak var statusHeading: UILabel!
    @IBOutlet weak var confidenceHeading: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var livenessPercentLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    var sessionIdLiveness = ""
    var passiveConfidenceValue = 0.0
    var passiveImageString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissBtn.setTitle("dismiss".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        headingLabel.text = "passive_liveness_title".localizeString(string: HomeDataManager.shared.languageCodeString)
        confidenceHeading.text = "liveness_confidence".localizeString(string: HomeDataManager.shared.languageCodeString)
        statusHeading.text = "liveness_status".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        img.layer.cornerRadius = 10 // Adjust the value as needed

        // Enabling masks to bounds to apply the corner radius
        img.layer.masksToBounds = true
        
        statusView.layer.cornerRadius = 5 // Adjust the value as needed

        // Enabling masks to bounds to apply the corner radius
        statusView.layer.masksToBounds = true

        if !isConnectedToNetwork(){
            self.view.makeToast("internet_error".localizeString(string: HomeDataManager.shared.languageCodeString))
        }
        else {
            Loader.show()
            Task {
                await self.fetchCurrentAuthSession()
            }
        }
    }

    @IBAction func dismissClick(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)

    }
    func faceLivenessApi() {
//        guard let apiURL = URL(string: "https://ipassplus.csdevhub.com/api/v1/aws/create/session") else { return }
        
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/ipass/liveness/session/create") else { return }
       
        var parameters: [String: Any] = [:]
//        parameters["accessKeyId"] = ""
//        parameters["secretAccessKey"] = ""
//        parameters["S3Bucket"] = "facelivenessimage"
//        parameters["S3KeyPrefix"] = "livenessimages"
        
       
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                //    switch response.result {
               
                let status = response.response?.statusCode
                print(response)
                
                
                if(status == 200) {
                    print(response)
                    
                    print(response.result)
                    
                    if let value = response.value as? [String: AnyObject] {
                        print(value)
                        print("-*-*-*-*-**-*-*--*");
                        print(value["sessionId"]! as Any)
                        self.sessionIdLiveness = value["sessionId"] as! String
                        
                        print(self.sessionIdLiveness)
                        Loader.hide()
                        self.startCamera()
                       
                    }
                    else {
                        Loader.hide()
                        print("Print")
                    }
                }
                
                else {
                    Loader.hide()
                    // Show Alert erro
                }
            }
    }
    
        func signIn() async {
            do {
                let signInResult = try await Amplify.Auth.signIn(
                    username: "testuser",
                    password: "Apple@123"
                    )
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                    await fetchCurrentAuthSession()
                }
            } catch let error as AuthError {
                Loader.hide()
                print("Sign in failed \(error)")
            } catch {
                Loader.hide()
                print("Unexpected error: \(error)")
            }
        }
        
    
        func fetchCurrentAuthSession() async {
            
            faceLivenessApi()
            
//            do {
//                let session = try await Amplify.Auth.fetchAuthSession()
//                print("Is user signed in - \(session.isSignedIn)")
//                
//                print(session)
//                if(session.isSignedIn == true) {
//                    faceLivenessApi()
//                }
//                else {
//                    await signIn()
//                }
//                
//            } catch let error as AuthError {
//                Loader.hide()
//                print("Fetch session failed with error \(error)")
//            } catch {
//                Loader.hide()
//                print("Unexpected error: \(error)")
//            }
        }
        
    func startCamera(){
        
      
        
        var swiftUIView = MyView(
            dismissAction: {(isDismissed: Bool?) in
                
            print("qweqweqweqweqweqw--------")
                print(isDismissed as Any)

                if let isDismissed = isDismissed {
                       print("Action dismissed: \(isDismissed)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        print("qweqweqweqweqweqw--------+++")
                        self.dismiss(animated: true)
                        self.dismiss(animated: true)
                        self.getLiveImage()
                    }
                   } else {
                       print("No value passed for dismissal")
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                           print("qweqweqweqweqweqw--------+++")
                           self.dismiss(animated: true)
                           self.dismiss(animated: true)
                           _ = self.navigationController?.popViewController(animated: false)
                       }
                      
                   }
             
        })
        

        swiftUIView.sessoinIdValue = sessionIdLiveness
    let hostingController = UIHostingController(rootView: swiftUIView)
   // navigationController?.pushViewController(hostingController, animated: true)
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: true)
    }
    
    func getLiveImage() {
        DispatchQueue.main.async {
            Loader.show()
        }
        
        
        
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/ipass/session/result?sessionId="+sessionIdLiveness) else { return }
        
        AF.request(apiURL, method: .get,encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                
                let status = response.response?.statusCode
                
                
                if(status == 200) {
                    
                    print("{{{}{}{}}{{}{}{}{}}{}{")
                    print(response.value as Any)
                    
                    var livenessData = NSDictionary()
                    livenessData = response.value as! NSDictionary
                    
                    print((livenessData["response"] as! NSDictionary)  ["Status"] ?? "")
                    
                    var statusStr = ""
                    statusStr = (livenessData["response"] as! NSDictionary)  ["Status"] as! String
                    
                    
                    print("7887878778787888778++++++++++")
                    print(statusStr)
                    
                    if(statusStr == "SUCCEEDED") || statusStr == "Success" || statusStr == "Warning" {
                        Loader.hide()
                        var temp = NSDictionary()
                        
                        
                        temp = (livenessData["response"] as! NSDictionary)  ["ReferenceImage"] as? NSDictionary ?? NSDictionary()
                        
                        print("Data-=-=-=-=-=",temp)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self.passiveConfidenceValue = (livenessData["response"] as! NSDictionary)  ["Confidence"] as? Double ?? 0.0
                            
                            self.passiveImageString = temp["Bytes"] as? String ?? ""
                            self.bindOnlyLivenessData()
                        }
                    }
                    else {
                        // SHOW ERRRO
                        Loader.hide()
                    }
                    
                    
                    
                    
                    
                }
                else {
                    Loader.hide()
                }
                
            }
    }
    
    func bindOnlyLivenessData() {
        if let decodedData = Data(base64Encoded: passiveImageString, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            img.image = image
            let statusString = getStatusAccordingToValue(for: passiveConfidenceValue)
            let stringValue =  "\(String(format: "%.2f", Double(passiveConfidenceValue)))%"
            livenessPercentLabel.text =  stringValue
            
            statusLabel.textColor = .white
            if statusString == "passed".localizeString(string: HomeDataManager.shared.languageCodeString) {
                statusView.backgroundColor = .green
                livenessPercentLabel.textColor = .green
            } else if statusString == "warning".localizeString(string: HomeDataManager.shared.languageCodeString) {
                statusView.backgroundColor = .orange
                livenessPercentLabel.textColor = .orange
            } else {
                statusView.backgroundColor = .red
                livenessPercentLabel.textColor = .red
            }
            
            statusLabel.text = statusString
        }

    }
    
    
    func getStatusAccordingToValue(for value: Double) -> String {
        if value > 80 {
            return "passed".localizeString(string: HomeDataManager.shared.languageCodeString)
        } else if value > 50 {
            return "warning".localizeString(string: HomeDataManager.shared.languageCodeString)
        } else {
            return "rejected".localizeString(string: HomeDataManager.shared.languageCodeString)
        }
    }

}
