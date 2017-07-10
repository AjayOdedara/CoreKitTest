//
//  Extensions.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 6/9/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import SAMKeychain

public func >(lhs:NSDate, rhs:NSDate) -> Bool {
    return lhs.timeIntervalSinceReferenceDate > rhs.timeIntervalSinceReferenceDate
}

public func getDateFromString(dateString:String) -> NSDate?{
    
    let stringDate = dateString
    var startDate:NSDate?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // "2017-04-06T09:58:05.69Z"
    dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone // Same time as shown
    
    //Save Dates
    //        if (stringDate.characters.last != "Z") {
    //            stringDate = stringDate+"Z"
    //        }
    
    if let _ = dateFormatter.date(from: stringDate) {
        startDate = dateFormatter.date(from: stringDate)! as NSDate
    }else{
        
    }
    return startDate
}
public func getTempDateFromString(dateString:String) -> NSDate?{
    
    let stringDate = dateString
    var startDate:NSDate?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // "2015-10-06T15:42:34Z"
    dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone // Same time as shown
    
    //Save Dates
    //        if (stringDate.characters.last != "Z") {
    //            stringDate = stringDate+"Z"
    //        }
    
    if let _ = dateFormatter.date(from: stringDate) {
        startDate = dateFormatter.date(from: stringDate)! as NSDate
    }else{
        
    }
    return startDate
}
public func getUserOutDateFromString(dateString:String) -> NSDate?{
    
    let stringDate = dateString
    var startDate:NSDate?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz" // "2015-10-06T15:42:34Z"
    dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone // Same time as shown
    
    //Save Dates
    //        if (stringDate.characters.last != "Z") {
    //            stringDate = stringDate+"Z"
    //        }
    
    if let _ = dateFormatter.date(from: stringDate) {
        startDate = dateFormatter.date(from: stringDate)! as NSDate
    }else{
        
    }
    return startDate
}
public func getDateFrom3MillisecondTime(dateString:String) -> NSDate?{
    
    let stringDate = dateString
    var startDate:NSDate?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz" // "2015-10-06T15:42:34Z"
    dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone // Same time as shown
    
    //Save Dates
    //        if (stringDate.characters.last != "Z") {
    //            stringDate = stringDate+"Z"
    //        }
    
    if let _ = dateFormatter.date(from: stringDate) {
        startDate = dateFormatter.date(from: stringDate)! as NSDate
    }else{
        
    }
    return startDate
}
public func getDateFrom1MillisecondTime(dateString:String) -> NSDate?{
    
    let stringDate = dateString
    var startDate:NSDate?
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.Sz" // "2015-10-06T15:42:34Z"
    dateFormatter.timeZone = NSTimeZone(name:"UTC")! as TimeZone // Same time as shown
    
    //Save Dates
    //        if (stringDate.characters.last != "Z") {
    //            stringDate = stringDate+"Z"
    //        }
    
    if let _ = dateFormatter.date(from: stringDate) {
        startDate = dateFormatter.date(from: stringDate)! as NSDate
    }else{
        
    }
    return startDate
}


public func UUID() -> String {
    
    let bundleName = Bundle.main.infoDictionary!["CFBundleName"] as! String
    let accountName = "userUniqueIdentity"
    
    var applicationUUID = SAMKeychain.password(forService: bundleName, account: accountName)
    
    if applicationUUID == nil {
        
        applicationUUID = UIDevice.current.identifierForVendor?.uuidString//UIDevice.currentDevice.identifierForVendor!.UUIDString
        // Save applicationUUID in keychain without synchronization
        let query = SAMKeychainQuery()
        query.service = bundleName
        query.account = accountName
        query.password = applicationUUID
        query.synchronizationMode = SAMKeychainQuerySynchronizationMode.no
        
        do {
            try query.save()
        } catch let error as NSError {
            print("KeychainQuery Exception: \(error)")
        }
    }
    
    return applicationUUID!
}


public  func ISOStringFromDate(date: NSDate) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")! as TimeZone
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    
    return dateFormatter.string(from: date as Date).appending("Z")//dateFormatter.stringFromDate(date as Date).stringByAppendingString("Z")
}

public  func dateFromISOString(string: String) -> NSDate {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
    dateFormatter.timeZone = NSTimeZone.local
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    
    return dateFormatter.date(from: string)! as NSDate
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}
extension NSError {
    func isCancel() -> Bool {
        return (self.code == -999) && (self.domain == NSURLErrorDomain)
    }
    
    func isTimeout() -> Bool {
        return (self.code == -1001) && (self.domain == NSURLErrorDomain)
    }
}

public extension String {
	var lastPathComponent: String {
		get {
			return (self as NSString).lastPathComponent
		}
	}
	
	var pathExtension: String {
		get {
			return (self as NSString).pathExtension
		}
	}

	var stringByDeletingLastPathComponent: String {
		get {
			return (self as NSString).deletingLastPathComponent
		}
	}
	
	var stringByDeletingPathExtension: String {
		get {
			return (self as NSString).deletingPathExtension
		}
	}
	
	var pathComponents: [String] {
		get {
			return (self as NSString).pathComponents
		}
	}
	
	func stringByAppendingPathComponent(path: String) -> String {
		let nsSt = self as NSString
		return nsSt.appendingPathComponent(path)
	}
	
	func stringByAppendingPathExtension(ext: String) -> String? {
		let nsSt = self as NSString
		return nsSt.appendingPathExtension(ext)
	}
   	
}
extension UIViewController {
    public func callOnMainThread(callback: ((Void) -> Void)) {
        if Thread.isMainThread {
            callback()
        }
        else {
            DispatchQueue.main.sync(execute: {
                callback()
            })
        }
    }
}


extension UIColor {
    class func colorWithHex(hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        
        return UIColor( red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha:CGFloat(alpha) )
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
