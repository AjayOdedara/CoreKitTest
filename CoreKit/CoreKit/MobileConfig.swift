//
//  MobileConfig.swift
//  CllearworksCoreKit
//
//  Created by James McPherson on 5/7/16.
//  Copyright © 2016 Cllearworks. All rights reserved.
//

import Foundation
import UIKit

public class MobileConfig {
    
    public var parentReachGroup: Int
    public var hotelBrand: Int
    public var userType: String
    public var defaultColor: UIColor?
    public var darkColor: UIColor?
    public var usePropertyGroups: Bool
    public var notificationType: String
    public var meridianAppId: String
    public var welcomeImage = [String]()
    public var reservationsUrl: String
    public var bookingUrl: String
    public var headerImage: String
    public var defaultSearchRadius: Int
//    public var welcomeImages = [WelcomeImage]()
    public var placeScopeId: Int
    
    //Custom Setter
    public var appMetric: Metric
    
    init(jsonDict: [String: AnyObject]) {
        let reachGroup = jsonDict["reach_group_scope"] as? [String: AnyObject]
        let hotelBrand = jsonDict["hotel_brand_scope"] as? [String: AnyObject]
        let userType = jsonDict["user_type"] as? [String: AnyObject]
        let color = jsonDict["color"] as? [String: AnyObject]
        let usePropertyGroups = jsonDict["use_property_groups"] as? [String: AnyObject]
        let notificationType = jsonDict["notification_type"] as? [String: AnyObject]
        let meridian = jsonDict["meridian"] as? [String: AnyObject]
        let reservations_url = jsonDict["reservations_url"] as? [String: AnyObject]
        let booking_url = jsonDict["booking_url"] as? [String: AnyObject]
        let header_image = jsonDict["header_image"] as? [String: AnyObject]
        let search = jsonDict["search"] as? [String: AnyObject]
        if let array =  jsonDict["welcome_image"] as? [String: AnyObject] {
            for item in array{
                self.welcomeImage.append(String(describing: item.1))
            }
        }
        /*
        let welcomeImages = jsonDict["images"]?["welcome"]??["model"] as? [[String:AnyObject]] ?? [[String:AnyObject]]()
        for image in welcomeImages {
            self.welcomeImages.append(WelcomeImage(jsonDict: image))
        }
        */
        self.parentReachGroup = reachGroup?["default_value"] as? Int ?? 0
        self.hotelBrand = hotelBrand?["default_value"] as? Int ?? 0
        self.userType = userType?["default_value"] as? String ?? "Guest"
        self.defaultColor = UIColor(hexString: color?["default_value"] as? String ?? "#009cd8")
        self.darkColor = UIColor(hexString: color?["dark_color"] as? String ?? "#000000")
        self.usePropertyGroups = usePropertyGroups?["default_value"] as? Bool ?? false
        self.notificationType = notificationType?["default_value"] as? String ?? "Legacy"
        let meridianAppIdStr = meridian?["app_id"]
        if(meridianAppIdStr != nil) {
            self.meridianAppId = "\(meridianAppIdStr!)"
        }else{
            self.meridianAppId = ""
        }
        self.reservationsUrl = reservations_url?["default_value"] as? String ?? ""
        self.bookingUrl = booking_url?["default_value"] as? String ?? ""
        self.headerImage = header_image?["default_value"] as? String ?? ""
        self.defaultSearchRadius = search?["radius"] as? Int ?? 0
        self.appMetric = .Fahrenheit // By Default
        
        self.placeScopeId = jsonDict["place_scope"]?["default_value"] as? Int ?? 0
        if(self.placeScopeId != 0){
            UserDefaults.standard.set(self.placeScopeId, forKey: "currentPropertyId")
        }
    }
    
}

/**
 By default set to "Fahrenhiet" and can be changed universally within the app
 
 */
public enum Metric: String {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.startIndex//let start = hexString.startIndex.advancedBy(1)
            let hexColor = hexString.substring(from: start)//substringFromIndex(start)
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        
        return nil
    }
}
