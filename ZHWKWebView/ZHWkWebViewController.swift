//
//  ZHWkWebViewController.swift
//  ZHWebViewLocal
//
//  Created by cifer on 2018/5/10.
//  Copyright © 2018年 cifer. All rights reserved.
//

import UIKit
import WebKit

enum ZHRequestType {
    case LoadFileUrl,reloadIgnoringCacheData,loadHTMLString
}

class ZHWkWebViewController: UIViewController {

    var webView:WKWebView!
    
    var requestType: ZHRequestType = .LoadFileUrl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = WKWebViewConfiguration.init()
        configuration.preferences.minimumFontSize = 45
        webView = WKWebView.init(frame: self.view.bounds, configuration: configuration)
        self.view.addSubview(webView)
        
        print("开始寻找webView地址")
        guard let paths = ZHFileManager.getInstance().getZhTestUrlPath() else {
            return
        }
        let url = URL.init(fileURLWithPath: paths.1)
        switch requestType {
        case .LoadFileUrl:
            print("指定了上层文件目录，模拟器真机都可以加载css或者图片文件")
            let allowingReadAccessToUrl = URL.init(fileURLWithPath: paths.0)
            webView.loadFileURL(url, allowingReadAccessTo: allowingReadAccessToUrl)
        case .reloadIgnoringCacheData:
            print("仅仅模拟器有用，真机无法加载css或者图片文件")
            webView.load(URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 50))
        case .loadHTMLString:
            do {
                print("模拟器和真机都无法加载css或者图片文件")
                let str = try String.init(contentsOfFile: paths.1, encoding: String.Encoding.utf8)
                webView.loadHTMLString(str, baseURL: Bundle.main.bundleURL)
            } catch {
                print("error=读取html文件\(error)")
            }
        default:
            print("新分支")
            return
        }
 
    }

}
