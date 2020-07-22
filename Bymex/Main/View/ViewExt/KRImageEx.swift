//
//  KRImageEx.swift
//  Bymex
//
//  Created by KarlLichterVonRandoll on 2020/4/10.
//  Copyright © 2020 KarlLichterVonRandoll. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    public func cornerRadius(_ bounds: CGRect) -> UIImage{
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: bounds.size.width, height: bounds.size.height), false, UIScreen.main.scale)
        //获取图形上下文
        let ctx = UIGraphicsGetCurrentContext()
        if ctx == nil {
            return self
        }
        //根据一个rect创建一个椭圆
        ctx!.addEllipse(in: bounds)
        //裁剪
        ctx!.clip()
        //将原照片画到图形上下文
        self.draw(in: bounds)
        //从上下文上获取剪裁后的照片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //图片压缩逻辑
    public func compressImage() -> Data{
        let imageSize = self.jpegData(compressionQuality: 1)!.count/1024
        var myImage = self
        if imageSize < 500{
            //如果小于500k,直接上传
            return myImage.jpegData(compressionQuality: 1)!
        }else{
            //取短边
            let width = myImage.size.width > myImage.size.height ? myImage.size.height:myImage.size.width
            if width <= 1080{
                //大于500k短边小于1080，直接上传
                return myImage.jpegData(compressionQuality: 1)!
            }else{
                //待压缩的Size
                let size: CGSize?
                //如果宽大于高
                if myImage.size.width > myImage.size.height{
                    size = CGSize.init(width: myImage.size.width*(1080/myImage.size.height), height: 1080)
                }else{
                    size = CGSize.init(width: 1080, height: myImage.size.height*(1080/myImage.size.width))
                }
                //尺寸压缩
                UIGraphicsBeginImageContext(size!)
                myImage.draw(in: CGRect.init(x: 0, y: 0, width: size!.width, height: size!.height))
                myImage = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
                
                if myImage.jpegData(compressionQuality: 1)!.count/1024 >= 500{
                    //尺寸压缩后还大于500k
                    for index in 1...5{
                        let rate = CGFloat(1) - 0.1*CGFloat(index)
                        let count = myImage.jpegData(compressionQuality: rate)!.count/1024
                        if count <= 500{
                            return myImage.jpegData(compressionQuality: rate)!
                        }
                        //系数0.5仍然大于500k上传
                        if index == 5{
                            return myImage.jpegData(compressionQuality: rate)!
                        }
                    }
                }else{
                    //尺寸压缩后还小于500k
                    
                    return myImage.jpegData(compressionQuality: 1)!
                }
            }
        }
        return myImage.jpegData(compressionQuality: 1)!
    }
    
    public static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x:0, y: 0,  width:size.width,height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }else {
            return UIImage()
        }
    }
    
    public static func getTextImage(drawText: String,size: CGSize) -> UIImage {
        let color = UIColor.ThemeLabel.colorDark
        let img = self.getImageWithColor(color: color, size: size)
        
        // Setup the font specific variables
        let textColor = UIColor.white
        let textFont = UIFont.ThemeFont.BodyBold
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(img.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            ]
        
        // Put the image into a rectangle as large as the original image
        img.draw(in: CGRect(x:0, y:0, width:img.size.width, height:img.size.height))
        
        let textSize = drawText.textSizeWithFont(textFont, width: img.size.width)
        
        // Create a point within the space that is as bit as the image
        let rect = CGRect(x:(img.size.width - textSize.width)/2, y:(img.size.height - textSize.height)/2, width:img.size.width, height:img.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            
            // End the context now that we have the image we need
            UIGraphicsEndImageContext()
            return newImage
        }else {
            return UIImage()
        }
    }
    
    /// 更改图片颜色
    func imageWithTintColor(color : UIColor) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        color.setFill()
        let bounds = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height)
        UIRectFill(bounds)
        self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1.0)
        
        if let tintedImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            return tintedImage
        }
        return self
    }

    
    /// 颜色image
    public static func exImage(color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UIImage {
    func saveImageToAlbum() {
        UIImageWriteToSavedPhotosAlbum(self, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let e = error as NSError? {
            print(e)
            EXAlert.showFail(msg: "保存成功")
        } else {
            EXAlert.showSuccess(msg: "保存成功")
        }
    }
}
