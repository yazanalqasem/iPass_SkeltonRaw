//
//  OpenWebUrlVC.swift
//  ipass_plus
//
//  Created by Mobile on 07/02/24.
//

import UIKit
import WebKit
import SafariServices

class OpenWebUrlVC: UIViewController,WKNavigationDelegate {

    var webView:WKWebView!
    var webStringUrl:String = ""
    
    @IBOutlet weak var showDataVw: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        webView = WKWebView(frame: view.bounds)
//        webView.navigationDelegate = self
//        showDataVw.addSubview(webView)
        
//        openWebUrls(UrlString: webStringUrl)
//        openSafariWith(webStringUrl)
        
//        openURLInSafari(urlString: webStringUrl)
 
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
//    private func openSafariWith(_ link: String) {
//          guard let url = URL(string: link) else { return }
//          let controller = SFSafariViewController(url: url)
//          self.present(controller, animated: true, completion: nil)
//      }
    
    
    func openURLInSafari(urlString: String) {
          if let url = URL(string: urlString) {
              let safariViewController = SFSafariViewController(url: url)
              present(safariViewController, animated: true, completion: nil)
          }
      }
    
    
    
    func openWebUrls(UrlString:String){
        if let url = URL(string: UrlString){
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(webView.url?.absoluteString as Any)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
}
