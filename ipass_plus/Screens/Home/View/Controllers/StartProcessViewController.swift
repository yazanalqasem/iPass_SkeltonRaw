//
//  StartProcessViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 31/01/24.
//

import UIKit
import DocumentReader
import Alamofire
import Amplify
import SwiftUI
import PKHUD
import Reachability
import Toast_Swift

class StartProcessViewController: UIViewController {
    //MARK: IBoutlets
    @IBOutlet weak var goBtn: UIButton!
    
    @IBOutlet weak var poweredBy: UILabel!
    @IBOutlet weak var cameraAtEye: UILabel!
    @IBOutlet weak var noAccessories: UILabel!
    @IBOutlet weak var good_illumination: UILabel!
    @IBOutlet weak var get_ready: UILabel!
    @IBOutlet weak var selfie_time: UILabel!
    var results: DocumentReaderResults!
    
    var sessionIdValue = ""
    
    //MARK: ViewLife Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUiUpdated()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // Lock orientation to portrait
           
       }
    
    
    
    
    
   func makeUiUpdated() {
        
        goBtn.layer.cornerRadius = 10
        goBtn.layer.borderWidth = 1
        goBtn.layer.borderColor = UIColor.clear.cgColor
       selfie_time.text = "selfie_time".localizeString(string: HomeDataManager.shared.languageCodeString)
       get_ready.text = "get_ready".localizeString(string: HomeDataManager.shared.languageCodeString)
       good_illumination.text = "good_illumination".localizeString(string: HomeDataManager.shared.languageCodeString)
       noAccessories.text = "no_accessories".localizeString(string: HomeDataManager.shared.languageCodeString)
       cameraAtEye.text = "camera_at_eye".localizeString(string: HomeDataManager.shared.languageCodeString)
       poweredBy.text = "powered_by".localizeString(string: HomeDataManager.shared.languageCodeString)
       goBtn.setTitle("go".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
    }
    
    //MARK: Button Action
    @IBAction func goClick(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FaceScanningVC") as! FaceScanningVC
//        vc.results = results
//        self.navigationController?.pushViewController(vc, animated: true)
       
       
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
                        self.sessionIdValue = value["sessionId"] as! String
                        
                        print(self.sessionIdValue)
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
            
//            var dataDi  = [String : Any]()
//            dataDi["sessionIdValue"] = sessionIdValue
//            dataDi["results"] = results
//            NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: dataDi)
//           
         

            
            
            var swiftUIView = MyView(
                dismissAction: {_ in 
                    
                print("qweqweqweqweqweqw--------")
//               let vc = UserInfoViewControllerRepresentable(results: self.results, sessionId: self.sessionIdValue, faceLiveness: true )
//                vc.makeUIViewController(context: <#T##UserInfoViewControllerRepresentable.Context#>)
                      
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        print("qweqweqweqweqweqw--------+++")
                        self.dismiss(animated: true)
                        self.dismiss(animated: true)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
                        viewController.results = self.results
                        viewController.getUserSessionId = self.sessionIdValue
                        viewController.faceLiveness = true
                            viewController.modalPresentationStyle = .overFullScreen
                                self.present(viewController, animated: true)
                            
                    }
                   
                    
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let viewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
//                         
//                        viewController.modalPresentationStyle = .fullScreen
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                        self.dismiss(animated: true)
//                            self.present(viewController, animated: true)
//                        }
                    
                
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let viewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
//                    viewController.results = self.results
//                    viewController.getUserSessionId = self.sessionIdValue
////                    viewController.faceLiveness = true
//                    //viewController.modalPresentationStyle = .fullScreen
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                        self.dismiss(animated: true)
//                       // self.present(viewController, animated: true)
//                    }
                    
            
            })
            

            swiftUIView.sessoinIdValue = self.sessionIdValue
            swiftUIView.results = results
        let hostingController = UIHostingController(rootView: swiftUIView)
       // navigationController?.pushViewController(hostingController, animated: true)
            hostingController.modalPresentationStyle = .fullScreen
            self.present(hostingController, animated: true)
           
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                self.dismiss(animated: true)
//            }
            
          
            
        }

        
        
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true)
       // self.navigationController?.popViewController(animated: true)
    }
    
  
}
