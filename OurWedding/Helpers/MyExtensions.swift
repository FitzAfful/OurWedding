//
//  MyExtensions.swift
//  OurWedding
//
//  Created by Fitzgerald Afful on 07/10/2018.
//  Copyright © 2018 oasiswebsoft. All rights reserved.
//

import Foundation
import SystemConfiguration

public func isConnectedToNetwork() -> Bool {
	var zeroAddress = sockaddr_in()
	zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
	zeroAddress.sin_family = sa_family_t(AF_INET)
	
	let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
		$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
			SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
		}
	}
	
	var flags = SCNetworkReachabilityFlags()
	if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
		return false
	}
	let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
	let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
	return (isReachable && !needsConnection)
}

extension Date {
	func toMillis() -> Int64! {
		return Int64(self.timeIntervalSince1970 * 1000)
	}
}

extension CountableClosedRange
{
	var randomInt: Int
	{
		get
		{
			var offset = 0
			
			if (lowerBound as! Int) < 0   // allow negative ranges
			{
				offset = abs(lowerBound as! Int)
			}
			
			let mini = UInt32(lowerBound as! Int + offset)
			let maxi = UInt32(upperBound   as! Int + offset)
			
			return Int(mini + arc4random_uniform(maxi - mini)) - offset
		}
	}
}

func randomString(length: Int) -> String {
	
	let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	let len = UInt32(letters.length)
	
	var randomString = ""
	
	for _ in 0 ..< length {
		let rand = arc4random_uniform(len)
		var nextChar = letters.character(at: Int(rand))
		randomString += NSString(characters: &nextChar, length: 1) as String
	}
	
	return randomString
}
