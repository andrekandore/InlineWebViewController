//
//  WebLoading.swift
//  InlineWebview
//
//  Created by アンドレ on 2016/10/17.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit
import WebKit

class WebLoadingTableCell: UITableViewCell {
    
    static var activityContext = "loading?"
    static var progressContext = "progress?"
    
    @IBOutlet weak var activityIndicaor : UIActivityIndicatorView?
    @IBOutlet weak var progressIndicator : UIProgressView?
    @IBOutlet weak var webview : WKWebView? {
        didSet {
            if let newValue = self.webview {
                newValue.addObserver(self, forKeyPath: "estimatedProgress", options: [.new,.old], context: &WebLoadingTableCell.progressContext)
                newValue.addObserver(self, forKeyPath: "loading", options: [.new,.old], context: &WebLoadingTableCell.activityContext)
            } else {
                oldValue?.removeObserver(self, forKeyPath: "estimatedProgress", context: &WebLoadingTableCell.progressContext)
                oldValue?.removeObserver(self, forKeyPath: "loading", context: &WebLoadingTableCell.activityContext)
            }
            self.update()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &WebLoadingTableCell.activityContext || context == &WebLoadingTableCell.progressContext {
            self.update()
        }
    }
    
    func update() {
        guard let theWebview = self.webview else {
            return
        }
        
        if let theActivityIndicator = self.activityIndicaor {
            if true == theWebview.isLoading {
                theActivityIndicator.startAnimating()
            } else {
                theActivityIndicator.stopAnimating()
            }
        }
        
        if let theProgressIndicator = self.progressIndicator {
            let theProgress = Float(theWebview.estimatedProgress)
            theProgressIndicator.progress = theProgress
            theProgressIndicator.isHidden = (theProgress >= 1.0)
        }
    }
}
