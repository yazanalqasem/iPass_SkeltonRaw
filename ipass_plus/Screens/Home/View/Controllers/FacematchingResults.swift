//
//  FacematchingResults.swift
//  ipass_plus
//
//  Created by MOBILE on 23/09/24.
//

import UIKit
import Alamofire
import Amplify
import SwiftUI

class FacematchingResults: UIViewController {
    
    @IBOutlet weak var confidenceHeading: UILabel!
    @IBOutlet weak var statusHeading: UILabel!
    @IBOutlet weak var matchingHeading: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    var capturedImage = UIImage()

    @IBOutlet weak var dismissBtn: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var facematchingLevel: UILabel!
    @IBOutlet weak var livenessConfidenceLavel: UILabel!
    @IBOutlet weak var livenessImageView: UIImageView!
    @IBOutlet weak var capturedImageView: UIImageView!
    
    var sessionIdLiveness = ""
    var passiveConfidenceValue = 0.0
    var passiveImageString = ""
    var faceMatchingValue = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissBtn.setTitle("dismiss".localizeString(string: HomeDataManager.shared.languageCodeString), for: .normal)
        headingLabel.text = "face_matching_title".localizeString(string: HomeDataManager.shared.languageCodeString)
        confidenceHeading.text = "liveness_confidence".localizeString(string: HomeDataManager.shared.languageCodeString)
        matchingHeading.text = "face_matching_title".localizeString(string: HomeDataManager.shared.languageCodeString)
        statusHeading.text = "liveness_status".localizeString(string: HomeDataManager.shared.languageCodeString)
        
        
        capturedImageView.layer.cornerRadius = 10
        capturedImageView.layer.masksToBounds = true
        livenessImageView.layer.cornerRadius = 10
        livenessImageView.layer.masksToBounds = true
        statusView.layer.cornerRadius = 5
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
//            dismissAction: {_ in 
//                
//            print("qweqweqweqweqweqw--------")
//
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
//                    print("qweqweqweqweqweqw--------+++")
//                    self.dismiss(animated: true)
//                    self.dismiss(animated: true)
//                    self.getLiveImage()
//                }
//        })
            
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
                       
                        var temp = NSDictionary()
                        
                        
                        temp = (livenessData["response"] as! NSDictionary)  ["ReferenceImage"] as? NSDictionary ?? NSDictionary()
                        
                        print("Data-=-=-=-=-=",temp)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            
                            self.passiveConfidenceValue = (livenessData["response"] as! NSDictionary)  ["Confidence"] as? Double ?? 0.0
                            
                            self.passiveImageString = temp["Bytes"] as? String ?? ""
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
                    Loader.hide()
                    
                    print(response.result)
                    
                    if let value = response.value as? [String: AnyObject] {
                        print(value)
                        print((value["data"] as! NSDictionary) ["facePercentage"] as Any)
                        
                        let anyValue: Any = (value["data"] as! NSDictionary) ["facePercentage"] as Any
                        
                        print("facePercentage",anyValue)
                        
                        self.faceMatchingValue = anyValue as? Double ?? 0.0
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
            livenessImageView.image = image
            capturedImageView.image = capturedImage
            let statusString = getStatusAccordingToValue(for: passiveConfidenceValue)
            let stringValue =  "\(String(format: "%.2f", Double(passiveConfidenceValue)))%"
            let faceMatchingStringValue =  "\(String(format: "%.2f", Double(faceMatchingValue)))%"
            livenessConfidenceLavel.text =  stringValue
            facematchingLevel.text =  faceMatchingStringValue
            
            statusLabel.textColor = .white
            if statusString == "passed".localizeString(string: HomeDataManager.shared.languageCodeString) {
                statusView.backgroundColor = .green
                livenessConfidenceLavel.textColor = .green
            } else if statusString == "warning".localizeString(string: HomeDataManager.shared.languageCodeString) {
                statusView.backgroundColor = .orange
                livenessConfidenceLavel.textColor = .orange
            } else {
                statusView.backgroundColor = .red
                livenessConfidenceLavel.textColor = .red
            }
            
            statusLabel.text = statusString
            
            let faceMatchingStatusString = getStatusAccordingToValue(for: faceMatchingValue)
            
            if faceMatchingStatusString == "passed".localizeString(string: HomeDataManager.shared.languageCodeString) {
                facematchingLevel.textColor = .green
                
            } else if faceMatchingStatusString == "warning".localizeString(string: HomeDataManager.shared.languageCodeString) {
                facematchingLevel.textColor = .orange
            } else {
                facematchingLevel.textColor = .red
            }
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
