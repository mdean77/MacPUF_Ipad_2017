//
//  ArterialPool.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/9/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

class ArterialPool: Metabolizer{
	
	var	effluentOxygenContent=0.0
	var	effluentCO2Content=0.0
	var	nitrogenContent=0.0
	var	effluentNitrogenContent=0.0
	var	amountOfN2=0.0
	var	lactateConcentration=0.0
	
	override init(){
		super.init()
		amountOfOxygen = 195.3276										// MacPuf variable RO2MT  Factor 62
		pO2 = 93.4906																// MacPuf variable RO2PR  Factor 72
		oxygenContent = 19.5328											// MacPuf variable RO2CT  Factor 49
		oxygenSaturation = 0												// gets fixed by calcContents
		amountOfCO2 = 474.1322											// MacPuf variable RC2MT  Factor 63
		pCO2 = 40.0676															// MacPuf variable RC2PR  Factor 74
		carbonDioxideContent = 47.4132							// MacPuf variable RC2CT  Factor 78
		bicarbonateContent = 23.8357								// MacPuf variable RC3CT  Factor 60
		pH = 7.3937																	// MacPuf variable RPH    Factor 33
		effluentOxygenContent = 19.5328							// MacPuf variable EO2CT  Factor 94
		effluentCO2Content = 47.4132								// MacPuf variable EC2CT  Factor 101
		nitrogenContent = 0.73											// MacPuf variable RN2CT  Factor 106
		effluentNitrogenContent = 0.7257						// MacPuf same as EN2CT
		amountOfN2 = 7.2573													// MacPuf variable RN2MT  Factor 108
		lactateConcentration = 0.9940								// MacPuf variable RLACT  Factor 90
	}
	

	

	
	
}
