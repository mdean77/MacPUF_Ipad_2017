//
//  Ventilator.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 5/28/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation

struct Ventilator {
	var PEEP = 0.0			// positive end expiratory pressure
	var NARTI = 1				// flag to indicate spontaneous ventilation
	// If zero then ventilator is ON
	
	// The following variables have not been used but will be used in future.
	// These are explicitly ventilator setting, not physiologic parameters.
	var rate:Int = 15							// Simplifies cycle time to 4 seconds
	var tidalVolume:Int = 450
	var flow:Double = 16.875
	var inspTime:Double = 1.6			// Assumes 40% of cycle is inspiration
	var expTime:Double = 2.4			// 4 seconds minus I time
	var ieRatio:Double = 0.667		// Simple arithmetic
	var FiO2:Double = 20.93
	
	// I am not sure HOW I will use these variables but I think will make more
	// clinically relevant ventilator report.
	
	func on() -> Bool{
		return NARTI == 0 ? true : false
	}
	
	func off() -> Bool{
		return NARTI == 0 ? false : true
	}
	
	mutating func turnOn(){
		NARTI = 0
	}
	
	mutating func turnOff(){
		NARTI = 1
	}
	
	func description() -> String{
		if (NARTI == 1) { return String(format:"\n\nVentilator off.  Natural ventilation, no PEEP.")
		}
		else
		{return String(format:"\nVentilator on. PEEP = %2.0f    Inspiratory time = %4.1f secs   I:E = %4.2f",PEEP, inspTime, ieRatio)
		}
	}
}
