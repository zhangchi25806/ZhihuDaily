//
//  ExperimentalVC.swift
//  DailyNewsApp
//
//  Created by Chi Zhang on 2020/2/12.
//  Copyright © 2020 Chi Zhang. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class DetailWebViewController: UIViewController, WKUIDelegate {
    @IBOutlet weak var webView: WKWebView!
    var webUrl: URL?
    
    @IBAction func back(sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView.uiDelegate = self
//        view = webView
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        let webRequest = URLRequest(url: webUrl!)
        webView.load(webRequest)
    }
}
