//
//  WebviewConvenience.swift
//  InlineWebview
//
//  Created by アンドレ on 2016/10/17.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import WebKit

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
