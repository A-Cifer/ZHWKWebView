//
//  ZHFileManager.swift
//  ZHWebViewLocal
//
//  Created by cifer on 2018/5/10.
//  Copyright © 2018年 cifer. All rights reserved.
//

import UIKit

import SSZipArchive

enum ZHVersion {
    case ZHHtml,ZHHtmlMore
}

class ZHFileManager: NSObject {
    
    static private var manager:ZHFileManager?
    // 单例对象
    class func getInstance() -> ZHFileManager {
        if manager == nil {
            manager = ZHFileManager()
        }
        return manager!
    }

    func unzipFile(_ version:ZHVersion = .ZHHtml) {
        print(NSHomeDirectory(),"沙盒目录")
        // 创建文件夹zhTestFolder文件夹,得到zhTestFile路径
        guard let zhTestFolderPath = self.getAndCreatFloder() else {
            return
        }
        if version == .ZHHtml {
            // 得到第一版本ZHHtmlZip包的地址
            guard let localZipPaht = Bundle.main.path(forResource: "ZHHtml", ofType: "zip") else {
                return
            }
            // 解压文件到zhTestFolder文件夹下面
            SSZipArchive.unzipFile(atPath: localZipPaht, toDestination: zhTestFolderPath)
            print("解压第一版成功")
        }else {
            // 得到第二版本ZHHtmlMoreZip包的地址
            guard let localZipPaht = Bundle.main.path(forResource: "ZHHtmlMore", ofType: "zip") else {
                return
            }
            // 解压文件到zhTestFolder文件夹下面
            SSZipArchive.unzipFile(atPath: localZipPaht, toDestination: zhTestFolderPath)
            print("解压第二版成功")
        }
        
    }
    
    
    
    func getZhTestUrlPath() -> (String,String)? {
        guard let path = self.getAndCreatFloder() else {
            print("没有找到文件夹？")
            return nil
        }
        let ZHHtmlFloderPath = path + "/ZHHtml"
        let zhTestPath = ZHHtmlFloderPath + "/zhTest.html"
        return (ZHHtmlFloderPath,zhTestPath)
    }
    

    
}

extension ZHFileManager {
    func getAndCreatFloder() -> String? {
        guard let docsdir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else {
            print("error,没有取到自己的盘")
            return nil
        }
        guard let dataFilePath = (docsdir as NSString).strings(byAppendingPaths: ["zhTestFolder"]).first else {
            print("error,zhTestFile没找到还是啥")
            return nil
        }
        let fileManager = FileManager.default
        var isDir = ObjCBool.init(false)
        let existed = fileManager.fileExists(atPath: dataFilePath, isDirectory: &isDir)
        
        if !(isDir.boolValue && existed) {
            print("不存在文件夹")
            do {
                //                print("尝试创建")
                try fileManager.createDirectory(atPath: dataFilePath, withIntermediateDirectories: true, attributes: nil)
                print("创建文件夹成功")
                return dataFilePath
            }catch {
                print("error创建失败=\(error)")
                return nil
            }
        }else {
            print("存在文件夹")
            return dataFilePath
        }
        
    }
    
    func removeFloder(_ callBack:(()->())? = nil) {
        guard let floderPath = getAndCreatFloder() else {
            return
        }
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: floderPath)
            print("删除文件夹成功")
            callBack?()
        } catch {
            print("error删除失败=\(error)")
        }
    }
}
