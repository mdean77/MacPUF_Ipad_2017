//
//  Human.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

//  Note that Human is not a metabolizer object.  Only its component systems are metabolizers.
class Human {
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
	
	init(){
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
	
	func dampChange(_ newValue:Double, oldValue:Double, dampConstant:Double) -> Double {
		return (newValue * dampConstant + oldValue)/(dampConstant + 1)
	}
	
	func setIterations(_ newIterations:Int){
		iterations = newIterations
	}
	
	func cycleReport() -> String{
		// Returns a string for single line of output
		let scale = 120.0
		let lineWidth = 72.0
		let factor = lineWidth/scale
		let po2 = arteries.pO2 < scale ? Int(arteries.pO2*factor) : Int(lineWidth)
		let pco2 = arteries.pCO2 < scale ? Int(arteries.pCO2*factor) : Int(lineWidth)
		let vent = Int(55*factor)  // Replace with lungs.totalVentilation when I have lungs
		let rate = Int(14*factor)  // Replace with lungs.respiratoryRate when I have lungs
		
		let seconds = totalSeconds % 60
		let minutes = totalSeconds / 60
		var temp = String(repeating: " ", count: 72)
		
		let oxygenIndex = temp.index(temp.startIndex, offsetBy:po2)
		let carbonDioxideIndex = temp.index(temp.startIndex, offsetBy:pco2)
		let rateIndex = temp.index(temp.startIndex, offsetBy: rate)
		let ventIndex = temp.index(temp.startIndex, offsetBy: vent)

		temp.replaceSubrange(oxygenIndex...oxygenIndex, with:"O")
		temp.replaceSubrange(carbonDioxideIndex...carbonDioxideIndex, with:"C")
		temp.replaceSubrange(rateIndex...rateIndex, with:"F")
		temp.replaceSubrange(ventIndex...ventIndex, with:"V")
		let result = String(format:"%4d:%2d     ",minutes, seconds).appending(temp)
		return(result)
	}
	
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
		//print("Simulation cycle \(cycle)")
	}
	

	
}
