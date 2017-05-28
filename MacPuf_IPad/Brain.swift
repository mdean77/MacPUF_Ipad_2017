//
//  Brain.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 5/28/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation

class Brain: Metabolizer{
	
	var oxygenationIndex = 1.000
	var bloodFlow = 52.3808
	var symptomFlag = 0
	var bicarbDeviation = -0.0678
	var C2CHN = 0
	
	override init(){
		super.init()
		amountOfOxygen = 18.2142
		pO2 = 29.1427
		oxygenContent = 10.1284
		oxygenSaturation = 0
		amountOfCO2 = 680.7448
		pCO2 = 53.0981
		carbonDioxideContent = 56.6056
		bicarbonateContent = 22.7000
		pH = 7.3290
		calculateContents()
	}
	
	func description() -> String{
	return String(format:"\nBrain/CSF%8.1f%8.1f%8.1f%8.1f%8.0f%8.0f%7.3f%6.1f",pO2, pCO2,oxygenContent, carbonDioxideContent,amountOfOxygen,amountOfCO2,pH,bicarbonateContent+bicarbDeviation)
	}
}
