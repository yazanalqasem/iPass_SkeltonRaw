//
//  PassiveLivenessViewController.swift
//  ipass_plus
//
//  Created by MOBILE on 11/09/24.
//

import UIKit
import Alamofire
import Amplify
import SwiftUI
import ReplayKit

extension PassiveLivenessViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithError error: Error) {
        print("Preview error: \(error.localizedDescription)")
    }
}
class PassiveLivenessViewController: UIViewController {
    
    @IBOutlet weak var matchingLivenessConfidence: UILabel!
    @IBOutlet weak var matchingConfidenceLabel: UILabel!
    @IBOutlet weak var matchingLivenessImage: UIImageView!
    @IBOutlet weak var matchingCapturedImage: UIImageView!
    var sessionIdLiveness = ""
    var passiveConfidenceValue = 0.0 
    var passiveFaceMatchingConfidenceValue = 0.0
    var passiveImageString = ""
    var capturedImage = UIImage()

    @IBOutlet weak var onlyLivenessLabel: UILabel!
    @IBOutlet weak var onlyLivenessImage: UIImageView!
    @IBOutlet weak var onlyLivenessView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        onlyLivenessView.isHidden = true
        // Do any additional setup after loading the view.
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
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
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                print("Is user signed in - \(session.isSignedIn)")
                
                print(session)
                if(session.isSignedIn == true) {
                    faceLivenessApi()
                }
                else {
                    await signIn()
                }
                
            } catch let error as AuthError {
                Loader.hide()
                print("Fetch session failed with error \(error)")
            } catch {
                Loader.hide()
                print("Unexpected error: \(error)")
            }
        }
        
    func startCamera(){
        

        
        var swiftUIView = MyView(
            dismissAction: {_ in 
                
            print("qweqweqweqweqweqw--------")

                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    print("qweqweqweqweqweqw--------+++")
                    self.dismiss(animated: true)
                    self.dismiss(animated: true)
                    self.getLiveImage() 
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
                           // self.bindOnlyLivenessData()
                            self.matchingApi(liveImage: temp["Bytes"] as? String ?? "")
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
    
    
    
    

    func convertImageToBase64(image: UIImage, maxSizeInBytes: Int = 5242880) -> String? {
        var imageData: Data?
        var isPNG = false
        
        // Check if the image is PNG or JPEG
        if let pngData = image.pngData() {
            imageData = pngData
            isPNG = true
        } else if let jpegData = image.jpegData(compressionQuality: 1.0) {
            imageData = jpegData
            isPNG = false
        }
        
        // Ensure imageData is not nil
        guard var data = imageData else {
            return nil
        }
        
        // Reduce size if the image is larger than max allowed size
        var compressionQuality: CGFloat = 1.0
        let originalDataSize = data.count
        
        // If the image size exceeds the max size, we reduce it
        if originalDataSize > maxSizeInBytes {
            if isPNG {
                // For PNG, we must resize the image since PNG doesn't support compression
                let resizedImage = resizeImage(image: image, maxSizeInBytes: maxSizeInBytes)
                data = resizedImage.pngData()!
            } else {
                // For JPEG, we can reduce the quality to bring down the size
                while data.count > maxSizeInBytes && compressionQuality > 0.1 {
                    compressionQuality -= 0.1
                    data = image.jpegData(compressionQuality: compressionQuality)!
                }
            }
        }
        
        // Convert the image data to Base64 string
        return data.base64EncodedString(options: .endLineWithLineFeed)
    }

    // Helper function to resize image based on max allowed size
    func resizeImage(image: UIImage, maxSizeInBytes: Int) -> UIImage {
        var resizedImage = image
        var imageData = resizedImage.pngData()!
        
        // Reduce size while image data exceeds max size
        while imageData.count > maxSizeInBytes {
            let newSize = CGSize(width: resizedImage.size.width * 0.9, height: resizedImage.size.height * 0.9)
            UIGraphicsBeginImageContext(newSize)
            resizedImage.draw(in: CGRect(origin: .zero, size: newSize))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            imageData = resizedImage.pngData()!
        }
        
        return resizedImage
    }


    
    func matchingApi(liveImage : String) {
        guard let apiURL = URL(string: "https://plusapi.ipass-mena.com/api/v1/aws/face/maching") else { return }
//        guard let apiURL = URL(string: "http://192.168.11.4/sumitrana/2024/phpProjects/voice-assistant/public/api/save-base64") else { return }
        
        var parameters: [String: Any] = [:]
        
        
        if let base64String = convertImageToBase64(image: capturedImage) {
            parameters["sourceImageBase64"] = base64String
           // print(base64String)
        }
       
        
//        if let imageData1 = capturedImage.pngData() {
//            let base64String1 = imageData1.base64EncodedString()
//            parameters["sourceImageBase64"] = liveImage
//        } else {
//            print("Error converting first image to Data")
//        }
    
        parameters["targetImageBase64"] = liveImage
        
       // print(liveImage)
        
        
        AF.request(apiURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(["Content-Type": "application/json"]))
            .responseJSON { response in
                
                
                print("()()()()()()(())))(()()(")
                let status = response.response?.statusCode
                print(response.result)
                
                if(status == 201) {
                    print(response)
                    
                    print(response.result)
                    
                    if let value = response.value as? [String: AnyObject] {
                        print(value)
                        print((value["data"] as! NSDictionary) ["facePercentage"] as Any)
                        
                        let anyValue: Any = (value["data"] as! NSDictionary) ["facePercentage"] as Any
                        
                        print("facePercentage",anyValue)
                        
                        self.passiveFaceMatchingConfidenceValue = anyValue as? Double ?? 0.0
                        self.bindFaceMatchingData()
                    }
                
                }
                else {
                    Loader.hide()
                    
                }
                
                
            }
    }
    
    
    func bindFaceMatchingData() {
        if let decodedData = Data(base64Encoded: passiveImageString, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            matchingLivenessImage.image = image
            matchingCapturedImage.image = capturedImage
            let confidenceStringValue =  "\(String(format: "%.2f", Double(passiveConfidenceValue)))"
            matchingConfidenceLabel.text = "Confidence level " + confidenceStringValue
            
            let matchingStringValue =  "\(String(format: "%.2f", Double(passiveFaceMatchingConfidenceValue)))"
            matchingLivenessConfidence.text = "Confidence level " + matchingStringValue
        }

    }
    
    func bindOnlyLivenessData() {
        if let decodedData = Data(base64Encoded: passiveImageString, options: .ignoreUnknownCharacters) {
            let image = UIImage(data: decodedData)
            onlyLivenessImage.image = image
            let stringValue =  "\(String(format: "%.2f", Double(passiveConfidenceValue)))"
            onlyLivenessLabel.text = "Confidence level " + stringValue
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
