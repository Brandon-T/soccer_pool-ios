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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaPlaybackRequiresUserAction = false
        
        let userController = WKUserContentController()
        let path = NSBundle.mainBundle().pathForResource("Adblock", ofType: "js")
        

        let javascript = try! String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        userController.addUserScript(WKUserScript(source: javascript, injectionTime: .AtDocumentEnd, forMainFrameOnly: false))
        
        //let script = WKUserScript(source: "webkit.messageHandlers.didGetHTML.postMessage(document.documentElement.outerHTML.toString());", injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        //userController.addUserScript(script)
        userController.addScriptMessageHandler(self, name: "didGetHTML")
        
        config.userContentController = userController
        
        let webView = WKWebView(frame: self.view.frame, configuration: config)
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        webView.contentMode = .ScaleAspectFit
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://getlivefootball.com/live")!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
        else if message.name == "didGetHTML" {
            if let html = message.body as? String {
                print(html)
            }
        }
    }
}