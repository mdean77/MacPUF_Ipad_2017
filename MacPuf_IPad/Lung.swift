//
//  Lung.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 5/27/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation

class Lung : Metabolizer {
	
	var pN2 = 0.0																			//Value made up - need to connect to simulator
	var amountOfNitrogen = 1987.6002								// MacPuf variable AN2MT  Factor 65
	var alveolarMinuteVent = 4.3957									// MacPuf variable FVENT  Factor 35
	var alveolarVentilationPerIteration = 73.2621		// 366.3107 is value in Fortran code
																									// This is because I have changed iteration duration.
	var addedDeadSpace = 0.0000											// MacPuf variable BULLA  Factor 6
	var hypercapnicVentResponse = 100.000						// MacPuf variable AZ     Factor 10
	var hypoxicVentResponse = 100.000								// MacPuf variable BZ	  Factor 11
	var neurogenicVentResponse = 100.000						// MacPuf variable CZ     Factor 12
	var deadSpace = 130.6685												// MacPuf variable DSPAC  Factor 70
	var totalVentilation = 6.0536										// MacPuf variable DVENT  Factor 51
	var lungElastance = 5.0000											// MacPuf variable ELAST  Factor 8
	var FEV = 4.0																		// MacPuf variable FEV	  Factor
	var ventilatoryCoupling = 100.000								// MacPuf variable PR     Factor
	var referenceLungVolume = 3000.000							// MacPuf variable REFLV  Factor
	var respiratoryRate = 12.6881										// MacPuf variable RRATE  Factor 48
	var tidalVolume = 477.1105											// MacPuf variable TIDVL  Factor 47
	var FiO2 = 20.93000															// MacPuf variable FIO2   Factor 1
	var FiCO2 = 0.0300															// MacPuf variable FIC2   Factor 2
	var effectiveVentResponse = 6.0536							// MacPuf variable SVENT  Factor
	var vitalCapacity = 5.0000											// MacPuf variable VC     Factor 29
	var totalLungVolume = 3000.000									// MacPuf variable VLUNG  Factor 7
	var exhaledVentilation = 8.8777									// MacPuf variable XVENT  Factor
	var addedPFTDeadSpace = 0.000										// MacPuf variable XDSPA  Factor
	var inspiration = 0.4000												// % of respiratory cycle spent in inspiration SPACE
	var breathingCapacity = 100.0										// Factor 24
	var RVADM = 0.000																// RVADM used only when using PFT (see end of Clin2)
	
	override init(){
		super.init()
		amountOfOxygen = 346.1360											// MacPuf variable AO2MT  Factor 39
		pO2 = 101.6193																// MacPuf variable AO2PR  Factor 41
		oxygenContent = 19.6547												// MacPuf variable PO2CT  Factor 54
		oxygenSaturation = 0.970730										//Value made up - need to connect to simulator
		amountOfCO2 = 144.7786												// MacPuf variable AC2MT  Factor 40
		pCO2 = 39.9436																// MacPuf variable AC2PR  Factor 42
		carbonDioxideContent = 47.3157								// MacPuf variable PC2CT  Factor 53
		
		// In MacPuf model, lung pH and bicarbonateContent are not apparently used in calculations
		pH = 7.3721																		// stored only as a temp during the simulation Line 950
		bicarbonateContent = 25.4605									// stored only as a temp during the simulation Line 950
		calculateContents()
	}
	
	func description() -> String{
	return String(format:"\nAlv./Lung%8.1f%8.1f    (Sat=%4.1f%%) %8.0f%8.0f\n(Pulm.cap)%7.1f%8.1f%8.1f%8.1f",pO2, pCO2,oxygenSaturation*100,amountOfOxygen,amountOfCO2,pO2,pCO2,oxygenContent,carbonDioxideContent)
	}
	
}
