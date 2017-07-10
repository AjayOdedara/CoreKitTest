//
//  CoreUtilities.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import DateTools

public class CoreUtilities {
    
    private static var dateFormatter:DateFormatter? = nil
    private static var dateFormatterOnceToken:dispatch_time_t = 0

    public class func JSONParseDictionary(jsonString: NSString) -> [String: AnyObject]? {
        if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
            if let dictionary = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [String: AnyObject] {
                return dictionary
            }
        }
        return nil
    }
    
    public class func JSONParseArray(jsonString: NSString) -> [AnyObject]? {
        if let data = jsonString.data(using: String.Encoding.utf8.rawValue) {
            if let array = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)))  as? [AnyObject] {
                return array
            }
        }
        return nil
    }
    
    public class func cleanEscapesFromJSONString(jsonString: String) -> String?
    {
        let newString = jsonString.replacingOccurrences(of:"\"" , with: "")//stringByReplacingOccurrencesOfString("\"", withString: "")
        return newString
    }
    
    public class func removeNilFromDictionary(dict:[String: AnyObject]) -> [String: AnyObject] {
        var newDict = [String: AnyObject]()
        
        for key in dict.keys {
            let value:AnyObject = dict[key]!
           
            if let _ = value as? NSNull {
                // ignore it
            } else if let value = value as? [String: AnyObject] {
                newDict[key] = self.removeNilFromDictionary(dict: value) as AnyObject
            } else if let value = value as? [AnyObject] {
                newDict[key] = self.removeNilFromArray(array: value) as AnyObject
            } else {
                newDict[key] = value
            }
        }
        
        return newDict
    }
    
    public class func removeNilFromArray(array:[AnyObject]) -> [AnyObject] {
        var newArray = [AnyObject]()
        
        for value in array {
            
            if let _ = value as? NSNull {
                // ignore it
            } else if let value = value as? [String: AnyObject] {
                newArray.append( self.removeNilFromDictionary(dict: value) as AnyObject )
            } else if let value = value as? [AnyObject] {
                newArray.append( self.removeNilFromArray(array: value) as AnyObject )
            } else {
                newArray.append( value )
            }
        }
        
        return newArray
    }

    public class func dateFromMs(etaMs:Float) -> NSDate {
        let ti = TimeInterval(etaMs / 1000.0)
        return NSDate(timeIntervalSince1970:ti)
    }
    
    public class func msFromDate(date:NSDate) -> Float {
        let ti = date.timeIntervalSince1970
        return Float(ti) * 1000.0
    }
    /*
    public class func formattedDate(date:NSDate, dateStyle:NSDateFormatterStyle? = .NoStyle, timeStyle:NSDateFormatterStyle? = .NoStyle) -> String {
        
        dispatch_once(&Int(dateFormatterOnceToken), {
            let formatter = NSDateFormatter()
            formatter.timeZone = NSTimeZone.systemTimeZone()
            formatter.locale = NSLocale.autoupdatingCurrentLocale()
            
            self.dateFormatter = formatter
        })
        
        let formatter = self.dateFormatter!
        formatter.dateStyle = dateStyle ?? .NoStyle
        formatter.timeStyle = timeStyle ?? .NoStyle
        
        return formatter.stringFromDate(date)
    }
    
    public class func absTimeDueString(eta:NSDate) -> String {
        // TODO: This is a hack that will not work Localized.
        // A more permanent solution is required.
        if eta.isEarlierThan(NSDate() as Date!) {
            let due = eta.timeAgo(since: NSDate() as Date!, numericDates: true, numericTimes: true).lowercaseString
            var displayable = due.stringByReplacingOccurrencesOfString(" ago", withString: "", options: NSStringCompareOptions(rawValue: 0), range: nil)
			displayable = "Overdue by " + displayable
            return displayable
        } else {
            let reverseDue = NSDate().timeAgoSinceDate(eta as Date!, numericDates: true, numericTimes: true).lowercaseString
            var displayable = reverseDue.stringByReplacingOccurrencesOfString(" ago", withString: "", options: NSString.CompareOptions(rawValue: 0), range: nil)
			displayable = "Due in " + displayable
            return displayable
        }
	}
    
    public class func absTimeDueShortString(eta:NSDate) -> String {
        var displayable = absTimeDueString(eta: eta)
        displayable = displayable.stringByReplacingOccurrencesOfString("minutes", withString: "min", options: NSStringCompareOptions(rawValue: 0), range: nil)
        displayable = displayable.stringByReplacingOccurrencesOfString("minute", withString: "min", options: NSStringCompareOptions(rawValue: 0), range: nil)
        return displayable
    }*/
}
