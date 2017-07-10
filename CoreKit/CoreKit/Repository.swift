//
//  Repository.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 6/24/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation

open class Repository : NSObject {
    
    public let apiRoot:String
    
    public init(apiRoot:String) {
        self.apiRoot = apiRoot
    }
    /*
    public var me:User?{
        didSet {

            print("User set ")
        }
    }
    
    public var isEmpployeeCheckedIn:EmployeeIsCheckedIn?{
        didSet {
            print("User set to \(String(describing: isEmpployeeCheckedIn?.id))", terminator: "")
        }
    }
    public var employeeCheckIn:EmployeeCheckIn?{
        didSet {
            print("User set to \(String(describing: employeeCheckIn?.isPresent))", terminator: "")
        }
    }
    public var employeeCheckOut:EmployeeCheckOut?{
        didSet {
            print("User set to \(String(describing: employeeCheckOut?.id))", terminator: "")
        }
    }
    
    public var Data:Spices?{ // we can save this model also
        didSet {
            print("User set to \(Data?.id)", terminator: "")
        }
    }

    public var Week:WeeklyReportModel?{
        didSet{
             print("User set to \(Week?.WeekReport?.count)", terminator: "")
        }
    }
    public var Track:TodaysTrackModel?{
        didSet {
            print("User set to \(Track?.todaysTrack?.count)", terminator: "")
        }
    }
    public var Monthly:MonthlyReportModel?{
        didSet{
            print("User set to \(Monthly?.MonthReport?.count)", terminator: "")
        }
    }
    
    public var Yearly: YearlyReport?{
        didSet{
            print("User set to \(Yearly?.totalInTime)", terminator: "")
        }
    }
    
    public var deviceChange: DeviceChangeRequest?{
        didSet{
             print("User set to \(deviceChange?.email)", terminator: "")
        }
    }
    
    public var leaves: LeavesModel?{
        didSet{
            print("User set to ", terminator: "")
        }
    }
    public var holidaysList: HolidaysModel?{
        didSet{
            print("User set to ", terminator: "")
        }
    }
    */

}
