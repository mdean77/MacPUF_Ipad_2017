//
//  Simulator.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 5/26/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation

//	This class instantiates the human object, sets the iterations, contains simulation parameters,
//	and handles interface to user for changes.
//
//	I anticipate that much functionality in this object will be placed in iOS classes, but I am 
//	creating this class now so that I can verify function of the model in a console environment.

class Simulator {
	
	var iterations: Int = 60
	var intervalFactor : Int = 10
	let human = Human()
	
	func simulate(){
		iterations = iterations >= intervalFactor ? iterations : intervalFactor
		human.setIterations(iterations)
		print("   Time     0     10    20    30    40    50    60    70    80    90   100   110   120")
		print("(Min:Secs)  .     .     .     .     .     .     .     .     .     .     .     .     .")
		for i in 1...iterations {
			human.simulate(i)
			if i % intervalFactor == 0 {
				print(human.cycleReport())
		}
		}
		human.runReport()
		human.dumpParametersReport()
		
	}
}
