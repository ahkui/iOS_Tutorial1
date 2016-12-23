//
//  WebViewController.swift
//  D0562215
//
//  Created by RTC31 on 2016/12/9.
//  Copyright © 2016年 AppCoda. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var _url:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _URL = URL(string: _url!) {
            let request = URLRequest(url: _URL)
            webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
