//
//  Human.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

class Human {
	// Simulation parameters
	var totalSeconds = 0
	var simlt = 1
	var iterations = 0     // Valid value will be provided from simulation controller
	
	// Human parameters that are not body system specific
	var age = 40
	var weight = 70
	var height = 178
	var barometric = 760.0
	var BARRF = 713.01
	var DPG = 3.7843
	var Hgb = 14.8
	var Hct = 45.0
	var temperature = 37.0
	var male = 1
	var metabolicRate = 100.0
	var fitness = 28.0
	var XLACT = 0.0006
	var XC2PR = 45.4757
	var DPH = 7.3996
	var RCOAJ = 100.0
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
	let lungs:Lung
	
	init(){
		arteries = ArterialPool()
		heart = Heart()
		bag = Bag()
		venousPool = VenousPool()
		// brain = Brain()
		// tissues = Tissue()
		// ventilator = Ventilator()
		lungs = Lung()
		
		arteries.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
		lungs.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
		// tissues.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
		// brain.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
		
		for i in 1...10 {
			veinDelay[i-1] = venousPool.oxygenContent
			veinDelay[i+9] = venousPool.carbonDioxideContent
			veinDelay[i+19] = venousPool.bicarbonateContent
			veinDelay[i+29] = XC2PR
		}
	}
	
	func dampChange(_ newValue:Double, oldValue:Double, dampConstant:Double) -> Double {
		return (newValue * dampConstant + oldValue)/(dampConstant + 1)
	}
	
	func setIterations(_ newIterations:Int){
		iterations = newIterations
	}
	
	
	// This will dump the first six parameters - for convenience
	func dumpParametersReport(){
		print("Human dump parameters report")
	}
	
	// This will eventually be the main simulation routine
	func simulate(_ cycle:Int){
		
		totalSeconds += 1
		//print("Simulation cycle \(cycle)")
	}
	
	
	
}
