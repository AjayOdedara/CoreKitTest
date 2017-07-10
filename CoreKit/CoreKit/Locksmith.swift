//
//  Locksmith.swift
//
//  Created by CllearWorks Dev on 26/10/2014.
//  Copyright (c) 2014 Colour Coding. All rights reserved.
//

import Foundation
import Security

public let LocksmithErrorDomain = "com.locksmith.error"
public let LocksmithDefaultService = "com.locksmith.defaultService"


@objc public class Locksmith: NSObject {
	// MARK: Perform request
	public class func performRequest(request: LocksmithRequest) -> (NSDictionary?, NSError?) {
		let type = request.type
		//var result: Unmanaged<AnyObject>? = nil
		var result: AnyObject?
		var status: OSStatus?
		
		let parsedRequest: NSMutableDictionary = parseRequest(request: request)
		
		let requestReference = parsedRequest as CFDictionary
		
		switch type {
		case .Create:
			status = withUnsafeMutablePointer(to: &result) { SecItemAdd(requestReference, UnsafeMutablePointer($0)) }
		case .Read:
			status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(requestReference, UnsafeMutablePointer($0)) }
		case .Delete:
			status = SecItemDelete(requestReference)
		case .Update:
			status =  Locksmith.performUpdate(request: requestReference, result: &result)
		}
		
		if let status = status {
			let statusCode = Int(status)
			let error = Locksmith.keychainError(forCode: statusCode)
			var resultsDictionary: NSDictionary?
			
			if result != nil {
				if type == .Read && status == errSecSuccess {
					
					if let data = result as? NSData {
						// Convert the retrieved data to a dictionary
						resultsDictionary = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? NSDictionary
					}
				}
			}
			
			return (resultsDictionary, error)
		} else {
			let code = LocksmithErrorCode.TypeNotFound.rawValue
			let message = internalErrorMessage(forCode: code)
			return (nil, NSError(domain: LocksmithErrorDomain, code: code, userInfo: ["message": message]))
		}
	}
	
	private class func performUpdate(request: CFDictionary, result: inout AnyObject?) -> OSStatus {
		// We perform updates to the keychain by first deleting the matching object, then writing to it with the new value.
		SecItemDelete(request)
		// Even if the delete request failed (e.g. if the item didn't exist before), still try to save the new item.
		// If we get an error saving, we'll tell the user about it.
		
		let status: OSStatus = withUnsafeMutablePointer(to: &result) { SecItemAdd(request, UnsafeMutablePointer($0)) }
		return status
	}
	
	// MARK: Error Lookup
	enum ErrorMessage: String {
		case Allocate = "Failed to allocate memory."
		case AuthFailed = "Authorization/Authentication failed."
		case Decode = "Unable to decode the provided data."
		case Duplicate = "The item already exists."
		case InteractionNotAllowed = "Interaction with the Security Server is not allowed."
		case NoError = "No error."
		case NotAvailable = "No trust results are available."
		case NotFound = "The item cannot be found."
		case Param = "One or more parameters passed to the function were not valid."
		case Unimplemented = "Function or operation not implemented."
	}
	
	enum LocksmithErrorCode: Int {
		case RequestNotSet = 1
		case TypeNotFound = 2
		case UnableToClear = 3
	}
	
	enum LocksmithErrorMessage: String {
		case RequestNotSet = "keychainRequest was not set."
		case TypeNotFound = "The type of request given was undefined."
		case UnableToClear = "Unable to clear the keychain"
	}
	
	class func keychainError(forCode statusCode: Int) -> NSError? {
		var error: NSError?
		
		if statusCode != Int(errSecSuccess) {
			let message = errorMessage(code: statusCode)
			//            print("Keychain request failed. Code: \(statusCode). Message: \(message)")
			error = NSError(domain: LocksmithErrorDomain, code: statusCode, userInfo: ["message": message])
		}
		
		return error
	}
	
	// MARK: Private methods
	
	public class func internalErrorMessage(forCode statusCode: Int) -> NSString {
		switch statusCode {
		case LocksmithErrorCode.RequestNotSet.rawValue:
			return LocksmithErrorMessage.RequestNotSet.rawValue as NSString
		case LocksmithErrorCode.UnableToClear.rawValue:
			return LocksmithErrorMessage.UnableToClear.rawValue as NSString
		default:
			return "Error message for code \(statusCode) not set" as NSString
		}
	}
	
	private class func parseRequest(request: LocksmithRequest) -> NSMutableDictionary {
		var parsedRequest = NSMutableDictionary()
		
		var options = [String: AnyObject?]()
		options[String(kSecAttrAccount)] = request.userAccount as AnyObject
		options[String(kSecAttrAccessGroup)] = request.group as AnyObject
		options[String(kSecAttrService)] = request.service as AnyObject
		options[String(kSecAttrSynchronizable)] = request.synchronizable as AnyObject
		options[String(kSecClass)] = securityCode(securityClass: request.securityClass)
		if let accessibleMode = request.accessible {
			options[String(kSecAttrAccessible)] = accessible(accessible: accessibleMode)
		}
		
		for (key, option) in options {
			parsedRequest.setOptional(optional: option, forKey: key as NSCopying)
		}
		
		switch request.type {
		case .Create:
			parsedRequest = parseCreateRequest(request: request, inDictionary: parsedRequest)
		case .Delete:
			parsedRequest = parseDeleteRequest(request: request, inDictionary: parsedRequest)
		case .Update:
			parsedRequest = parseCreateRequest(request: request, inDictionary: parsedRequest)
		default: // case .Read:
			parsedRequest = parseReadRequest(request: request, inDictionary: parsedRequest)
		}
		
		return parsedRequest
	}
	
	private class func parseCreateRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
		
		if let data = request.data {
			let encodedData = NSKeyedArchiver.archivedData(withRootObject: data)
			dictionary.setObject(encodedData, forKey: kSecValueData as! NSCopying)//dictionary.setObject(encodedData, forKey: String(kSecValueData))
		}
		
		return dictionary
	}
	
	
	private class func parseReadRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
		dictionary.setOptional(optional: kCFBooleanTrue, forKey: kSecReturnData as! NSCopying)
		
		switch request.matchLimit {
		case .One:
			dictionary.setObject(kSecMatchLimitOne, forKey: kSecMatchLimit as! NSCopying)
		case .Many:
			dictionary.setObject(kSecMatchLimitAll, forKey: kSecMatchLimit as! NSCopying)//String(kSecMatchLimit))
		}
		
		return dictionary
	}
	
	private class func parseDeleteRequest(request: LocksmithRequest, inDictionary dictionary: NSMutableDictionary) -> NSMutableDictionary {
		return dictionary
	}
	
	private class func errorMessage(code: Int) -> NSString {
		switch code {
		case Int(errSecAllocate):
			return ErrorMessage.Allocate.rawValue as NSString
		case Int(errSecAuthFailed):
			return ErrorMessage.AuthFailed.rawValue as NSString
		case Int(errSecDecode):
			return ErrorMessage.Decode.rawValue as NSString
		case Int(errSecDuplicateItem):
			return ErrorMessage.Duplicate.rawValue as NSString
		case Int(errSecInteractionNotAllowed):
			return ErrorMessage.InteractionNotAllowed.rawValue as NSString
		case Int(errSecItemNotFound):
			return ErrorMessage.NotFound.rawValue as NSString
		case Int(errSecNotAvailable):
			return ErrorMessage.NotAvailable.rawValue as NSString
		case Int(errSecParam):
			return ErrorMessage.Param.rawValue as NSString
		case Int(errSecSuccess):
			return ErrorMessage.NoError.rawValue as NSString
		case Int(errSecUnimplemented):
			return ErrorMessage.Unimplemented.rawValue as NSString
		default:
			return "Undocumented error with code \(code)." as NSString
		}
	}
	
	private class func securityCode(securityClass: SecurityClass) -> CFString {
		switch securityClass {
		case .GenericPassword:
			return kSecClassGenericPassword
		case .Certificate:
			return kSecClassCertificate
		case .Identity:
			return kSecClassIdentity
		case .InternetPassword:
			return kSecClassInternetPassword
		case .Key:
			return kSecClassKey
		}
	}
	
    private class func accessible(accessible: Accessible) -> CFString{//Ref {
		switch accessible {
		case .WhenUnlock:
			return kSecAttrAccessibleWhenUnlocked
		case .AfterFirstUnlock:
			return kSecAttrAccessibleAfterFirstUnlock
		case .Always:
			return kSecAttrAccessibleAlways
		case .WhenPasscodeSetThisDeviceOnly:
			return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
		case .WhenUnlockedThisDeviceOnly:
			return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
		case .AfterFirstUnlockThisDeviceOnly:
			return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
		case .AlwaysThisDeviceOnly:
			return kSecAttrAccessibleAlwaysThisDeviceOnly
		}
	}
}

// MARK: Convenient Class Methods
extension Locksmith {
	public class func saveData(data: Dictionary<String, String>, forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) -> NSError? {
		let saveRequest = LocksmithRequest(userAccount: userAccount, requestType: .Create, data: data as NSDictionary, service: service)
		let (_, error) = Locksmith.performRequest(request: saveRequest)
		return error
	}
	
	public class func loadDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) -> (NSDictionary?, NSError?) {
		let readRequest = LocksmithRequest(userAccount: userAccount, service: service)
		return Locksmith.performRequest(request: readRequest)
	}
	
	public class func deleteDataForUserAccount(userAccount: String, inService service: String = LocksmithDefaultService) -> NSError? {
		let deleteRequest = LocksmithRequest(userAccount: userAccount, requestType: .Delete, service: service)
		let (_, error) = Locksmith.performRequest(request: deleteRequest)
		return error
	}
	
	public class func updateData(data: Dictionary<String, String>, forUserAccount userAccount: String, inService service: String = LocksmithDefaultService) -> NSError? {
		let updateRequest = LocksmithRequest(userAccount: userAccount, requestType: .Update, data: data as NSDictionary, service: service)
		let (_, error) = Locksmith.performRequest(request: updateRequest)
		return error
	}
	
	public class func clearKeychain() -> NSError? {
		// Delete all of the keychain data of the given class
		func deleteDataForSecClass(secClass: CFTypeRef) -> NSError? {
			let request = NSMutableDictionary()
			request.setObject(secClass, forKey: kSecClass as! NSCopying)//String(kSecClass))
			
			let status: OSStatus? = SecItemDelete(request as CFDictionary)
			
			if let status = status {
				let statusCode = Int(status)
				return Locksmith.keychainError(forCode: statusCode)
			}
			
			return nil
		}
		
		// For each of the sec class types, delete all of the saved items of that type
		let classes = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
		
		let errors: [NSError?] = classes.map({
			return deleteDataForSecClass(secClass: $0)
		})
		
		// Remove those that were successful, or failed with an acceptable error code
		let filtered = errors.filter({
			if let error = $0 {
				// There was an error
				// If the error indicates that there was no item with that sec class, that's fine.
				// Some of the sec classes will have nothing in them in most cases.
				return error.code != Int(errSecItemNotFound) ? true : false
			}
			
			// There was no error
			return false
		})
		
		// If the filtered array is empty, then everything went OK
		if filtered.isEmpty {
			return nil
		}
		
		// At least one of the delete operations failed
		let code = LocksmithErrorCode.UnableToClear.rawValue
		let message = internalErrorMessage(forCode: code)//internaler//internalErrorMessage(forCode: code)
		return NSError(domain: LocksmithErrorDomain, code: code, userInfo: ["message": message])
	}
}

// MARK: Dictionary Extensions
extension NSMutableDictionary {
	func setOptional(optional: AnyObject?, forKey key: NSCopying) {
		if let object: AnyObject = optional {
			self.setObject(object, forKey: key)
		}
	}
}
