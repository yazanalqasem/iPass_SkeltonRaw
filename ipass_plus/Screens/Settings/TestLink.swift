//
//  TestLink.swift
//  ipass_plus
//
//  Created by MOBILE on 27/03/24.
//

import UIKit
import WebKit

class TestLink: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webOut: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webOut.navigationDelegate = self
        if let url = URL(string: "https://purple-technology.github.io/react-camera-pro/") {
               let request = URLRequest(url: url)
            webOut.load(request)
           }
        webOut.addObserver(self, forKeyPath: "URL", options: [.new], context: nil)
        webOut.allowsBackForwardNavigationGestures = false
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "URL", let newURL = change?[.newKey] as? URL {
               print("URL changed to11: \(newURL.absoluteString)")
               // https://ipassplusfrontend.csdevhub.com/thankyoupage
               if(newURL.absoluteString.contains("thankyoupage")) {
                   print("dismiss here")
                   self.dismiss(animated: true) {
                       // get status from api
                   }

               }
           }
       }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
           print("URL changed to: \(webView.url?.absoluteString ?? "Unknown")")
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
