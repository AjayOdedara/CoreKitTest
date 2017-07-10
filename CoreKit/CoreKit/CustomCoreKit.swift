//
//  CllearWorksCoreKit.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 6/25/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation

public class CustomCoreKit: NSObject {
    
    public typealias T = CoreRepository
    var clientId:String? = ""
    var clientSecret:String? = ""
    var applicationId: String?
    var coreRepository:CoreRepository? = nil
    var config = CoreConfig.sharedInstance
    private static var sharedInstance:CustomCoreKit? = nil
    
    public static func repository()->CoreRepository {
        
        return sharedInstance!.coreRepository!  //sharedInstance?.coreRepository!
    }

    /// This is the main function where you need to set the Application Id needed to communicate with CllearWorks. This is provided by CllearWorks.
    /// If you are unsure of your Application Id, please visit/ email @CllearWorks Customer Service Team
    /// - parameter id: Application id string
    public static func setApplicationId(id: String) {
        sharedInstance!.applicationId = id
    }
    
    public static func getApplicationId() -> String {
        return sharedInstance!.applicationId!
    }
    
    
    public static func configure(apiRoot:String, clientId:String, clientSecret:String){
        if(sharedInstance != nil){
            NSException(name: NSExceptionName(rawValue: "Shared Instance"), reason: "configure already called", userInfo: nil).raise()
        }
        sharedInstance = CustomCoreKit()
        sharedInstance?.coreRepository = CoreRepository(apiRoot: apiRoot)
        sharedInstance?.clientId = clientId
        sharedInstance?.clientSecret = clientSecret
    }
    
}
