//
//  Authenticator.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/26/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import p2_OAuth2

@objc public class Authenticator : NSObject {
    
    public static let sharedInstance = Authenticator()
    private override init() { } // keep anyone from creating us, and force use of sharedInstace
    
    public static var clientId:String? {
        willSet {
            if clientId != nil {
			print("Authenticator.clientId may only be set once.", terminator: "")
                abort()
            }
        }
    }
    public static var clientSecret:String? {
        willSet {
            if clientSecret != nil {
                print("Authenticator.clientSecret may only be set once.", terminator: "")
                abort()
            }
        }
    }
    public static var oauthRoot:String? {
        willSet {
            if oauthRoot != nil {
                print("Authenticator.oauthRoot may only be set once.", terminator: "")
                abort()
            }
        }
    }
    
    public static var redirectUris:String? {
        willSet {
            if redirectUris != nil{
                print("Authenticator.redirectUris may only be set once.", terminator: "")
                abort()
            }
        }
    }
    
    public var oauth2:OAuth2{
        get{
            if _oauth2 == nil{
                print("OAuth2 must have value")
                abort()
            }
            return _oauth2!
        }
        set{
            _oauth2 = newValue;
            
//			let keyChainItem = Keychain//GenericKey(keyName: "token", value: newValue.accessToken)
//			let keychain = self.getKeychain()
//			keychain.update(keyChainItem)
        }
    }
    
    public var _oauth2:OAuth2?
	
    public class func handleRedirectURL(url: NSURL) {
		do{
			try sharedInstance.oauth2.handleRedirectURL(url as URL)
		}
		catch{
			print("error")
		}
    }
    
    public class func request(forURL:NSURL) -> URLRequest? {
        return sharedInstance.request(forURL: forURL)
    }

    public func request(forURL:NSURL) -> URLRequest? {
        if let access = oauth2.accessToken, !access.isEmpty {
            var request = URLRequest(url: forURL as URL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")//set(header: "application/x-www-form-urlencoded", to: "Content-Type")//
            request.setValue("application/json", forHTTPHeaderField: "Accept")//request.set(header: "application/json", to: "Accept")//
            request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")//request.set(header: "Bearer \(access)", to: "Authorization")//
            let fields = request.allHTTPHeaderFields
            var _:AnyObject? = fields!["Authorization"] as AnyObject

            return request
        }
        return nil
    }
    
       
    public func resignRequest(request:OAuth2AuthRequest) -> OAuth2AuthRequest? {
        if let access = oauth2.accessToken, !access.isEmpty {
            request.set(header: "Bearer \(access)", to: "Authorization")//request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")
            print("RESIGN REQUEST\nACCESS TOKEN: \(access)")
            return request
        }
        else {
            NSLog("Cannot sign request, access token is empty")
            return nil
        }
    }
	
	public class func requestWithOtherGrant(forURL:NSURL, grant:OAuth2) -> URLRequest? {
		return sharedInstance.requestWithOtherGrant(forURL: forURL, grant:grant)
	}

	public func requestWithOtherGrant(forURL:NSURL, grant:OAuth2) -> URLRequest? {
		let request = grant.request(forURL: forURL as URL)
		return request
	}

    public class func forgetTokens() {
        sharedInstance.forgetTokens();
    }
    
    public func forgetTokens() {
        oauth2.forgetTokens()
    }
    

//    authorizeEmbedded
    
    public func authorize(presentor:UIViewController, callback: (_ wasFailure: Bool, _ error: NSError?) -> Void) {
//        oauth2.afterAuthorizeOrFailure = callback
        oauth2.authConfig.authorizeContext = presentor
        oauth2.authConfig.authorizeEmbedded = true
        
        oauth2.authorizeEmbedded(from: presentor) { (data, error) in
            
            
        }
    

    }
    public func reauthorizeSilently(callback: (_ wasFailure: Bool, _ error: NSError?) -> Void) {
		//oauth2.forgetTokens()
//        oauth2.afterAuthorizeOrFailure = callback
        oauth2.authConfig.authorizeContext = nil
//        oauth2.authConfig.authorizeEmbedded = nil
        
        oauth2.authorize()
    }

//	private func getKeychain() -> Keychain {
//		let infoPlist = Bundle.main.infoDictionary!
//		let key = NSString(string: "CFBundleIdentifier")
//		let bundleId = infoPlist[key as String] as! String + "6"
//		return Keychain(serviceName: bundleId, accessMode: kSecAttrAccessibleAlways, group: nil)
//		
//	}
}

//extension OAuth2 {
//	public func request(forURL url: NSURL) -> OAuth2AuthRequest {
//		return OAuth2AuthRequest(url: url as URL)//(URL: url, cachePolicy: NSURLRequest.CachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 20)
//	}
//}
