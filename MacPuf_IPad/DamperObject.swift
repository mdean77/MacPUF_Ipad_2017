//
//  DamperObject.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//
//	Metabolizer will inherit this function, as will Human.  Might be overkill to create
//	this base object but eliminates duplicating this function in two places.

import Foundation

class DamperObject {
	
	func dampChange(_ newValue:Double, oldValue:Double, dampConstant:Double) -> Double {
		return (newValue * dampConstant + oldValue)/(dampConstant + 1)
	}
	
}
