//
//  CoreRepository.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation

open class CoreRepository : Repository {

    override init(apiRoot:String) {
        super.init(apiRoot: apiRoot)
    }
    
    lazy private var api:CoreApiAccess = {
        let theApi = CoreApiAccess(apiRoot:self.apiRoot)
        return theApi
    }()
    
    
    open func simpleGet(serviceId:String, onCompletion:@escaping ((UsersData)->Void), onError:((NSError?)->Void)?) -> Void {
      
        self.api.SimpleGet(serviceId: "", success: { (response) in
            let SampleList = UsersData(jsonDict: response)
            onCompletion(SampleList)
        }) { (error) -> Void in
                if let error=error, let failure=onError {
                    failure(error)
                }
        }
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//  *******|| APPLICATION --Mobile First App-- API ||********
    /*
    //Client Authentication
    open func userAuthentication(userName:String,userPassword:String, clientId:String, clientSecret:String , onCompletion:@escaping ((JSONDictionary)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.userAuthentication(userName: userName,userPassword:userPassword, clientId:clientId, clientSecret:clientSecret , success: { response -> Void in
            
            onCompletion(response)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    
    // GET User
    open func getMe(onCompletion:@escaping ((User)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getMe(success: { response -> Void in
            let user = User(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    
    // Get TodaysTrack
    open func getTodaysTrack(onCompletion:@escaping ((TodaysTrackModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getTodaysTracks(success: { (response) in
            let trackDetail = TodaysTrackModel(jsonDict: response)
            onCompletion(trackDetail)
            }) { (error) -> Void in
                if let error=error, let failure=onError {
                    failure(error)
                }
        }
    }
    // Employee-Is-CheckIn
    open func employeesIsCheckedIn(empId:Int, onCompletion:@escaping ((EmployeeIsCheckedIn)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.EmployeeIsCheckedIn(employeeeId: empId, success:{ response -> Void in
            let user = EmployeeIsCheckedIn(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    //    Check-In
    open func employeeCheckIn(empId:Int, onCompletion:@escaping ((EmployeeCheckIn)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.employeeCheckIn(employeeeId: empId, success:{ response -> Void in
            let user = EmployeeCheckIn(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    //    Check-Out
    open func employeeCheckOut(empId:Int, onCompletion:@escaping ((EmployeeCheckOut)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.employeeCheckOut(employeeeId: empId, success:{ response -> Void in
            let user = EmployeeCheckOut(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    
    // EMP Tracks
    open func employeeTodayTracks(tracksData:NSMutableArray, onCompletion:@escaping ((UserTrackModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.employeeTodayTracks(tracksData: tracksData, success:{ response -> Void in
            let user = UserTrackModel(jsonDict: response)
            onCompletion(user)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    
    //Employee Update Profile
    open func updateEmployeeProfile(employeeProfile: User?, onCompletion:@escaping ((Void) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.updateEmployeeProfile(EmployeeProfile: employeeProfile, success: { (success) in
            onCompletion()
        }) { (error) in
            onError?(error)
        }
    }
    
    //MARK: -  Reports
    //Weekly Report
    public func getWeeklyReport(onCompletion:@escaping ((WeeklyReportModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getWeeklyReport(success: { (data) in
            let me = WeeklyReportModel(jsonDict:data as! JSONArray)
            onCompletion(me)
        }) { (error) -> Void in
            if let error=error, let failure=onError {
                failure(error)
            }
        }
    }
    
    // MonthlyReport
    public func getMonthlyReport(onCompletion:@escaping ((MonthlyReportModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getMonthlyReport(success: { (data) in
            let me = MonthlyReportModel(jsonDict:data as! JSONArray)
            onCompletion(me)
        }) { (error) -> Void in
            if let error=error, let failure=onError {
                failure(error)
            }
        }
    }
    
    //Yearly Report
    public func getYearlyReport(onCompletion:@escaping ((YearlyReport)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getYearlyReport(success: { response -> Void in
            let report = YearlyReport(jsonDict: response)
            onCompletion(report)
        }, failure: {
            (error) -> Void in
            onError?(error)
        });
    }
    
    // Change Device request

    open func changeDevice(deviceId:String, email:String,  gmcId:String,  apnId:String, onCompletion:@escaping ((DeviceChangeRequest)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.changeDeviceRequest(deviceId: deviceId, email: email, gmcId: gmcId, apnId: apnId, success: { (response) in
            let user = DeviceChangeRequest(jsonDict: response)
            onCompletion(user)
        }) { (error) in
            onError!(error)
        }
    }
    
    //MARK: - Leaves And Holidays
    //Get Leaves
    open func getLeaves(onCompletion:@escaping ((LeavesModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getLeaves(success: { (response) in
             let leaveDetail = LeavesModel(jsonDict: response)
             onCompletion(leaveDetail)
        }) { (error) in
            if let error=error, let failure=onError {
                failure(error)
            }
        }
    }
    // Post Leaves
    public func applyForLeave(leaveData: NSDictionary, onCompletion:@escaping ((Void) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.applyForLeave(leaveDetail: leaveData, success: { (data) in
            onCompletion()
        }) { (error) in
            onError?(error)
        }
    }
    
    // Put Leaves
    public func editLeaveDetail(leaveData: NSDictionary, onCompletion:@escaping ((Void) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.updateLeaveDetail(leaveDetail: leaveData, success: { (data) in
            onCompletion()
        }) { (error) in
            onError?(error)
        }
    }
    // Cancel Leave 
    public func cancelLeaveRequest(leaveId: Int, onCompletion:@escaping ((Void) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.cancelLeaveRequest(leaveId: leaveId, success: { (data) in
            onCompletion()
        }) { (error) in
            onError?(error)
        }
    }
    
    // Delete Leave 
    public func deleteLeaveRequest(leaveId: Int, onCompletion:@escaping ((Void) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.deleteLeaveRequest(leaveId: leaveId, success: { (data) in
            onCompletion()
        }) { (error) in
            onError?(error)
        }
    }

    //getHolidays
    open func getHolidays(onCompletion:@escaping ((HolidaysModel)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getHolidays(success: { (response) in
            let holiday = HolidaysModel(jsonDict: response)
            onCompletion(holiday)
        }) { (error) in
            if let error=error, let failure=onError {
                failure(error)
            }
        }
    }
    
    // EMP Image Post
    
    open func employeeProfileImageUpload(imageData:NSData,type:String, onCompletion:@escaping ((String)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.employeeProfileImage(imageData: imageData, type: type, success: { (responseString) in
//            let holiday = HolidaysModel(jsonDict: response)
            onCompletion(responseString)
        }) { (error) in
            if let error=error, let failure=onError {
                failure(error)
            }
        }
    }

    

//  *******|| BUNDESLIGA APP API ||********
    open func getAllTeamsData(onCompletion:@escaping ((JSONDictionary)->Void), onError:((NSError?)->Void)?) -> Void {
        self.api.getAllTeamsData(success: { response -> Void in
            
            onCompletion(response)
            }, failure: {
                (error) -> Void in
            onError?(error)
        });
    }
    open func getTeamDetail(urlString:String , onCompletion: @escaping ((JSONDictionary) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.getTeamsData(urlString: urlString, success: { response -> Void in
            
            onCompletion(response)
            }, failure: {
                (error) -> Void in
            onError?(error)
        });
    }
    open func getImage(urlString:String , onCompletion: @escaping ((JSONDictionary) -> Void), onError:((NSError?) -> Void)?) -> Void {
        self.api.getImage(urlString: urlString, success: { response -> Void in
            
            onCompletion(response)
            }, failure: {
                (error) -> Void in
                onError?(error)
        });
    }
    
    func base64ToByteArray(base64String: String) -> [UInt8] {
        if let nsdata = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            var bytes = [UInt8](repeating: 0, count: nsdata.length)
            nsdata.getBytes(&bytes)
            return bytes
        }
        return [UInt8]() // Invalid input
    }
    
    public func getImageThumbnail(imagePath: String, onCompletion:@escaping ((UIImage) -> Void), onError: ((NSError?) -> Void)?) -> Void {
        
        self.api.getImageThumbnail(imagePath: imagePath, success: { response -> Void in
            
            let imageThumbnailData = ImageThumbnail(jsonDict:response as! JSONDictionary)
            
            let thumbnailDataString = imageThumbnailData.thumbnailData
            let thumbnailData = self.base64ToByteArray(base64String: thumbnailDataString!)
            
            let headerDataString = CoreConstants.thumbnailHeaders[thumbnailData.first!]
            
            let footerDataString = "/9k="
            
            let headerData = self.base64ToByteArray(base64String: headerDataString!)
            let footerData = self.base64ToByteArray(base64String: footerDataString)
            
            var buff = [UInt8]()
            
            buff.append(contentsOf: headerData)
            buff.append(contentsOf: thumbnailData[3...thumbnailData.count-1])
            buff.append(contentsOf: footerData)
            
            buff[164] = thumbnailData[1]
            buff[166] = thumbnailData[2]
            
            let height = thumbnailData[2]
            let width = thumbnailData[1]
            
            let hypotenuse = sqrt(Double(height) * Double(height) + Double(width) + Double(width))
            let radius = round(hypotenuse/50)
            
            let imageData = NSData(bytes: buff, length: buff.count)
            
            let baseThumbnailImage = UIImage(data: imageData as Data)
            
            let thumbnailImage = baseThumbnailImage!.applyBlurWithRadius(
                blurRadius: CGFloat(radius),
                tintColor: nil,
                saturationDeltaFactor: 1.0,
                maskImage: nil
            )
            
            onCompletion(thumbnailImage!)
            
        }, failure: {
            (error) -> Void in
            onError?(error)
        });
    }

    
    // MARK: - Create & Upate Realm Model DB
    func createUpdateDB(withListing listingDict: JSONDictionary) {
        
//        //|| This will create Teams Object in a Few lines ||
//        if let featureItems = listingDict["teams"] as? JSONArray {
//            for item in featureItems {
//                let realm = try! Realm()
//                try! realm.write {
//                    realm.create(UserBeacon.self, value: listingDict, update: true)
//                }
//            }
//        }
    }
    
    */


}
