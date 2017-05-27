//
//  Heart.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/10/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//	Changed to a struct May 2017
//

import Foundation

struct Heart {
	
	var	cardiacFunction:Double = 100.000										// MacPuf variable CO		Factor 3
	var	effectiveCardiacOutput:Double = 4.9528							// MacPuf variable COADJ	Factor 93
	var	maximumCardiacOutput:Double = 35.0000               // MacPuf variable COMAX	Factor 27
	var	restingCardiacOutput:Double = 4.6000								// MacPuf variable CONOM	Factor 82
	var	leftToRightShunt:Double = 0.0												// MacPuf variable SHUNT	Factor 28
	var	rightToLeftShunt:Double = 0.0												// MacPuf variable FADM		Factor 5
	var	admixtureEffect:Double = 3.0												// MacPuf variable VADM		Factor 9
	var	effectiveVenousAdmixture:Double = 2.3618						// MacPuf variable PW		Factor 80
	var	decilitersPerIteration:Double = 0.82546666          // MacPuf variable FTCO
	var	fitnessAdjustedOutputPerIteration:Double = 0.80895	// MacPuf variable FTCOC

}
