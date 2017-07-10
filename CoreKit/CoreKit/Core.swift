//
//  Core.swift
//  CllearWorksCoreKit
//
//  Created by CllearWorks Dev on 5/20/15.
//  Copyright (c) 2015 CllearWorks. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String:AnyObject]
public typealias JSONArray = [AnyObject]

public let ApiErrorDomain = "com.CllearWorks.core.error"
public let NonBreakingSpace = "\0x00a0"

public let ConnectLogUserOutNotification = "ConnectLogUserOutNotification"
public let DidRegisterNotification = "DidRegisterNotification"
public let DidRegisterNotificationFailedOnSend = "DidRegisterNotificationFailedOnSend"
public let DidFailRegisterNotification = "DidFailRegisterNotification"
public let ConnectSelectedPlaceChangedNotification = "ConnectSelectedPlaceChangedNotification"
public let ConnectOpenedFromHandoff = "ConnectOpenedFromHandoff"
public let ConnectOpenedFromNotification = "ConnectOpenedFromNotification"
public let CWRequestDidTimeOutNotification = "CWRequestDidTimeOutNotification"
public let CMLoginWasSuccessful = "CMLoginWasSuccessful"
public let CMContinueAsGuestSuccessful = "CMContinueAsGuestSuccessful"

public let CWLogoutWasSuccessful = "CWLogoutWasSuccessful"
public let CWUserReAuth = "CWUserReAuth"

public let CWUpdateUserPhoto = "CWUpdateUserPhoto"
public let CWNoBeacons = "CWNoBeacons"
public let CWUserLogout = "CWUserLogout"
public let CWCheckedInTrack = "CWCheckedInTrack"
public let CWCheckedOutTrack = "CWCheckedOutTrack"
public let CWBeaconsUpdateLocation = "CWBeaconsUpdateLocation"
public let CWBeaconsAppKill = "CWBeaconsAppKill"
public let CWUserNotificationReminder = "CWUserNotificationReminder"
public let CWApplyForLeaveNotification = "CWApplyForLeave"
public let CWUserBluetoothStatus = "CWUserBluetoothStatus"
public let CWUserBluetoothOn = "CWUserBluetoothOn"

