//
//  SupportVC.swift
//  KeskeseStaff
//
//  Created by NI Vol on 9/16/19.
//  Copyright © 2019 Keskese. All rights reserved.
//

import UIKit
import WebKit

class SupportVC: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://tawk.to/chat/5d837ff59f6b7a4457e2887a/default")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

}
