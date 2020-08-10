
//
//  UIImage+Extension.swift
//  ZPOperator
//
//  Created by 杜进新 on 2017/7/1.
//  Copyright © 2017年 dujinxin. All rights reserved.
//

import UIKit
import Photos

enum JXSourceType {
    case image
    case video
}

public extension UIImage {
    
    /// 依据宽度等比例对图片重新绘制
    ///
    /// - Parameters:
    ///   - originalImage: 原图
    ///   - scaledWidth: 将要缩放或拉伸的宽度
    /// - Returns: 新的图片
    class func image(originalImage:UIImage? ,to scaledWidth:CGFloat) -> UIImage? {
        guard let image = originalImage else {
            return UIImage.init()
        }
        let imageWidth = image.size.width
        let imageHeigth = image.size.height
        let width = scaledWidth
        let height = image.size.height / (image.size.width / width)
        
        let widthScale = imageWidth / width
        let heightScale = imageHeigth / height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        if widthScale > heightScale {
            image.draw(in: CGRect(x: 0, y: 0, width: imageWidth / heightScale, height: heightScale))
        } else {
            image.draw(in: CGRect(x: 0, y: 0, width: width, height: imageHeigth / widthScale))
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    func image(originalImage:UIImage?,rect:CGRect,radius:CGFloat) -> UIImage? {
        guard let image = originalImage else {
            return UIImage.init()
        }
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        
        
        //let path = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: pid_t * 0, endAngle: pid_t * 2, clockwise: true)
        let path = UIBezierPath(ovalIn: rect)
        //剪切
        path.addClip()
        
        image.draw(in: rect)
        
        path.lineCapStyle = .round
        UIColor.darkGray.setStroke()
        path.lineWidth = 2
        path.stroke(with: .color, alpha: 0.8)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
  
        return newImage
    }
    /// 截屏，根据视图的大小来截取一种图片
    ///
    /// - Parameter view: 要截取的视图
    /// - Returns: 图片
    class func imageScreenshot(view: UIView) -> UIImage? {
        let rect = view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        view.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    /// 色彩图片
    ///
    /// - Parameter color: 要生成图片的颜色
    /// - Returns: 图片
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
public extension UIImage {
    
    //MARK:保存图片，视频到相册 - 系统方法
    /// 保存图片
    /// - Parameters:
    ///   - image: 图片
    ///   - completion: <#completion description#>
    /// - Returns: <#description#>
    class func imageWriteToSavedPhotosAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    /// 保存视频
    /// - Parameters:
    ///   - videoPath: 视频本地路径
    ///   - completion: <#completion description#>
    /// - Returns: <#description#>
    class func saveVideoAtPathToSavedPhotosAlbum(videoPath: String) {
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath, self, #selector(video(path:didFinishSaving:contextInfo:)), nil)
        }
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if error != nil {
            print("保存成功")
        }else{
            print("保存失败：",error?.localizedDescription as Any)
        }
    }
    @objc func video(path: String, didFinishSaving error: Error?, contextInfo: UnsafeMutableRawPointer?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("保存成功")
        }
    }
    //MARK:保存图片，视频到相册 - 自建相册
    /// 保存图片到相册（只有一帧）
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - isAlbum: 是否新建相册
    ///   - completion: 回调
    class func saveImage(image: UIImage, isCreateAlbum: Bool = false, albumName: String, completion: @escaping ((_ isSuccess: Bool,_ msg: String)->())) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    saveImageToAlbum(image: image, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .restricted {
            let notice = JXNoticeView.init(text: "请打开相册权限")
            notice.show()
        } else {
            saveImageToAlbum(image: image, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
        }
        
    }
    class func saveResource(data: Data?, fileURL: URL?, type: PHAssetResourceType, isCreateAlbum: Bool = false, albumName: String, completion: @escaping ((_ isSuccess: Bool,_ msg: String)->())) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    saveResourceToAlbum(data: data, fileURL: fileURL, type: type, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .restricted {
            let notice = JXNoticeView.init(text: "请打开相册权限")
            notice.show()
        } else {
            saveResourceToAlbum(data: data, fileURL: fileURL, type: type, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
        }
        
    }
    
    /// 保存图片到相册（包括Gif图片）
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - isAlbum: 是否新建相册
    ///   - completion: 回调
    class func saveImage(path: String, isCreateAlbum: Bool = false, albumName: String, completion: @escaping ((_ isSuccess: Bool,_ msg: String)->())) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    saveImageVideoToAlbum(path: path, sourceType: .image, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .restricted {
            let notice = JXNoticeView.init(text: "请打开相册权限")
            notice.show()
        } else {
            saveImageVideoToAlbum(path: path, sourceType: .image, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
        }
        
    }
    /// 保存视频到相册
    ///
    /// - Parameters:
    ///   - path: 视频路径
    ///   - isAlbum: 是否新建相册
    ///   - completion: 回调
    class func saveVideo(path: String, isCreateAlbum: Bool = false, albumName: String, completion: @escaping ((_ isSuccess: Bool,_ msg: String)->())) -> Void {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    saveImageVideoToAlbum(path: path, sourceType: .video, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .restricted {
            let notice = JXNoticeView.init(text: "请打开相册权限")
            notice.show()
        } else {
            saveImageVideoToAlbum(path: path, sourceType: .video, isCreateAlbum: isCreateAlbum, albumName: albumName, completion: completion)
        }
        
    }
    /// 保存图片到相册
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - isCreateAlbum: 是否新建相册（如果有就不会创建）
    ///   - albumName: 相册名字
    ///   - completion: 回调
    class private func saveImageToAlbum(image: UIImage, isCreateAlbum: Bool, albumName: String, completion: @escaping ((_ isSuccess: Bool, _ msg: String)->())) -> Void {
        
        //同步执行
//        try? PHPhotoLibrary.shared().performChangesAndWait({
//            //
//            PHAssetChangeRequest.creationRequestForAsset(from: cell.imageView.image!)
//        })
        //异步
        var placeHolder : String!
        PHPhotoLibrary.shared().performChanges({
            //
            let changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeHolder = changeRequest.placeholderForCreatedAsset?.localIdentifier
            
            
        }, completionHandler: { (isSuccess, error) in
            
            if isSuccess{
                if isCreateAlbum == false {
                    DispatchQueue.main.async {
                        completion(isSuccess,"保存成功")
                    }
                    return
                }
                let phassetResults = PHAsset.fetchAssets(withLocalIdentifiers: [placeHolder], options: nil)
                //print(phassetResults.firstObject)
             
                var collectionChangeRequest: PHAssetCollectionChangeRequest!
                var phAssetCollection : PHAssetCollection?
                //PHAssetCollectionType: 相册类型：album,用户自定义相册；smartAlbum,系统相册；moment 事件排序相册
                //PHAssetCollectionSubtype:相册子类型：更详细的分类, 缩小查找范围，提高效率
                //PHFetchOptions?
                let collectionResults = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                collectionResults.enumerateObjects({ (assetCollection, index, stop) in
                    if albumName == assetCollection.localizedTitle{
                        phAssetCollection = assetCollection
                        stop.initialize(to: true)
                    }
                })
                if let phAssetCollection = phAssetCollection {//有已经建好的相册，那么直接保存即可
                
                    //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                    PHPhotoLibrary.shared().performChanges({
                        //根据已有相册创建一个操作相册的对象
                        collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection)
                        //给相册插入图片
                        collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                        
                        
                    }, completionHandler: { (isS, error) in
                        
                        DispatchQueue.main.async {
                            if isS {
                                completion(true,"保存到自定义相册成功")
                            }else{
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                } else {//没有找到指定相册，需要新建相册
                    //创建相册
                    
                    var collectionPlaceHolder : String!
                    var collectionChangeRequest: PHAssetCollectionChangeRequest!
                    PHPhotoLibrary.shared().performChanges({
                        //创建一个相册
                        collectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                        //保存其占位符
                        collectionPlaceHolder = collectionChangeRequest.placeholderForCreatedAssetCollection.localIdentifier
                    }, completionHandler: { (isCollectionCreateSuccess, error) in
                        if isCollectionCreateSuccess {
                            //根据占位符来获取相册
                            let phAssetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionPlaceHolder], options: nil)
                            //print(phassetCollection.firstObject)
                            
                            //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                            PHPhotoLibrary.shared().performChanges({
                                //创建一个操作相册的对象
                                collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection.firstObject!)
                                //给相册插入图片
                                collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                               
                            }, completionHandler: { (isS, error) in
                                
                                DispatchQueue.main.async {
                                    if isS {
                                        completion(true,"保存到自定义相册成功")
                                    } else {
                                        completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                                    }
                                }
                            })
                            
                        } else {
                            DispatchQueue.main.async {
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                }
            }
        })
    }
    /// 保存视频到相册
    ///
    /// - Parameters:
    ///   - path: 视频路径
    ///   - isCreateAlbum: 是否新建相册（如果有就不会创建）
    ///   - albumName: 相册名字
    ///   - completion: 回调
    class private func saveImageVideoToAlbum(path: String, sourceType: JXSourceType = .image, isCreateAlbum: Bool, albumName: String, completion: @escaping ((_ isSuccess: Bool, _ msg: String) -> ())) -> Void {
        //同步执行
//        try? PHPhotoLibrary.shared().performChangesAndWait({
//            //
//            PHAssetChangeRequest.creationRequestForAsset(from: cell.imageView.image!)
//        })
        //异步
        var placeHolder : String!
        PHPhotoLibrary.shared().performChanges({
            //
            let changeRequest = sourceType == .video ? PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: path)) : PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(fileURLWithPath: path))
            placeHolder = changeRequest?.placeholderForCreatedAsset?.localIdentifier
            
        }, completionHandler: { (isSuccess, error) in
            
            if isSuccess{
                if isCreateAlbum == false {
                    DispatchQueue.main.async {
                        completion(isSuccess,"保存成功")
                    }
                    return
                }
                let phassetResults = PHAsset.fetchAssets(withLocalIdentifiers: [placeHolder], options: nil)
                //print(phassetResults.firstObject)
                
                var collectionChangeRequest: PHAssetCollectionChangeRequest!
                var phAssetCollection : PHAssetCollection?
                //PHAssetCollectionType: 相册类型：album,用户自定义相册；smartAlbum,系统相册；moment 事件排序相册
                //PHAssetCollectionSubtype:相册子类型：更详细的分类, 缩小查找范围，提高效率
                //PHFetchOptions?
                let collectionResults = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                //let collectionResults = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeHolder], options: nil)
                collectionResults.enumerateObjects({ (assetCollection, index, stop) in
                    if albumName == assetCollection.localizedTitle{
                        phAssetCollection = assetCollection
                        stop.initialize(to: true)
                    }
                })
                if let phAssetCollection = phAssetCollection {//有已经建好的相册，那么直接保存即可
                
                    //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                    PHPhotoLibrary.shared().performChanges({
                        //根据已有相册创建一个操作相册的对象
                        collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection)
                        //给相册插入图片
                        collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                        
                        
                    }, completionHandler: { (isS, error) in
                        DispatchQueue.main.async {
                            if isS {
                                completion(true,"保存到自定义相册成功")
                            }else{
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                } else {//没有找到指定相册，需要新建相册
                    //创建相册
                    
                    var collectionPlaceHolder : String!
                    var collectionChangeRequest: PHAssetCollectionChangeRequest!
                    PHPhotoLibrary.shared().performChanges({
                        //创建一个相册
                        collectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                        //保存其占位符
                        collectionPlaceHolder = collectionChangeRequest.placeholderForCreatedAssetCollection.localIdentifier
                    }, completionHandler: { (isCollectionCreateSuccess, error) in
                        if isCollectionCreateSuccess {
                            //根据占位符来获取相册
                            let phAssetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionPlaceHolder], options: nil)
                            //print(phassetCollection.firstObject)
                            
                            //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                            PHPhotoLibrary.shared().performChanges({
                                //创建一个操作相册的对象
                                collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection.firstObject!)
                                //给相册插入图片
                                collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                                
                                
                            }, completionHandler: { (isS, error) in
                                DispatchQueue.main.async {
                                    if isS {
                                        completion(true,"保存到自定义相册成功")
                                    }else{
                                        completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                                    }
                                }
                            })
                            
                        }else{
                            DispatchQueue.main.async {
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                }
            }
        })
    }
    class private func saveResourceToAlbum(data: Data?, fileURL: URL?, type: PHAssetResourceType, isCreateAlbum: Bool, albumName: String, completion: @escaping ((_ isSuccess: Bool, _ msg: String)->())) -> Void {
        
        //异步
        var placeHolder : String!
        PHPhotoLibrary.shared().performChanges({
            //
            let request = PHAssetCreationRequest(for: PHAsset())
            
            if let data = data, data.isEmpty == false {
                request.addResource(with: type, data: data, options: nil)
            } else if let url = fileURL, url.isFileURL == true {
                request.addResource(with: type, fileURL: url, options: nil)
            } else {
                DispatchQueue.main.async {
                    completion(false,"data,fileURL至少有一个不为空")
                }
            }
            placeHolder = request.placeholderForCreatedAsset?.localIdentifier
        }, completionHandler: { (isSuccess, error) in
        
            if isSuccess{
                if isCreateAlbum == false {
                    DispatchQueue.main.async {
                        completion(isSuccess,"保存成功")
                    }
                    return
                }
                let phassetResults = PHAsset.fetchAssets(withLocalIdentifiers: [placeHolder], options: nil)
                //print(phassetResults.firstObject)
             
                var collectionChangeRequest: PHAssetCollectionChangeRequest!
                var phAssetCollection : PHAssetCollection?
                //PHAssetCollectionType: 相册类型：album,用户自定义相册；smartAlbum,系统相册；moment 事件排序相册
                //PHAssetCollectionSubtype:相册子类型：更详细的分类, 缩小查找范围，提高效率
                //PHFetchOptions?
                let collectionResults = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                collectionResults.enumerateObjects({ (assetCollection, index, stop) in
                    if albumName == assetCollection.localizedTitle{
                        phAssetCollection = assetCollection
                        stop.initialize(to: true)
                    }
                })
                if let phAssetCollection = phAssetCollection {//有已经建好的相册，那么直接保存即可
                
                    //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                    PHPhotoLibrary.shared().performChanges({
                        //根据已有相册创建一个操作相册的对象
                        collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection)
                        //给相册插入图片
                        collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                        
                        
                    }, completionHandler: { (isS, error) in
                        
                        DispatchQueue.main.async {
                            if isS {
                                completion(true,"保存到自定义相册成功")
                            }else{
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                } else {//没有找到指定相册，需要新建相册
                    //创建相册
                    
                    var collectionPlaceHolder : String!
                    var collectionChangeRequest: PHAssetCollectionChangeRequest!
                    PHPhotoLibrary.shared().performChanges({
                        //创建一个相册
                        collectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
                        //保存其占位符
                        collectionPlaceHolder = collectionChangeRequest.placeholderForCreatedAssetCollection.localIdentifier
                    }, completionHandler: { (isCollectionCreateSuccess, error) in
                        if isCollectionCreateSuccess {
                            //根据占位符来获取相册
                            let phAssetCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [collectionPlaceHolder], options: nil)
                            //print(phassetCollection.firstObject)
                            
                            //将已保存到胶卷相册的图片插入到新相册中，并置于首位
                            PHPhotoLibrary.shared().performChanges({
                                //创建一个操作相册的对象
                                collectionChangeRequest = PHAssetCollectionChangeRequest(for: phAssetCollection.firstObject!)
                                //给相册插入图片
                                collectionChangeRequest.insertAssets(phassetResults, at: IndexSet.init(integer: 0))
                               
                            }, completionHandler: { (isS, error) in
                                
                                DispatchQueue.main.async {
                                    if isS {
                                        completion(true,"保存到自定义相册成功")
                                    } else {
                                        completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                                    }
                                }
                            })
                            
                        } else {
                            DispatchQueue.main.async {
                                completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                            }
                        }
                    })
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false,"保存到自定义相册失败 error = \(error?.localizedDescription ?? "")")
                }
            }
        })
    }
}
//MARK:保存到文件中
public extension UIImage {
    
    /// 保存图片到文件中
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - name: 数据名称
    /// - Returns: 操作结果
    static func insert(image: UIImage, name: String) ->Bool{
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return false
        }
        return FileManager.insert(data: data, toFile: name)
    }
    /// 修改文件中的图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - name: 数据名称
    /// - Returns: 操作结果
    static func update(image: UIImage, name: String) ->Bool {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return false
        }
        return FileManager.update(inFile: data, name: name)
    }
    /// 获取文件中的图片
    ///
    /// - Parameters:
    ///   - name: 数据名称
    /// - Returns: 操作结果
    static func select(name: String) -> UIImage? {
        guard let data = FileManager.select(fromFile: name) as? Data else {
            return nil
        }
        return UIImage(data: data)
    }
    /// 移除图片
    ///
    /// - Parameter name: 数据名称
    /// - Returns: 操作结果
    static func delete(name: String) -> Bool {
        return FileManager.delete(fromFile: name)
    }
}
