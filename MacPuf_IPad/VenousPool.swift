//
//  VenousPool.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

// Strictly speaking, the venous pool is NOT really a metabolizer.  However it contains
// parameters that are seen in the other metabolizers so this inheritance is convenient.
// There is never a call to VenousPool.calculateContents nor VenousPool.calculatePressures.
class VenousPool: Metabolizer {
	
	var	bicarbonateAmount:Double = 0.0			// MacPuf variable VC3MT  Factor 86
	var	addBicarb:Double = 0.0					// additional bicarbonate, use negative to give acid
                                                // In venous pool because is administered there
                                                // MacPuf variable ADDC3  Factor 21
	var	venousBloodVolume:Double = 0.0          // MacPuf variable VBLVL  Factor 20
	
	override init(){
		super.init()
		amountOfOxygen = 434.7640
		pO2 = 40.0                               //Irrelevant I think because will be back calculated
		oxygenContent = 14.4921
		oxygenSaturation = 0.0                     // value made up - needs to be connected to simulator
		amountOfCO2 = 1543.2665
		pCO2 = 45.7                              //Irrelevant I think because will be back calculated
		carbonDioxideContent = 51.4422
		bicarbonateContent = 25.4605
		bicarbonateAmount = 71.2432
		addBicarb = 0.000
		pH = 7.3710
		venousBloodVolume = 3000.000
		
	}
	
	
}
