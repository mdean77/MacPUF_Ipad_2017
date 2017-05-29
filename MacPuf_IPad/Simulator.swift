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
	
	func cycleReport() -> String{
		// Returns a string for single line of output
		let scale = 120.0
		let lineWidth = 72.0
		let factor = lineWidth/scale
		let po2 = human.arteries.pO2 < scale ? Int(human.arteries.pO2*factor) : Int(lineWidth)
		let pco2 = human.arteries.pCO2 < scale ? Int(human.arteries.pCO2*factor) : Int(lineWidth)
		let vent = Int(human.lungs.totalVentilation*factor)  // Replace with lungs.totalVentilation when I have lungs
		let rate = Int(human.lungs.respiratoryRate*factor)  // Replace with lungs.respiratoryRate when I have lungs
		
		let seconds = human.totalSeconds % 60
		let minutes = human.totalSeconds / 60
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
	
	func runReport()->String{
		// This prints description after the iterations have been run
		let x = 10*pow(2,(8.0 - human.arteries.pH)*3.33)
		let result = String(format:"\nFinal values for this run were...\n\n")
		let result1 = String(format:"Arterial pO2 = %6.1f            O2 Cont =%6.1f      O2 Sat = %5.1f%%\n",human.arteries.pO2, human.arteries.oxygenContent,human.arteries.oxygenSaturation*100)
		let result2 = String(format:"Arterial pCO2 = %5.1f            CO2 Cont =%6.1f\n",human.arteries.pCO2,human.arteries.carbonDioxideContent)
		let result3 = String(format:"Arterial pH = %7.2f (%3.0f nm)   Arterial bicarbonate = %5.1f\n\n",human.arteries.pH,x,human.arteries.bicarbonateContent)
		let result4 = String(format:"Respiratory rate = %5.1f         Tidal vol.= %6.0f ml\n", human.lungs.respiratoryRate, human.lungs.tidalVolume)
		let result5 = String(format:"Total ventilation =%5.1f l/min   Actual cardiac output = %5.1f l/min\n",human.lungs.totalVentilation, human.heart.effectiveCardiacOutput)
		let result6 = String(format:"Total dead space = %4.0f ml       Actual venous admixture = %3.1f%%\n",human.lungs.deadSpace,human.heart.effectiveVenousAdmixture)
		
		return result + result1 + result2 + result3 + result4 + result5 + result6
	}
	
	func dumpParametersReport() -> String{
		// Print out first 6 changeable parameters
		
		let result = String(format:"List of first six parameters:\n     Inspired O2 %%:%6.2f\n     Inspired CO2 %%:%6.2f\n     Cardiac performance %%:%7.2f\n     Metabolic rate %%:%7.2f\n     Right to left:%6.2f\n     Extra dead space:%6.2f",human.lungs.FiO2,human.lungs.FiCO2,human.heart.cardiacFunction,human.metabolicRate,human.heart.rightToLeftShunt, human.lungs.addedDeadSpace)
		return result;
	}
	
	func inspectionReport()->String{
		let header = String(format:"\nTime         P.Pressures     Contents cc/dl  Amounts in cc  pH    HCO3-\n%4d secs     O2     CO2      O2     CO2       O2     CO2",human.totalSeconds)
		
		let artString:String = human.arteries.description()
		let lungString:String  = human.lungs.description()
		let brainString:String = human.brain.description()
		let tissueString:String = human.tissues.description()
		let veinString:String = human.venousPool.description()
		let bagString:String = human.bag.description()
		let ventilatorString:String = human.ventilator.description()
		let result = header + artString + lungString + brainString + tissueString + veinString + "\n" +  ventilatorString + bagString
		return(result)
	}
	
	func simulate(){
		iterations = iterations >= intervalFactor ? iterations : intervalFactor
		human.setIterations(iterations)
		print("\n   Time     0     10    20    30    40    50    60    70    80    90   100   110   120")
		print("(Min:Secs)  .     .     .     .     .     .     .     .     .     .     .     .     .")
		for i in 1...iterations {
			human.simulate(i)
			if i % intervalFactor == 0 {
				print(cycleReport())
			}
		}
		print(runReport())
		print(dumpParametersReport())
		print(inspectionReport())
	}
}
