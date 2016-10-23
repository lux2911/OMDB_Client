//
//  ImdbViewController.swift
//  OMDB_Client
//
//  Created by Tomislav Luketic on 10/23/16.
//  Copyright © 2016 Tomislav Luketic. All rights reserved.
//

import UIKit

class ImdbViewController: UIViewController,UIWebViewDelegate {

	
	
	@IBOutlet var webView: UIWebView!
	
	let baseURL = "http://www.imdb.com/title/"
	
	var imdbID : String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.webView.delegate = self

		let request = URLRequest.init(url: URL.init(string: baseURL.appending(imdbID))!)
		
		self.showSpinnerInWindow()
		
		self.webView.loadRequest(request)
        
    }
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		
		self.dismissHUD(animated: true)
	}
	
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		
		self.dismissHUD(animated: true)
	}

	
}
