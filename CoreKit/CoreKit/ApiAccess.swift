//
//  ApiAccess.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation
import p2_OAuth2

public enum ApiMethod:String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

open class ApiAccess : NSObject , URLSessionDataDelegate, URLSessionDelegate{
    
    typealias downloadTaskCompletionHandler = (URLSessionTask?, NSURL?, NSError?) -> Void
    
    public let apiRoot:String;
    public let authenticator:Authenticator = Authenticator.sharedInstance
    private static var numberOfCallsToSetVisible = 0
    private static var hasRequestedRefreshToken = false
    private static var outstandingTasks = [String:URLSessionTask]()
    private static var backgroundTasks = [URLSessionTask:downloadTaskCompletionHandler]()
    private static var requests = [NSMutableURLRequest]()

    
    public init(apiRoot:String) {
        self.apiRoot = apiRoot
    }
    
    public final func performGetRequest(request:URLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
//        request?.httpMethod = "GET"
        //Apply the culture to All CllearWorks GET Request.
       /* if(request?.URL != nil){
            let languageCode = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)! as! String
            let urlString = (request?.URL?.absoluteString)!
            var finalUrlString = ""
            if urlString.containsString("example.com") {
                if urlString.containsString("?") {
                    finalUrlString = urlString + "&culture=\(languageCode)"
                } else {
                    finalUrlString = urlString + "?culture=\(languageCode)"
                }
                
                request?.URL = NSURL(string: finalUrlString)
            }
        }*/
        
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
    public final func performPutRequest(request:URLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
//        request?.httpMethod = "PUT"
//        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
    public final func performPostRequest(request:URLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
//        request?.httpMethod = "POST"
//        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
    public final func performPostRequest(request:URLRequest?,body:NSData, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
//        request?.httpMethod = "POST"
//        request?.httpBody = body as Data
//        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
    public final func performDeleteRequest(request:URLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
//        request?.httpMethod = "DELETE"
        performRequest(theRequest: request, failOn401:false, success: success, failure: failure)
    }
    
//  MARK: - NORMAL GET/POST REQUEST
    public final func performNormalPostRequest(request:NSMutableURLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        print(ApiMethod.POST.rawValue)
        request?.httpMethod = ApiMethod.POST.rawValue
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performSpecificRequest(theRequest: request! as URLRequest, failOn401:false, success: success, failure: failure)
    }
    public final func performNormalGetRequest(request:NSMutableURLRequest?, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        print(ApiMethod.POST.rawValue)
        request?.httpMethod = ApiMethod.GET.rawValue
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performSpecificRequest(theRequest: request! as URLRequest, failOn401:false, success: success, failure: failure)
    }
    
    
    
    private func setNetworkActivityIndicatorVisible(setVisible:Bool){
        if(setVisible){
            ApiAccess.numberOfCallsToSetVisible += 1
            print("Number of Calls Incremented to: \(ApiAccess.numberOfCallsToSetVisible)")
        } else {
            if(ApiAccess.numberOfCallsToSetVisible >= 1){
                ApiAccess.numberOfCallsToSetVisible -= 1
                print("Number of Calls Decremented to: \(ApiAccess.numberOfCallsToSetVisible)")
            }
        }
        
        print("Number of Calls: \(ApiAccess.numberOfCallsToSetVisible)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = ApiAccess.numberOfCallsToSetVisible > 0
    }
    
    private func cancelAllCurrentRequests(){
        ApiAccess.outstandingTasks.removeAll()
    }
//  MARK: - PERFORM REQUEST WITH AUTH
    public final func performRequest(theRequest:URLRequest?, failOn401:Bool? = false, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        if theRequest == nil {
            failure?( NSError(domain: NSURLErrorDomain, code: -999, userInfo: nil)) // treat it like a cancel
            return
        }
        
        var request = theRequest!
        //return performFakeGet(request,success:success,failure:failure)
        let url = request.url!
        let minusQs = url.host! + url.path
        print("calling \(minusQs)")
        
        if let previousTask = ApiAccess.outstandingTasks[minusQs] {
            previousTask.cancel()
            self.setNetworkActivityIndicatorVisible(setVisible: false)
        }
        /*
        let req = NSMutableURLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: .default)
         */
    
        request.timeoutInterval = 60
        
        let task = authenticator.oauth2.session.dataTask(with: theRequest!) { data, response, error in
            
            var returnedError:Error?;
            var returnedErrorTest:NSError?;
            
            ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
            if let errors = error {
                print(errors)
                returnedError = error
                returnedErrorTest = error! as Error as NSError
                print("Error Domain\(returnedErrorTest?.code)")
                if returnedErrorTest?.code != -999 || returnedErrorTest?.code != -1001{
                    print(returnedErrorTest?.description)
                }
                
//                if let error = error.asOAuth2Error { // check if it was cancelled  error.domain != NSURLErrorDomain && error.code != -999
                    ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                    self.setNetworkActivityIndicatorVisible(setVisible: false)
//                }
            }
            else {
                
                    ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                    if let httpResponse = response as! HTTPURLResponse?{
                        
                        let statusCode = httpResponse.statusCode
                        var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        
                        print("\n*****-----------*****\nURL: \(response!.url!)\nStatus Code:\(statusCode)\n*****-----------*****\n")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CWUserReAuth), object: nil)
                        if statusCode == 200 || statusCode == 201 {
                            DispatchQueue.main.async() {
                                if let response = responseString{
                                    success(response as String)
                                }else{
                                    responseString = "N/A"
                                    success(responseString as! String)
                                }
                            }
                        }else if statusCode == 204 { // no content
                            DispatchQueue.main.async() {
                                success("No Content")
                            }
                        }else if statusCode == 401 {
                            // unauthorized. Use one retry.
                            if let fail = failOn401, fail == true {
                                // send the notification that we've been forced out
                                print("Got a 401 when we're supposed to fail on 401, so log them out")
                                print(responseString ?? "Error")
                                DispatchQueue.main.async(execute: { () -> Void in
                                    failure!(error! as NSError)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ConnectLogUserOutNotification), object: nil)
                                    return
                                })
                            }
                        }else{
                            // Other Status Code
                            var descr: String = ""
                            
                            do {
                                let errorDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                                if let something = errorDict["errorMessage"] as? String{
                                    descr = something
                                }
                                descr = descr.replacingOccurrences(of: "[\"", with: "")
                                descr = descr.replacingOccurrences(of: "\"]", with: "")
                            } catch let error as NSError {
                                print("\n**********\nURL: \(response!.url!)\nJson Serialization error: \(error.localizedDescription)\nStatus Code:\(statusCode)\n***********\n")
                            }
                            
                            if (descr == "") {
                                descr = "Error code \(statusCode): '\(responseString!)'"
                            }
                            returnedError = NSError(domain: ApiErrorDomain, code: statusCode, userInfo:[NSLocalizedDescriptionKey:descr])
                            DispatchQueue.main.async(execute: { () -> Void in
                                failure!(returnedError! as NSError)
                                return
                            })
                            
                        }
                        self.setNetworkActivityIndicatorVisible(setVisible: false)
                        
                
                    }
                
                
            }
            
            if let anError = returnedError, let failure = failure {
                self.setNetworkActivityIndicatorVisible(setVisible: false)
                DispatchQueue.main.async(execute: { () -> Void in
                    failure(anError as NSError)//failure(anError.isCancel() ? nil : anError)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CWRequestDidTimeOutNotification), object: nil)
                })
            }
            
        }
        
        ApiAccess.outstandingTasks[minusQs] = task
        task.resume()
        self.setNetworkActivityIndicatorVisible(setVisible: true)
      
    }
    //  MARK: - PERFORM SIMPLE REQUESTS
    public final func performSpecificRequest(theRequest:URLRequest?, failOn401:Bool? = false, success:@escaping (String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        if theRequest == nil {
            failure?( NSError(domain: NSURLErrorDomain, code: -999, userInfo: nil)) // treat it like a cancel
            return
        }
        
        var request = theRequest!
        //return performFakeGet(request,success:success,failure:failure)
        let url = request.url!
        let minusQs = url.host! + url.path
        print("calling \(minusQs)")
        
        if let previousTask = ApiAccess.outstandingTasks[minusQs] {
            previousTask.cancel()
            self.setNetworkActivityIndicatorVisible(setVisible: false)
        }
        
//        let req = NSMutableURLRequest(url:url)
//        let config = URLSessionConfiguration.default
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        
        let session = URLSession(configuration: .default)
        request.timeoutInterval = 60
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if error == nil {
                //JSONSerialization
            }
            
            var returnedError:Error?;
            
            ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
            if let error = error {
                print(error)
                returnedError = error
                
                //                if let error = error.asOAuth2Error { // check if it was cancelled
                ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                self.setNetworkActivityIndicatorVisible(setVisible: false)
                //                }
            }
            else {
                
                ApiAccess.outstandingTasks.removeValue(forKey: minusQs)
                if let httpResponse = response as! HTTPURLResponse?{
                    
                    let statusCode = httpResponse.statusCode
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    print("\n**********\nURL: \(response!.url!)\nStatus Code:\(statusCode)\n***********\n")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CWUserReAuth), object: nil)
                    if statusCode == 200 || statusCode == 201 {
                        DispatchQueue.main.async() {
                            success(responseString! as String)
                        }
                    }
                    else if statusCode == 204 { // no content
                        DispatchQueue.main.async() {
                            success("No Content")
                        }
                    }else{
                        // Other Status Code
                        var descr: String = ""
                        
                        do {
                            let errorDict = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                            descr = (errorDict["errorMessage"] as? String)!
                            descr = descr.replacingOccurrences(of: "[\"", with: "")
                            descr = descr.replacingOccurrences(of: "\"]", with: "")
                        } catch let error as NSError {
                            print("\n**********\nURL: \(response!.url!)\nJson Serialization error: \(error.localizedDescription)\nStatus Code:\(statusCode)\n***********\n")
                        }
                        
                        if (descr == "") {
                            descr = "Error code \(statusCode): '\(responseString!)'"
                        }
                        returnedError = NSError(domain: ApiErrorDomain, code: statusCode, userInfo:[NSLocalizedDescriptionKey:descr])
                        DispatchQueue.main.async(execute: { () -> Void in
                            failure!(returnedError! as NSError)
                            return
                        })
                        
                       
                        
                    }
                    
                    self.setNetworkActivityIndicatorVisible(setVisible: false)
                    
                }
            }
            if let anError = returnedError, let failure = failure {
                self.setNetworkActivityIndicatorVisible(setVisible: false)
                DispatchQueue.main.async(execute: { () -> Void in
                    failure(anError as NSError)// failure(anError.isCancel() ? nil : anError)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: CWRequestDidTimeOutNotification), object: nil)
                })
            }
            
        }
        ApiAccess.outstandingTasks[minusQs] = task
        task.resume()
        self.setNetworkActivityIndicatorVisible(setVisible: true)
    }
    
    private var _backgroundSession:URLSession? = nil
    internal func backgroundSession() -> URLSession{
        if let session = _backgroundSession{
            return session
        }
        
        let config = URLSessionConfiguration.background(withIdentifier: "com.CllearWorks.whatever")
        let session = URLSession(configuration: config)//.default)//let session : URLSession?//URLSession(configuration: config, delegate: self, delegateQueue: nil)queue
        _backgroundSession = session
//        session.delegateQueue
        return session//(configuration: config, delegate: self, queue: nil)
    }
    
    public final func performBackgroundGetRequest(request:NSMutableURLRequest?, success:(String)->Void, failure:((NSError?) -> Void)?) -> Void {
        request?.httpMethod = "GET"
        
        //Apply the culture to All CllearWorks GET Request.
        if(request?.url != nil){
            let languageCode = "US_en"//NSLocale.currentLocale.objectForKey(NSLocaleLanguageCode)! as! String
            let urlString = (request?.url?.absoluteString)!
            var finalUrlString = ""
            if urlString.contains("CllearWorks.com"){
                
                if urlString.contains("?") {
                    finalUrlString = urlString + "&culture=\(languageCode)"
                } else {
                    finalUrlString = urlString + "?culture=\(languageCode)"
                }
            }
            /*if urlString.containsString("CllearWorks.com") {
                if urlString.containsString("?") {
                    finalUrlString = urlString + "&culture=\(languageCode)"
                } else {
                    finalUrlString = urlString + "?culture=\(languageCode)"
                }
            }*/
            
            request?.url = NSURL(string: finalUrlString) as URL?
        }
        
        
        
        performBackgroundRequest(theRequest: request, success: success, failure: failure)
    }
    public final func performBackgroundPutRequest(request:NSMutableURLRequest?, success:(String)->Void, failure:((NSError?) -> Void)?) -> Void {
        request?.httpMethod = "PUT"
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performBackgroundRequest(theRequest: request, success: success, failure: failure)
    }
    public final func performBackgroundPostRequest(request:NSMutableURLRequest?, success:(String)->Void, failure:((NSError?) -> Void)?) -> Void {
        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        performBackgroundRequest(theRequest: request, success: success, failure: failure)
    }
    public final func performBackgroundDeleteRequest(request:NSMutableURLRequest?, success:(String)->Void, failure:((NSError?) -> Void)?) -> Void {
        request?.httpMethod = "DELETE"
        performBackgroundRequest(theRequest: request, success: success, failure: failure)
    }
    
    public final func performBackgroundRequest(theRequest:NSMutableURLRequest?, success:(String)->Void, failure:((NSError?) -> Void)?) -> Void {
        
        if theRequest == nil {
            failure?( NSError(domain: NSURLErrorDomain, code: -999, userInfo: nil)) // treat it like a cancel
            return
        }
        
        let request = theRequest!
        
        let url = request.url!
        let minusQs = url.host! + "/" + url.path
        print("calling \(minusQs)")
        
        if let previousTask = ApiAccess.outstandingTasks[minusQs] {
            previousTask.cancel()
        }
        
        request.timeoutInterval = 60
        
        let session = self.backgroundSession()
        let task = session.downloadTask(with: request as URLRequest)
        
        ApiAccess.outstandingTasks[minusQs] = task
        
        task.resume()
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)" as AnyObject)
        
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL){
        
    }
    
//    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
//        print("session \(session) has finished the download task \(dataTask) of URL ).")
//    }
//    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//        if error == nil {
//            print("session \(session) download completed")
//        } else {
//            print("session \(session) download failed with error \(String(describing: error?.localizedDescription))")
//        }
//    }
//    
//    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        print(session)
//    }
////    open func URLSession(session: URLSession, downloadTask task: URLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
////    {
////        print("session \(session) has finished the download task \(task) of URL \(location).")
////    }
////    
//    open func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//        print("session \(session) download task \(downloadTask) wrote an additional \(bytesWritten) bytes (total \(totalBytesWritten) bytes) out of an expected \(totalBytesExpectedToWrite) bytes.")
//    }
//    
////    open func URLSession(session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
////        if error == nil {
////            print("session \(session) download completed")
////        } else {
////            print("session \(session) download failed with error \(String(describing: error?.localizedDescription))")
////        }
////    }
    
    public func queryStringFromDictionary(params:NSDictionary) -> String {
        if (params.count > 0) {
            var qs = ""
            let index = 0
            
            for (key, value) in params {
                let stringValue = String(describing: value) 
                
                // Allowed character set
                var allowedChar = NSCharacterSet.urlQueryAllowed//NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy()
                allowedChar.remove(charactersIn: "&")//removeCharactersInString("&")
                
                let encodedK = (key as AnyObject).addingPercentEncoding(withAllowedCharacters: allowedChar)//(key as AnyObject).addingPercentEncoding((allowedChar as NSCharacterSet) as CharacterSet)
                let encodedV = stringValue.addingPercentEncoding(withAllowedCharacters: allowedChar)//stringValue.stringByAddingPercentEncodingWithAllowedCharacters(allowedChar as! NSCharacterSet)
                
                if index > 0 { qs += "&" }
                qs += "\(encodedK!)=\(encodedV!)"
            }
            
            return qs
        } else {
            return ""
        }
    }
    
    public func dictionaryToJsonData(dictionary:NSDictionary) -> NSData?{
        var err: NSError?
        do {
            let json = try JSONSerialization.data(withJSONObject: dictionary, options:JSONSerialization.WritingOptions(rawValue: 0))
            return json as NSData
        } catch let error1 as NSError {
            err = error1
            let error = err?.description ?? "nil"
            NSLog("ERROR: Unable to serialize json, error: %@", error)
            abort()
        }
    }
    
    public func arrayToJsonData(array:NSArray) -> NSData?{
        var err: NSError?
        do {
            let json = try JSONSerialization.data(withJSONObject: array, options:JSONSerialization.WritingOptions(rawValue: 0))
            return json as NSData
        } catch let error1 as NSError {
            err = error1
            let error = err?.description ?? "nil"
            NSLog("ERROR: Unable to serialize json, error: %@", error)
            abort()
        }
    }
}
