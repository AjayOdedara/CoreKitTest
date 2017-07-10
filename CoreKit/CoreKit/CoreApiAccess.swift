//
//  CoreApiAccess.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import p2_OAuth2
import CoreFoundation

public final class CoreApiAccess: ApiAccess {
    
    
    
    //  *******|| APPLICATION --Mobile First App-- API ||********
    
    //MARK: - Simple GET
    internal func SimpleGet(serviceId:String,  success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/users")!
        let request = NSMutableURLRequest(url: url as URL)
        self.performNormalGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON array back, so...
            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(dict)
            }else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     
     ---------------------------------
     Auth steps
     ---------------------------------
     
     Auth URL:
     http://coh-auth.azurewebsites.net/OAuth/Token
     
     Headers:
     Content-Type:	application/x-www-form-urlencoded
     
     Body Params:
     grant_type:password
     username:jigar@cllearworks.com
     password:456
     client_id:1BADD9C5-7FE9-44C5-96E7-2FFB6E54156C
     client_secret:A0239EE4-33AE-4249-8F1B-11392DF0D166
     */
    
    
/*
    internal func userAuthentication(userName:String,userPassword:String, clientId:String, clientSecret:String ,success:@escaping ([String: AnyObject])->Void, failure:((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: "http://coh-auth.azurewebsites.net/OAuth/Token")!
        let request = NSMutableURLRequest(url: url as URL)
        let headers = ["cache-control": "no-cache", "postman-token": "3160c4b6-5b12-f9fc-cb30-792431eeb6cf","content-type": "application/x-www-form-urlencoded"]
        
        let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
        postData.append("&username=\(userName)".data(using: String.Encoding.utf8)!)
        postData.append("&password=\(userPassword)".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=\(clientId)".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=\(clientSecret)".data(using: String.Encoding.utf8)!)

        request.allHTTPHeaderFields = headers
        request.httpMethod = "POST"
        request.httpBody = postData as NSData as Data
        
        
        self.performRegisterPostRequest(request: request as URLRequest, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                print(jsonString)
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func getMe(success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/me")!
//        let request = authenticator.request(forURL: url)
        let request = authenticator.oauth2.request(forURL: url as URL)
        
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func getTodaysTracks(success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/TodayTracks")!
        let request = authenticator._oauth2?.request(forURL: url as URL)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
      
        }, failure:failure)
    }
    
    internal func EmployeeIsCheckedIn(employeeeId:Int, success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Attendances/Today")!
        let request = authenticator._oauth2?.request(forURL: url as URL)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func employeeCheckIn(employeeeId:Int, success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Checkin")!
        var request = authenticator._oauth2?.request(forURL: url as URL)
        request?.httpMethod = "POST"
        self.performPostRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func employeeCheckOut(employeeeId:Int, success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Checkout")!
        var request = authenticator._oauth2?.request(forURL: url as URL)
        request?.httpMethod = "PUT"
        self.performPutRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    public func postUserAccount(firstName : String, lastName: String, email: String, contactNo: String, clientId: String, success:@escaping (String)->Void, failure:((NSError?)->Void)?)->Void {
        // Prepare the URL from Query paramters
        let params:NSDictionary = ["deviceId":UUID(), "firstName": firstName, "lastName": lastName, "email": email,"contact": contactNo,"applicationClientId": clientId]
        let urlString = self.apiRoot + "/v1/Employees/Register"
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)//urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: encodedUrl!)
        
        let request = NSMutableURLRequest(url: url! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        var request = authenticator._oauth2?.request(forURL: url! as URL)
        if let data = self.dictionaryToJsonData(dictionary: params){
            request.httpBody = data as Data
            request.httpMethod = "POST"
            
            self.performRegisterPostRequest(request: request as URLRequest, success:{ (jsonString) in
                // expecting a JSON dictionary back, so...
                if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                    dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                    success(jsonString)
                } else {
                    failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
                }
                }, failure:failure)
        }
    }

    internal func employeeTodayTracks(tracksData:NSMutableArray, success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Tracks")!
        var request = authenticator.oauth2.request(forURL: url as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print("At upload Data \(tracksData)")
        if let data = self.arrayToJsonData(array: tracksData){
            request.httpBody = data as Data// = data
            self.performPostRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
                if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                    dict = CoreUtilities.removeNilFromArray(array: dict)
                    success(dict)
                } else {
                    failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
                }
            }, failure:failure)
        }
    }
    //MARK: -
    func updateEmployeeProfile(EmployeeProfile: User?, success: @escaping (Void) -> Void, failure: ((_ error: NSError?) -> Void)?) -> Void {
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me")
        let request = authenticator._oauth2?.request(forURL: url! as URL)//let request = authenticator.request(forURL: url!)
        print(EmployeeProfile?.toJson())
        if self.dictionaryToJsonData(dictionary: EmployeeProfile!.toJson()) != nil {
            //            request?.add(params: data)
            self.performPutRequest(request: request, success: { (jsonString) in
                success()
            }, failure: { (error) in
                if (error != nil) {
                    print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                    failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
                }
            })
        }
    }

    //MARK: -  Reports
    internal func getWeeklyReport(success:@escaping (AnyObject?)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Attendances/Reports/Weekly")!
        let request = authenticator.request(forURL:url)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if let dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                success(dict as AnyObject?)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func getMonthlyReport(success:@escaping (AnyObject?)->Void, failure:((NSError?) -> Void)?) -> Void{
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/3/Attendances/Reports/Monthly")!
        let request = authenticator.request(forURL:url)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            
            if let dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                success(dict as AnyObject?)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    internal func getYearlyReport(success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Attendances/Reports/Yearly")!
        let request = authenticator.request(forURL:url)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    //MARK: -  Change Device
        internal func changeDeviceRequest(deviceId:String, email:String, gmcId:String, apnId:String,  success: @escaping (JSONDictionary) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/DeviceChangeRequest")!
        let request = NSMutableURLRequest(url: url as URL)
        
        let postData = NSMutableData()
        postData.append("&deviceId=\(deviceId)".data(using: String.Encoding.utf8)!)
        postData.append("&email=\(email)".data(using: String.Encoding.utf8)!)
        postData.append("&gmcId=\(gmcId)".data(using: String.Encoding.utf8)!)
        postData.append("&apnId=\(apnId)".data(using: String.Encoding.utf8)!)
       
        request.httpMethod = "POST"
        request.httpBody = postData as NSData as Data
        self.performPostRequest(request: request as URLRequest, success:{ (jsonString) in
        // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    
    //MARK: - Leaves & Holidays
    // Get Leaves
    internal func getLeaves(success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Leaves")!
        let request = authenticator._oauth2?.request(forURL: url as URL)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
            
        }, failure:failure)
    }
    // Apply for Leave
    func applyForLeave(leaveDetail: NSDictionary,success: @escaping (Void) -> Void, failure: ((_ error: NSError?) -> Void)?) -> Void {
//        print(leaveDetail)
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Leaves")
        
        var request = authenticator.oauth2.request(forURL: url! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let data = self.dictionaryToJsonData(dictionary: leaveDetail ){
            request.httpMethod = "POST"
            request.httpBody = data as Data
            self.performPutRequest(request: request, success: { (jsonString) in
                success()
            }, failure: { (error) in
                if (error != nil) {
                    print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                    failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
                }
            })
        }
    }
    
    //Edit Leave Detail
    func updateLeaveDetail(leaveDetail: NSDictionary,success: @escaping (Void) -> Void, failure: ((_ error: NSError?) -> Void)?) -> Void {
//        print(leaveDetail)
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Leaves")
        
        var request = authenticator.oauth2.request(forURL: url! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //let request = authenticator.request(forURL: url!)
        
        if let data = self.dictionaryToJsonData(dictionary: leaveDetail){
            request.httpMethod = "PUT"
//            print(data)
            request.httpBody = data as Data
            self.performPutRequest(request: request, success: { (jsonString) in
                success()
            }, failure: { (error) in
                if (error != nil) {
                    print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                    failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
                }
            })
        }
    }
    
    // Cancel Leave Request
    func cancelLeaveRequest(leaveId: Int,success: @escaping (Void) -> Void, failure: ((_ error: NSError?) -> Void)?) -> Void {
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Leaves/\(leaveId)/Cancel")
        
        var request = authenticator.oauth2.request(forURL: url! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        self.performDeleteRequest(request: request, success: { (jsonString) in
            success()
        }) { (error) in
            if (error != nil) {
                print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
            }
        }
    }
    
    // Delete Leave Request
    func deleteLeaveRequest(leaveId: Int,success: @escaping (Void) -> Void, failure: ((_ error: NSError?) -> Void)?) -> Void {
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Leaves/\(leaveId)")
        
        var request = authenticator.oauth2.request(forURL: url! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "DELETE"
        self.performDeleteRequest(request: request, success: { (jsonString) in
            success()
        }) { (error) in
            if (error != nil) {
                print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
            }
        }
    }

    
    // Get Holidays
    internal func getHolidays(success: @escaping (JSONArray) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Holidays")!
        let request = authenticator._oauth2?.request(forURL: url as URL)
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
        }, failure:failure)
    }
    // POST User Image
    internal func employeeProfileImage(imageData:NSData?, type:String?, success: @escaping (String) -> Void, failure: ((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "/v1/Employees/Me/Image")!
        var request = authenticator.oauth2.request(forURL: url as URL)
        
        if type == "DELETE" {
            request.httpMethod = type
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }else{
            request.httpMethod = "POST"
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.setValue(contentType as String, forHTTPHeaderField: "Content-Type")
            request.httpBody = getImagegeUploadBody(imageData: imageData!) as Data
        }
        
        
        self.performPostRequest(request: request, success:{ (jsonString) in
                // expecting a JSON dictionary back, so...
                var descr: String = ""
                                                    if let something = jsonString as String?{
                        descr = something
                    }
                    descr = descr.replacingOccurrences(of: "\"", with: "")
                if (descr == "") {
                    descr = "Error code "
                    failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
                }else{
                     success(descr)
                }
            
        }, failure:failure)
    }

    func getImagegeUploadBody(imageData:NSData) -> NSMutableData{
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        
        //  println("Content Type \(contentType)")
        
        let body = NSMutableData()
        
        // Title
        body.append(NSString(format: "\r\n--%@\r\n",boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append("cllearworks".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
        
        // Image
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageData as Data)
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)

        return body
        
    }
    
    public func getImageThumbnail(imagePath: String, success:@escaping (AnyObject?) -> Void, failure:((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: "\(imagePath)")
        
        let request = authenticator.oauth2.request(forURL: url! as URL)
        
        self.performGetRequest(request: request, success: { (jsonString) in
//            if var dict = CoreUtilities.JSONParseArray(jsonString: jsonString as NSString) {
//                dict = CoreUtilities.removeNilFromArray(array: dict)
                success(jsonString as AnyObject)
//            } else {
//                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
//            }w

        }, failure: { (error) in
            if (error != nil) {
                //print("!!!!!\nError Code: \(error!.code)\nError userInfo:\(error!.userInfo)\n!!!!!!")
                failure!(NSError(domain: ApiErrorDomain, code: error!.code, userInfo:  error!.userInfo))
            }
        })
    }
    

    
    /*  let url = NSURL(string: "http://coh-auth.azurewebsites.net/OAuth/Token")!
     let request = NSMutableURLRequest(url: url as URL)
     let headers = ["cache-control": "no-cache", "postman-token": "3160c4b6-5b12-f9fc-cb30-792431eeb6cf","content-type": "application/x-www-form-urlencoded"]
     
     let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
     postData.append("&username=\(userName)".data(using: String.Encoding.utf8)!)
     postData.append("&password=\(userPassword)".data(using: String.Encoding.utf8)!)
     postData.append("&client_id=\(clientId)".data(using: String.Encoding.utf8)!)
     postData.append("&client_secret=\(clientSecret)".data(using: String.Encoding.utf8)!)
     
     request.allHTTPHeaderFields = headers
     request.httpMethod = "POST"
     request.httpBody = postData as NSData as Data
     
     
     self.performRegisterPostRequest(request: request as URLRequest, success:{ (jsonString) in
     // expecting a JSON dictionary back, so...
     if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
     dict = CoreUtilities.removeNilFromDictionary(dict: dict)
     success(dict)
     } else {
     print(jsonString)
     failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
     }
     }, failure:failure)
*/

    

    //  *******|| BUNDESLIGA APP API ||********
    
    //MARK: - Get
    internal func getAllTeamsData(success:@escaping ([String: AnyObject])->Void, failure:((NSError?) -> Void)?) -> Void {
        
        let url = NSURL(string: self.apiRoot + "teams")!
        var request = authenticator._oauth2?.request(forURL: url as URL)//let request = NSMutableURLRequest()//authenticator.request(forURL:url)
        request?.url = url as URL
        request?.setValue("d9ed70c9da4e4e298201d6df975ded1e", forHTTPHeaderField: "X-Auth-Token")
        
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
            }, failure:failure)
    }

    internal func getTeamsData(urlString : String, success:@escaping ([String: AnyObject])->Void, failure: ((NSError?) -> Void)?) -> Void
    {

        let url = NSURL(string: urlString)!
        var request = authenticator._oauth2?.request(forURL: url as URL)//let request = NSMutableURLRequest()//authenticator.request(forURL:url)
        request?.url = url as URL
        request?.setValue("d9ed70c9da4e4e298201d6df975ded1e", forHTTPHeaderField: "X-Auth-Token")
        
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
            }, failure:failure)
    }
    internal func getImage(urlString : String, success:@escaping ([String: AnyObject])->Void, failure: ((NSError?) -> Void)?) -> Void
    {
        
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        var request = authenticator._oauth2?.request(forURL: url! as URL)//let request = NSMutableURLRequest()//authenticator.request(forURL:url)
        request?.url = url! as URL
        request?.setValue("d9ed70c9da4e4e298201d6df975ded1e", forHTTPHeaderField: "X-Auth-Token")
        
        self.performGetRequest(request: request, success:{ (jsonString) in
            // expecting a JSON dictionary back, so...
            if var dict = CoreUtilities.JSONParseDictionary(jsonString: jsonString as NSString) {
                dict = CoreUtilities.removeNilFromDictionary(dict: dict)
                success(dict)
            } else {
                failure?(NSError(domain: ApiErrorDomain, code: 999, userInfo: [NSLocalizedDescriptionKey:"Unexpected response from server"]))
            }
            }, failure:failure)
    }
    */
    
}
