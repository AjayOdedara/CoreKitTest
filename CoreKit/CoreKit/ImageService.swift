//
//  ImageService.swift
//  CllearworksCoreKit
//
//  Created by Tim Sneed on 6/22/15.
//  Copyright (c) 2015 Cllearworks. All rights reserved.
//

import UIKit

public class ImageService: NSObject {
    
	public enum ImageMode:String {
		case Uniform = "Uniform"
		case Zoom = "Zoom"
		case Pad = "Pad"
		
		var description : String {
			get {
				return self.rawValue
			}
		}
	}
    
    public enum VerticalCrop: String {
        case Center = "Center"
        case Top = "Top"
        case Bottom = "Bottom"
        
        var verticalValue : String {
            get {
                return self.rawValue
            }
        }
    }
    
    public enum HorizontalCrop: String {
        case Center = "Center"
        case Left = "Left"
        case Right = "Right"
        
        var horizontalValue : String {
            get {
                return self.rawValue
            }
        }
    }
    
    public func buildImageString(imageName:String, imageMode:ImageMode, size:CGSize, scale:CGFloat)-> NSURL{
		return NSURL(string: CustomCoreKit.repository().apiRoot + "/v1/Images?imagePath=\(imageName)&mode=\(imageMode.description)&width=\(Int(size.width * scale))&height=\(Int(size.height * scale))")!
	}
    
    public func buildImageString(imageName:String, imageMode:ImageMode, size:CGSize)-> NSURL{
        return NSURL(string: CustomCoreKit.repository().apiRoot + "/v1/Images?imagePath=\(imageName)&mode=\(imageMode.description)&width=\(Int(size.width))&height=\(Int(size.height))")!
    }
    
    //removed the imagemode to get full image
    public func buildImageString(imageName:String, size:CGSize)-> NSURL{
        return NSURL(string: CustomCoreKit.repository().apiRoot + "/v1/Images?imagePath=\(imageName)")!
    }
    
    public func buildImageString(imageName:String, imageMode:ImageMode, size:CGSize, scale:CGFloat, cropAnchorV:VerticalCrop, cropAnchorH: HorizontalCrop)-> NSURL{
        return NSURL(string: CustomCoreKit.repository().apiRoot + "/v1/Images?imagePath=\(imageName)&mode=\(imageMode.description)&width=\(Int(size.width * scale))&height=\(Int(size.height * scale))&cropAnchorV=\(cropAnchorV.verticalValue)&cropAnchorH=\(cropAnchorH.horizontalValue)")!
    }
    
    public func buildImageUrl(urlString: String, imageMode: ImageMode, size: CGSize) -> NSURL {
        let scale = UIScreen().scale
        return NSURL(string: urlString + "&mode=\(imageMode)&width=\(Int(size.width * scale))&height=\(Int(size.height * scale))")!
    }
    
}
