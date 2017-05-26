//
//  Human.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

//  Note that Human is not a metabolizer object.  Only its component systems are metabolizers.
class Human: DamperObject{
    // Simulation parameters
    var totalSeconds = 0
    var simlt = 1
    var iterations = 0     // Valid value will be provided from simulation controller
    
    // Human parameters that are not body system specific
    var age = 40
    var weight = 70
    var height = 178
    var barometric = 760
    var BARRF = 713.01
    var DPG = 3.7843
    var Hgb = 14.8
    var Hct = 45.0
    var temperature = 37.0
    var male = 1
    var metabolicRate = 100
    var fitness = 28
    var XLACT = 0.0006
    var XC2PR = 45.4757
    var DPH = 7.3996
    var RCOAJ = 100
    var XRESP = 8.8777
		var veinDelay = Array(repeating: 0.0, count: 40)
	
    // Body systems of human
    let arteries: ArterialPool
	let heart: Heart
	let bag: Bag
	let venousPool: VenousPool
    //let brain:Brain
    //let tissues:Tissue
    //let ventilator:Ventilator
    //let lungs:Lung
	
	override init(){
		arteries = ArterialPool()
		heart = Heart()
		bag = Bag()
		venousPool = VenousPool()
        // brain = Brain()
        // tissues = Tissue()
        // ventilator = Ventilator()
        // lungs = Lung()
        
        arteries.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
        // lungs.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
        // tissues.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
        // brain.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
        
        for i in 1...10 {
            veinDelay[i-1] = venousPool.oxygenContent
            veinDelay[i+9] = venousPool.carbonDioxideContent
            veinDelay[i+19] = venousPool.bicarbonateContent
            veinDelay[i+29] = XC2PR
        }
	}
	
	func setIterations(_ newIterations:Int){
		iterations = newIterations
	}
	
	// This will eventually be what is printed out on each cycle - the individual line report
	func cycleReport(){
		let scale = 120.0
		let lineWidth = 72.0
		let factor = lineWidth/scale
		let po2 = arteries.pO2 < scale ? Int(arteries.pO2*factor) : Int(lineWidth)
		let pco2 = arteries.pCO2 < scale ? Int(arteries.pCO2*factor) : Int(lineWidth)
		// let vent = lungs.totalVentilation	// NEED LUNGS FIRST
		// let rate = lungs.respiratoryRate
		
		let seconds = totalSeconds % 60
		let minutes = totalSeconds / 60
		var result:String
		var temp:String = ""
		
		
		let start = temp.index(temp.startIndex, offsetBy:po2)
		let end = temp.index(temp.startIndex, offsetBy:po2+1)
		let range = start...end
		//temp.replacingCharacters(in: range, with: "O")

		
		//temp.replacingCharacters(in:temp.index(temp.startIndex, offsetBy:po2)...temp.index(temp.startIndex, offsetBy:po2), with: "O")
		print("Human cycle report")
	}

//	-(NSString *) cycleReport
//	{
//	// This is designed to print out whatever should come at each cycle for O2, CO2, ventilation, and RRate.
//	// It is somewhat based on BRETH.  The assumed string length is 72 characters, and the string will be
//	// appended onto a time measurement.
//	//
//	NSMutableString *result;		// holds the physiological
//	NSMutableString *temp;		// holds the gases until attached to result
//	int pO2, pCO2, vent, rate;
//	int minutes, seconds;
//	NSRange O_Range, V_Range, C_Range, R_Range;	// NSRange is struct with location, length int members
//	const float factor = (float)72/120;  	// Converts a scale of 120 to a length of 72 characters
//	// Now get these puppies
//	pO2 = [myArteries pO2];
//	pCO2 = [myArteries pCO2];
//	vent = [myLungs totalVentilation];
//	rate = [myLungs respiratoryRate];
//	O_Range.location = (pO2 < 120) ? pO2*factor :72;
//	O_Range.length = 1;
//	C_Range.location = (pCO2 < 120) ? pCO2*factor :72;
//	C_Range.length = 1;
//	V_Range.location = (vent < 120) ? vent*factor :72;
//	V_Range.length = 1;
//	R_Range.location = (rate < 120) ? rate*factor :72;
//	R_Range.length = 1;
//	seconds = totalSeconds % 60;
//	minutes = totalSeconds / 60;
//	
//	result = [[NSMutableString alloc] initWithCapacity:82];
//	[result appendFormat:@"%4d:%2d     ", minutes, seconds];
//	temp = [[NSMutableString alloc] initWithCapacity:73];
//	[temp setString:@"                                                                         \n"];
//	[temp replaceCharactersInRange:O_Range withString:@"O"];	// pO2 in mm Hg
//	[temp replaceCharactersInRange:C_Range withString:@"C"];	// pCO2 in mm Hg
//	[temp replaceCharactersInRange:V_Range withString:@"V"];	// total ventilation in liters
//	[temp replaceCharactersInRange:R_Range withString:@"F"];	// frequency of breaths per minute
//	[result appendString:temp];
//	[temp release];
//	return result;
//	}
	
	// This will eventually be what is printed after the iterations have run
	func runReport(){
		print("Human run report")
	}
	
	// This will dump the first six parameters - for convenience
	func dumpParametersReport(){
		print("Human dump parameters report")
	}
	
	// This will eventually be the main simulation routine
	func simulate(_ cycle:Int){
		totalSeconds += 1
		print("Simulation cycle \(cycle)")
	}
	

	
}
