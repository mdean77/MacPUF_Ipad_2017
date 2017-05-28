//
//  Tissue.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 5/28/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation

class Tissue : Metabolizer {
	
	var oxygenConsumption = 240.000
	var respiratoryQuotient = 0.8000
	var extraFluidVolume = 12.0000
	var pN2 = 571.2808
	var amountOfNitrogen = 76.1708
	var slowN2 = 570.0273
	var amountSlowNitrogen = 977.1898
	var excessNitrogen = 0.000
	var lactateAmount = 34.7917
	var bubbles = 0.000
	var referenceCO2 = -0.2543
	var TC3AJ = -0.0677
	var bicarbonateAmount = 317.5415
	
	override init(){
		super.init()
		amountOfOxygen = 177.4896
		pO2 = 39.9351
		oxygenContent = 14.4212
		oxygenSaturation = 0  // Value made up - needs to be connected to simulator
		amountOfCO2 = 13.3736
		pCO2 = 45.4757
		carbonDioxideContent = 51.4988
		bicarbonateContent = 25.5284
		pH = 7.3721
		calculateContents()
	}
	
	func description() -> String{
		return String(format:"\nTissue/ECF%7.1f%8.1f%8.1f%8.1f%8.0f%8.0f%7.3f%6.1f",pO2, pCO2,oxygenContent, carbonDioxideContent,amountOfOxygen,amountOfCO2*1000,pH,bicarbonateContent)
	}
}
