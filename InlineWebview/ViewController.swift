//
//  ViewController.swift
//  InlineWebview
//
//  Created by アンドレ on 2016/10/16.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit

let magicSection = 3


class ViewController: UITableViewController  {
    
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if magicSection == indexPath.section {
            return self.view.bounds.height
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}


extension UIWebView {
     @IBInspectable var urlString : String? {
        set {
            guard let aNewValue = newValue else {
                return
            }
            
            guard let newURL = URL(string: aNewValue) else {
                return
            }
            
            let request = URLRequest(url: newURL)
            self.loadRequest(request)
        }
        get {
            return self.request?.url?.absoluteString
        }
    }
}
