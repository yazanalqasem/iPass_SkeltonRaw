//
//  ASWFaceMatching.swift
//  ipass_plus
//
//  Created by Mobile on 07/03/24.
//

import Foundation
import AWSRekognition
import AWSCore

class ASWFaceMatchingewwwe {
    static let shared = ASWFaceMatchingewwwe()

    private init() {}

    func configureAWS() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "", secretKey: "")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }

//    func compareImages(image1Data: Data, image2Data: Data) {
//        let rekognition = AWSRekognition.default()
//
//        let image1 = AWSRekognitionImage()
//        image1?.bytes = image1Data
//
//        let image2 = AWSRekognitionImage()
//        image2?.bytes = image2Data
//
//        let request = AWSRekognitionCompareFacesRequest()
//        request?.sourceImage = image1
//        request?.targetImage = image2
//        request?.similarityThreshold = 70 // Adjust the similarity threshold as needed
//
//        rekognition.compareFaces(request!).continueWith { (task) -> Any? in
//            if let error = task.error {
//                print("Error comparing faces: \(error)")
//            } else if let result = task.result {
//                if let match = result.faceMatches?.first {
//                    print("Similarity: \(match.similarity ?? 0)")
//                } else {
//                    print("No faces matched.")
//                }
//            }
//            return nil
//        }
//    }
}



//func compareImages(image1Data: Data, image2Data: Data) {
//    let rekognition = AWSRekognition.default()
//
//    let image1 = AWSRekognition.AWSRekognitionImage()
//    image1?.bytes = image1Data
//
//    let image2 = AWSRekognition.AWSRekognitionImage()
//    image2?.bytes = image2Data
//
//    let request = AWSRekognition.AWSRekognitionCompareFacesRequest()
//    request?.sourceImage = image1
//    request?.targetImage = image2
//    request?.similarityThreshold = 70 // Adjust the similarity threshold as needed
//
//    rekognition.compareFaces(request!).continueWith { (task) -> Any? in
//        if let error = task.error {
//            print("Error comparing faces: \(error)")
//        } else if let result = task.result {
//            if let match = result.faceMatches?.first {
//                print("Similarity: \(match.similarity ?? 0)")
//            } else {
//                print("No faces matched.")
//            }
//        }
//        return nil
//    }
//}
