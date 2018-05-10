//
//  ViewController.swift
//  ZHWKWebView
//
//  Created by cifer on 2018/5/10.
//  Copyright © 2018年 cifer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...5{
            let btn = UIButton.init(frame: CGRect.init(x: 20, y: 100 * i, width: Int(UIScreen.main.bounds.width - 40), height: 60))
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchDown)
            btn.backgroundColor = UIColor.red
            self.view.addSubview(btn)
            btn.tag = i
            switch i {
            case 1:
                btn.setTitle("解压第一版加载第一版", for: .normal)
                break
            case 2:
                btn.setTitle("第一版后增量更新第二版,加载第二版", for: .normal)
            case 3:
                btn.setTitle("删除本地版本文件", for: .normal)
            case 4:
                btn.setTitle("加载变成真机无效，模拟器有效", for: .normal)
            case 5:
                btn.setTitle("加载HTML，未找到css或者图片", for: .normal)
            default :
                break
            }
        }
        print("请在点击1或者12，本地有文件以后，点击4及以上")
    }

    @objc func btnAction(_ sender:UIButton) {
        let vc = ZHWkWebViewController()
        switch sender.tag {
        case 1:
            ZHFileManager.getInstance().unzipFile(.ZHHtml)
        case 2:
            ZHFileManager.getInstance().unzipFile(.ZHHtmlMore)
        case 3:
            ZHFileManager.getInstance().removeFloder()
            return
        case 4:
            vc.requestType = .reloadIgnoringCacheData
        case 5:
            vc.requestType = .loadHTMLString
        default:
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

