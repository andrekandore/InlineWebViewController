//
//  ViewController.swift
//  InlineWebview
//
//  Created by アンドレ on 2016/10/16.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit
import WebKit

let magicSection = 3


class ViewController: UITableViewController, WKUIDelegate  {
    
    lazy var webView : WKWebView = {
      
        let config = WKWebViewConfiguration()
        
        let newWebView = WKWebView(frame: self.view.bounds, configuration:config)
        newWebView.urlString = "https://www.apple.com"
        newWebView.scrollView.bounces = false
        newWebView.scrollView.delegate = self
        newWebView.uiDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.101, execute:{
            newWebView.scrollView.panGestureRecognizer.isEnabled = false
            self.tableView.panGestureRecognizer.require(toFail: newWebView.scrollView.panGestureRecognizer)
        })
        
        return newWebView
    }()
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 3 == section {
            return 1
        }
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellInfo : (identifier: String,label: String?) = {
            if magicSection == indexPath.section {
                return ("web",nil)
            }
            return ("normal","Row:\(indexPath.row)")
        }()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.identifier, for: indexPath)
        cell.textLabel?.text = cellInfo.label
        
        if magicSection == indexPath.section {
            
            var frame = self.tableView.bounds
            frame.origin.y = 0
            frame.origin.x = 0
            
            let theWebView = self.webView
            theWebView.frame = frame
            theWebView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            
            cell.contentView.addSubview(self.webView)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if magicSection == indexPath.section, nil != self.webView.superview {
            self.webView.removeFromSuperview()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if magicSection == indexPath.section {
            return self.view.bounds.height
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let tableScrollView : UIScrollView = self.tableView
        
        let theWebView = self.webView
        let theWebViewScrollView = theWebView.scrollView

        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview);
        
        let tableFrame = self.tableView.frame
        let currentTableOffset = tableScrollView.contentOffset
        let theMagicIndexPath = IndexPath(row: 0, section: magicSection)
        let theMagicRect = self.tableView.rectForRow(at: theMagicIndexPath)
        
        let theWebViewScrollViewOffset = theWebViewScrollView.contentOffset
        let theWebViewScrollContentSize = theWebViewScrollView.contentSize

        guard theWebViewScrollContentSize.height > tableFrame.height else {
            return
        }

        if scrollView.isEqual(theWebViewScrollView) {
            if translation.y > 0 {
                debugPrint("Direcion Downwards")
                
                if currentTableOffset.y >=  theMagicRect.origin.y, theWebViewScrollViewOffset.y <= 0 {
                    theWebViewScrollView.panGestureRecognizer.isEnabled = false
                    tableScrollView.isScrollEnabled = true
                    tableScrollView.contentOffset = theMagicRect.origin
                }
                
            } else {
                debugPrint("Direcion Downwards")
                
                if theWebViewScrollViewOffset.y + tableFrame.height + 1 >= theWebViewScrollContentSize.height {
                    theWebViewScrollView.panGestureRecognizer.isEnabled = false
                    tableScrollView.isScrollEnabled = true
                } else if false == tableScrollView.isScrollEnabled {
                    tableScrollView.contentOffset = theMagicRect.origin
                }
            }
        } else {
            
            if translation.y > 0 {
                debugPrint("Direcion Upwards")
                
                if theWebViewScrollViewOffset.y + 1 >=  (theWebViewScrollContentSize.height - theMagicRect.height), (currentTableOffset.y + theMagicRect.size.height) <=  (theMagicRect.origin.y + theMagicRect.size.height) {
                    theWebViewScrollView.panGestureRecognizer.isEnabled = true
                    tableScrollView.isScrollEnabled = false
                    tableScrollView.contentOffset = theMagicRect.origin
                } else if false == tableScrollView.isScrollEnabled {
                    tableScrollView.contentOffset = theMagicRect.origin
                }
                
            } else {
                debugPrint("Direcion Downwards")

                if currentTableOffset.y >=  theMagicRect.origin.y, theWebViewScrollViewOffset.y <= 0 {
                    theWebViewScrollView.panGestureRecognizer.isEnabled = true
                    tableScrollView.isScrollEnabled = false
                    tableScrollView.contentOffset = theMagicRect.origin
                }
            }
        }
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let tableFrame = self.tableView.frame

        let theWebView = self.webView
        let theWebViewScrollView = theWebView.scrollView
        let theWebViewScrollContentSize = theWebViewScrollView.contentSize

        guard theWebViewScrollContentSize.height > tableFrame.height else {
            return
        }
        
        let currentTargetContentOffset = targetContentOffset.pointee
        let tableScrollView : UIScrollView = self.tableView
        
        let currentTableOffset = tableScrollView.contentOffset
        let theMagicIndexPath = IndexPath(row: 0, section: magicSection)
        let theMagicRect = self.tableView.rectForRow(at: theMagicIndexPath)
        
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview);
        
        if scrollView.isEqual(theWebViewScrollView) {
            if translation.y > 0 {
                debugPrint("Direcion Upwards")
            } else {
                debugPrint("Direcion Downwards")
                
                if currentTargetContentOffset.y >= theMagicRect.origin.y, currentTableOffset.y < theMagicRect.origin.y {
                    targetContentOffset.pointee.y = theMagicRect.origin.y
                }
            }
        } else {
            if translation.y > 0 {
                debugPrint("Direcion Upwards")

                if currentTargetContentOffset.y <= theMagicRect.origin.y, currentTableOffset.y > theMagicRect.origin.y {
                    targetContentOffset.pointee.y = theMagicRect.origin.y
                }
                
            } else {
                debugPrint("Direcion Downwards")

                let webviewOffset = theWebView.scrollView.contentOffset
                let webviewBounds = theWebView.scrollView.contentSize
                if  currentTargetContentOffset.y+theMagicRect.size.height >= webviewBounds.height {
                    
                    theWebViewScrollView.setContentOffset(currentTargetContentOffset, animated: true)
                    
                    var newContentOffset = self.tableView.contentOffset
                    newContentOffset.y += (currentTargetContentOffset.y - webviewOffset.y)
                    theWebViewScrollView.setContentOffset(newContentOffset, animated: true)
                }

            }
        }
    }
}


extension WKWebView {
     @IBInspectable var urlString : String? {
        set {
            guard let aNewValue = newValue else {
                return
            }
            
            guard let newURL = URL(string: aNewValue) else {
                return
            }
            
            let request = URLRequest(url: newURL)
            self.load(request)
        }
        get {
            return self.url?.absoluteString
        }
    }
}


class WebLoadingTableCell: UITableViewCell {
    @IBOutlet var progressIndicator : UIProgressView?
    @IBOutlet var activityIndicaor : UIActivityIndicatorView?
}
