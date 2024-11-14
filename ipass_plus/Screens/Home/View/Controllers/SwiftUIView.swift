//
//  SwiftUIView.swift
//  ipass_plus
//
//  Created by MOBILE on 26/02/24.
//

import SwiftUI
import FaceLiveness
import DocumentReader
import UIKit

//struct MyView: View {
//    
//    var sessoinIdValue = ""
//    var results: DocumentReaderResults!
//    var isScanningTypeIndex:Int?
//    
//  @State private var isPresentingLiveness = true
//    
//
//  var body: some View {
//    FaceLivenessDetectorView(
//      sessionID: sessoinIdValue,
//      region: "us-east-1",
//      disableStartView: true,
//      isPresented: $isPresentingLiveness,
//      onCompletion: { result in
//          
//          print("##$#$#$#$$##$$##$")
//          print(result)
//          
//        switch result {
//           
//        case .success:
//          // ...
//            
//            print("-------------")
//            
//            DispatchQueue.main.async {
//                
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
//                
//                rootViewController.results = results
////                rootViewController.isScanningTypeIndex = isScanningTypeIndex
//                rootViewController.getUserSessionId = sessoinIdValue
//                rootViewController.faceLiveness = true
//                           if let window = UIApplication.shared.windows.first {
//                               window.rootViewController = rootViewController
//                               window.endEditing(true)
//                               window.makeKeyAndVisible()
//                           }
//                
//                
//            }
//            
//         
//            
//            print(result)
//            break
//        case .failure(_):
//            print("-------------++++++++")
//           
//            
//            DispatchQueue.main.async {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//                let rootViewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
//                rootViewController.results = results
//                rootViewController.getUserSessionId = sessoinIdValue
//                rootViewController.faceLiveness = false
//                           if let window = UIApplication.shared.windows.first {
//                               window.rootViewController = rootViewController
//                               window.endEditing(true)
//                               window.makeKeyAndVisible()
//                           }
//            }
//            
//     
//           
//            break
//        default:
//          // ...
//            print("-------------++++++++-----------")
//            break
//        }
//      }
//    )
//  }
//}


//
//struct MyView: View {
//    
//    var dismissAction: ((Bool?) -> Void)?
//    
//    @State private var isPresentingLiveness = true
//    @State private var isPresentingUserInfo = false
//    @State private var shouldDismiss = false
//    // Change this to a @State property
//    @State private var faceLivenessStringValue = ""
//    var sessoinIdValue = ""
//    var results: DocumentReaderResults!
//    var isScanningTypeIndex:Int?
//
//    var body: some View {
//        
//            FaceLivenessDetectorView(
//                sessionID: sessoinIdValue,
//                region: "us-east-1",
//                disableStartView: true,
//                isPresented: $isPresentingLiveness,
//                onCompletion: { result in
//                   
//
//                    switch result {
//                    case .success:
//                        print("Success")
//                        DispatchQueue.main.async {
//                            self.faceLivenessStringValue = "1" // Now you can modify this
//                            UserDefaults.standard.set(faceLivenessStringValue, forKey: "faceLiveness")
//                            self.isPresentingUserInfo = true
//                            dismissAction?(true)
//                        }
//                    case .failure(_):
//                        print("Failure")
//                        DispatchQueue.main.async {
//                            self.faceLivenessStringValue = "0" // Now you can modify this
//                            UserDefaults.standard.set(faceLivenessStringValue, forKey: "isFaceLiveness")
//                            self.isPresentingUserInfo = true
//                            dismissAction?(nil)
//                           
//                        }
//                   
//                    }
//                    
//                }
//            )
//    }
//}


struct MyView: View {
    
    var dismissAction: ((Bool?) -> Void)?
    
    @State private var isPresentingLiveness = true
    @State private var isPresentingUserInfo = false
    @State private var shouldDismiss = false
    @State private var faceLivenessStringValue = ""
    var sessoinIdValue = ""
    var results: DocumentReaderResults!
    var isScanningTypeIndex: Int?
    
    var body: some View {
        ZStack {
            FaceLivenessDetectorView(
                sessionID: sessoinIdValue,
                region: "us-east-1",
                disableStartView: true,
                isPresented: $isPresentingLiveness,
                onCompletion: { result in
                    switch result {
                    case .success:
                        print("Success")
                        DispatchQueue.main.async {
                            self.faceLivenessStringValue = "1"
                            UserDefaults.standard.set(faceLivenessStringValue, forKey: "faceLiveness")
                            self.isPresentingUserInfo = true
                            dismissAction?(true)
                        }
                    case .failure(_):
                        print("Failure")
                        DispatchQueue.main.async {
                            self.faceLivenessStringValue = "0"
                            UserDefaults.standard.set(faceLivenessStringValue, forKey: "isFaceLiveness")
                            self.isPresentingUserInfo = true
                            dismissAction?(nil)
                        }
                    }
                }
            )
            // Overlay a transparent Rectangle to disable tap gestures
            Rectangle()
                .foregroundColor(Color.clear)
                .contentShape(Rectangle()) // Define tap area
                .disabled(true) // Disable interaction
        }
    }
}




//struct MyView: View {
//    @State private var isPresentingLiveness = true
//    @State private var isPresentingUserInfo = false
//
//    var faceLivenessStringValue = ""
//    var sessoinIdValue = ""
//    var results: DocumentReaderResults!
//    var isScanningTypeIndex:Int?
//
//    var body: some View {
//        FaceLivenessDetectorView(
//            sessionID: sessoinIdValue,
//            region: "us-east-1",
//            disableStartView: true,
//            isPresented: $isPresentingLiveness,
//            onCompletion: { result in
//
//
//                switch result {
//
//                case .success:
//                    print("Success")
//
//                    DispatchQueue.main.async {
//                        faceLivenessStringValue = "1"
//                        self.isPresentingUserInfo = true
//                    }
//                case .failure(_):
//                    print("Failure")
//                    faceLivenessStringValue = "0"
//                    DispatchQueue.main.async {
//                        self.isPresentingUserInfo = true
//                    }
//                default:
//                    print("Default case")
//                }
//            }
//        )
//        .sheet(isPresented: $isPresentingUserInfo) {
//            UserInfoViewControllerRepresentable(results: results, sessionId: sessoinIdValue, faceLiveness: true)
//        }
//    }
//}
