//
//  NaviagationView.swift
//  ipass_plus
//
//  Created by MOBILE on 04/03/24.
//

import UIKit
import SwiftUI
import DocumentReader


struct UserInfoViewControllerRepresentable: UIViewControllerRepresentable {
    var results: DocumentReaderResults
    var sessionId: String
    var faceLiveness: Bool
    var isScanningTypeIndex:Int?

    func makeUIViewController(context: Context) -> UserInfoVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "UserInfoVC") as! UserInfoVC
        viewController.results = results
        viewController.getUserSessionId = sessionId
        viewController.faceLiveness = faceLiveness
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    func updateUIViewController(_ uiViewController: UserInfoVC, context: Context) {
        // Update the view controller if needed
    }
}
