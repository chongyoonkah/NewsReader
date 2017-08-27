//
//  FullArticleViewController.swift
//  Vositive News Reader
//
//  Created by Daniel Chong on 28/6/17.
//  Copyright © 2017 Vositive Solutions. All rights reserved.
//

import UIKit

class FullArticleViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var url:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Web View"
        
        if let passedUrl = URL(string: url!) {
            webView.loadRequest(URLRequest(url: passedUrl))
        }
    }


}
