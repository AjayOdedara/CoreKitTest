//
//  CoreConfig.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import MapKit

public class CoreConfig {
    
    let defaults = UserDefaults.standard
    let selectedAppMap = UserDefaults.standard.object(forKey: "SelectedAppMap")
    
    /// Mobile configuration pertaining to the Application
    public var mobileConfig: MobileConfig?
//    /// Mobile UI configuration pertaining to the current place selected.
//    public var placeMobileUIConfig: MobileUIConfig?
//    /// Mobile Menu pertaining to the current place selected.
//    public var placeMobileMenu: MobileMenu?
//    /// Mobile Mobile Theme pertaining to the current place selected.
//    public var placeMobileTheme: MobileTheme?
//    /// Place configuration pertaining to the current place selected.
//    public var placeConfig: PlaceConfig?
    
    
    public static let sharedInstance = CoreConfig()
    private init() {}
    
    
    public func objectForPlistKey(key:String) -> AnyObject {
        return Bundle.main.object(forInfoDictionaryKey: key)! as AnyObject
    }
    
    private func selectedAppMapHasObjectForKey(key:String) -> AnyObject? {
        /*
        if selectedAppMap != nil && (selectedAppMap as AnyObject).object(key) != nil {
            return (selectedAppMap! as AnyObject).objectForKey(key)!
        }
        return nil*/
        if selectedAppMap != nil && (selectedAppMap as AnyObject).object(forKey: key) != nil{
            return (selectedAppMap as AnyObject).object(forKey: key) as AnyObject
        }
        return nil
    }
}


// MARK - Properties
extension CoreConfig {
    public func mobileAppId() -> Int {
        return objectForPlistKey(key: "MobileAppID").integerValue
    }
    public func currentKeyChainAccessToken() -> String {
        return UserDefaults.standard.string(forKey: "accessToken") ?? ""
    }

    public func currentClientId() -> Int {
        return UserDefaults.standard.integer(forKey: "currentClientId") 
    }
    
    public func currentUserEmail() -> String {
        return UserDefaults.standard.string(forKey: "currentUserEmail") ?? ""
    }
    public func isUserActive() -> Bool {
        return UserDefaults.standard.bool(forKey: "isActive")
    }
    
    // For User Check In Check Out Data
    public func isEmployeeCheckedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: "isEmployeeCheckedIn")
    }
    public func FirstCheckedInTime() -> NSDate {
        if (UserDefaults.standard.value(forKey: "FirstCheckedInTime") != nil){
            return (UserDefaults.standard.value(forKey: "FirstCheckedInTime") as! NSDate)
        }
        return NSDate()
        
    }
    public func isEmployeeCheckedOut() -> Bool {
        return UserDefaults.standard.bool(forKey: "isEmployeeCheckedOut")
    }

    // Beacons
    public func totalBeacons() -> Int {
        let count = UserDefaults.standard.integer(forKey: "totalBeacons") as Int
        if count < 0  {
            return  0
        }
        return count
    }
    public func inRangeBeacons() -> Int {
        let totalCount = totalBeacons()
        
        let count = UserDefaults.standard.integer(forKey: "inRangeBeacons") as Int
        if count < 0 || count > totalCount {
            return  0
        }
        return count
    }
    public func outOfRangeBeacons() -> Int {
        let totalCount = totalBeacons()
        
        let count = UserDefaults.standard.integer(forKey: "outOfRangeBeacons") as Int
        if count < 0  || count > totalCount {
            return  0
        }
        return count
    }
    
    public func isFirstForEnter() -> Bool {
        return  UserDefaults.standard.bool(forKey: "isFirstForEnter")
    }

    public func buletoothStatus() -> Bool {
        return  UserDefaults.standard.bool(forKey: "buletoothStatus")
    }

    
    public func monsProduction() -> Bool {
        return objectForPlistKey(key: "Production").boolValue
    }
    public func defaultColor() -> UIColor {
        return mobileConfig?.defaultColor ?? UIColor.init(hexString: "#009cd8")!
    }
    
    
    
}
