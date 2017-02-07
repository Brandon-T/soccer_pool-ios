//
//  StreamingViewController.swift
//  SoccerPool
//
//  Created by Brandon Anthony on 2016-06-15.
//  Copyright © 2016 XIO. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StreamingViewController : UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView?
    let request = NSURLRequest(URL: NSURL(string: "http://getlivefootball.com/live")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Live Stream"
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaPlaybackRequiresUserAction = false
        
        let userController = WKUserContentController()
        let path = NSBundle.mainBundle().pathForResource("Adblock", ofType: "js")
        

        let javascript = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        userController.addUserScript(WKUserScript(source: javascript, injectionTime: .AtDocumentEnd, forMainFrameOnly: false))

        userController.addScriptMessageHandler(self, name: "didFinishLoading")
        config.userContentController = userController
        
        self.webView = WKWebView(frame: self.view.frame, configuration: config)
        self.webView?.navigationDelegate = self
        
        self.view.addSubview(self.webView!)
        
        self.webView!.contentMode = .ScaleAspectFit
        self.webView!.loadRequest(self.request)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(onRefreshPage))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onRefreshPage(button: UIBarButtonItem) {
        self.webView?.reload()
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        
        let url = navigationAction.request.URLString
        

        if url.containsString("getlivefootball") || url.containsString("stream") || url.containsString("embed") {
            print("Allowing: \(navigationAction.request.URLString)")
            decisionHandler(.Allow)
        }
        else {
            print("Cancelling: \(navigationAction.request.URLString)")
            decisionHandler(.Cancel)
        }
    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if message.name == "didFinishLoading" {
            if let html = message.body as? String {
                print(html)
            }
        }
    }
}