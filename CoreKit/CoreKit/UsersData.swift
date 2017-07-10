//
//  UsersData.swift
//  CoreServicesKit
//
//  Created by AMIT on 05/07/17.
//  Copyright © 2017 acme. All rights reserved.
//

import Foundation
import UIKit

public class UsersData : NSObject, ToJson {
    
    
    public var allUser : [Users]?
    
    public init(jsonDict: JSONArray) {
        
        var values = [Users]()
        
        for items:JSONDictionary in (jsonDict as? [JSONDictionary])! {
            values.append(Users(jsonDict: items))
        }
        allUser = values
    }
    
    public func toJson() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        if let clientId = self.allUser{
            dictionary["firstName"] = clientId
        }
        return dictionary
    }

}

public class Users : NSObject{
    
    public var id:Int?
    public var name:String?
    public var username:String?
    public var email:String?
    public var phone:String?
    public var website:String?
    public var address : UsersAddress?
    public var company : UsersCompany?
    
    
    public var firstName:String?
    public var lastName:String?
    public var fullName:String? {
        get {
            if let fname = firstName {
                if let lname = lastName {
                    return "\(fname) \(lname)"
                } else {
                    return fname
                }
            } else if let lname = lastName {
                return lname
            } else {
                return nil
            }
        }
    }
    public init(jsonDict:JSONDictionary) {
        super.init()
        //        For all NSDate usage and for example of swiftDate Link> http://malcommac.github.io/SwiftDate/parse_create_dates.html#fromstring
        
        
        id          = jsonDict["id"] as? Int ?? 0
        username    = jsonDict["username"] as? String ?? ""
        email       = jsonDict["email"] as? String ?? ""
        phone       = jsonDict["phone"] as? String ?? ""
        website     = jsonDict["website"] as? String ?? ""
        firstName   = jsonDict["firstName"] as? String ?? ""
        lastName    = jsonDict["lastName"] as? String ?? ""
        
        
        var valuesAddress = [UsersAddress]()
        if let items = jsonDict["address"] as? [String: AnyObject]{
            valuesAddress.append(UsersAddress(jsonDict: items))
            address = valuesAddress.first
        }
        
        
        var valuesCompany = [UsersCompany]()
        if let items = jsonDict["company"] as? [String: AnyObject]{
            valuesCompany.append(UsersCompany(jsonDict: items))
            company = valuesCompany.first
        }
        
        
    }

}
public class UsersAddress : NSObject{
    
    public var street:Int?
    public var suite:String?
    public var city:String?
    public var zipcode:String?

    public init(jsonDict:JSONDictionary) {
        super.init()

        street      = jsonDict["street"] as? Int ?? 0
        suite       = jsonDict["suite"] as? String ?? ""
        city        = jsonDict["city"] as? String ?? ""
        zipcode     = jsonDict["zipcode"] as? String ?? ""
    }
    
}
public class UsersCompany : NSObject{
    
    public var name:Int?
    public var catchPhrase:String?
    public var bs:String?
    
    public init(jsonDict:JSONDictionary) {
        super.init()
        
        name            = jsonDict["street"] as? Int ?? 0
        catchPhrase     = jsonDict["catchPhrase"] as? String ?? ""
        bs              = jsonDict["bs"] as? String ?? ""
    }
    
}




/*
 
 {
 "id": 1,
 "name": "Leanne Graham",
 "username": "Bret",
 "email": "Sincere@april.biz",
    "address": {
        "street": "Kulas Light",
        "suite": "Apt. 556",
        "city": "Gwenborough",
        "zipcode": "92998-3874",
    "geo": {
        "lat": "-37.3159",
        "lng": "81.1496"
        }
    },
 "phone": "1-770-736-8031 x56442",
 "website": "hildegard.org",
 
    "company": {
        "name": "Romaguera-Crona",
        "catchPhrase": "Multi-layered client-server neural-net",
        "bs": "harness real-time e-markets"
    }
 },
 
 */
