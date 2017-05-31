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
	let brain:Brain
	let tissues:Tissue
	let ventilator:Ventilator
	let lungs:Lung
	
	init(){
		arteries = ArterialPool()
		heart = Heart()
		bag = Bag()
		venousPool = VenousPool()
		brain = Brain()
		tissues = Tissue()
		ventilator = Ventilator()
		lungs = Lung()
		
		
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
	
	// Main simulation routine
	func simulate(_ cycle:Int){
		let c1,c2,c3,c4,c5,c6,c7,c8,c9,c10:Double
		var c11, c19, c20:Double							//Two step calculations so had to be mutable
		let c12,c13,c14,c15,c16,c17,c18:Double
		let c21,c22,c23,c24,c25,c26,c27,c28,c29,c30:Double
		let c31,c32,c33,c34,c35,c36,c37,c38,c39,c40:Double
		let c41,c42,c43,c44,c45,c46,c47,c48,c49,c50:Double
		let c51,c52,c53,c54,c55,c56,c57,c58,c59,c60:Double
		let c61,c62,c63,c64,c65,c66,c67,c68,c69,c70:Double
		let c71,c72,c73,c74,c75,c76:Double
		let ft = 1.0/60.0
		let e = 0.0000001
		var x, y, z, pc, u, v, w, pj, s, xu:Double
		let xx:Double
		
		totalSeconds += 1
		
		c1 = 1000.0/venousPool.venousBloodVolume
		c2 = 100.0/venousPool.venousBloodVolume
		c3 = 0.0203*Hgb
		c4 = (lungs.lungElastance + 105)*0.01
		c5 = 2.7/(lungs.vitalCapacity + 0.4)
		c6 = lungs.FEV * 25.0 + 29.0
		
		// Prepare to decrease ventilatory effect of temperature in c45, increase cardiac output increase
		// with temperature increase (c8), reduce cardiac output response to exercise slightly (c9)
		z = tissues.oxygenConsumption * metabolicRate * 0.00081 // Used multiple places below
		c7 = z * (pow((temperature - 26),1.05))
		c8 = (30 - ventilator.PEEP*5/lungs.lungElastance)*0.0028*heart.restingCardiacOutput*(temperature - 23.0)
		c9 = (c7 - tissues.oxygenConsumption)*0.0074
		c10 = ft * 0.005 // new value 0.05
		c11 = barometric/Double(simlt) - 0.03 * temperature * temperature - 5.92
		c11 = (c11 > 0.00001) ? c11 : 0.00001
		c12 = c11 * 0.003592/(273 + temperature)
		c13 = 0.9/tissues.extraFluidVolume
		c14 = heart.leftToRightShunt + 1
		c15 = 2.0/Double(weight)
		c16 = heart.cardiacFunction * 0.01
		c17 = ft * 10
		c18 = heart.admixtureEffect * 80.0
		c19 = (metabolicRate - 90.0) * lungs.RVADM * 0.05
		c19 = (c19 > -1) ? c19 : -1
		c20 = 650.0 * lungs.vitalCapacity
		c20 = (lungs.addedDeadSpace > 0) ? c20 + sqrt(lungs.addedDeadSpace) * 15: c20
		c21 = (40 - ventilator.PEEP) * 0.025
		c22 = 4.5/ft
		c23 = 20.0*Double(simlt)/barometric
		c24 = heart.restingCardiacOutput*0.3
		c25 = 100.0 * c12
		c26 = 7.0/tissues.extraFluidVolume
		c27 = ft * 0.1
		c28 = 30000.0/(venousPool.venousBloodVolume+1000.0)
		c29 = ft * 0.0039*pow(Double(weight),0.425)*pow(Double(height), 0.725)
		c30 = 520 / tissues.extraFluidVolume
		c31 = 2.7/tissues.extraFluidVolume
		c32 = c29 + 0.0000001
		c33 = c3*308 - tissues.extraFluidVolume*0.65*c30
		c34 = 0.004/(c12 * ft)
		c35 = 0.01/c12
		c36 = 7.7*c13
		c37 = lungs.inspiration/ft
		c38 = lungs.totalLungVolume*0.00000004/pow(ft, 1.5)
		c39 = ft * 0.127
		c40 = c29 * (metabolicRate-25) * 1.3
		c41 = ft * (temperature - 24.5) * 1.82
		c42 = c29 * 0.003
		c43 = 1/(1+7.7*c3)
		x = pow((metabolicRate * 0.01),0.8)*0.2*lungs.vitalCapacity
		c44 = x * 0.0132 * lungs.hypercapnicVentResponse
		c45 = x * 0.008 * lungs.hypoxicVentResponse
		
		//  Slightly change ventilation effects of exercise
		c46 = lungs.neurogenicVentResponse*0.714*(pow(z*(temperature - 26)*0.0005, 0.97)+0.01)
		
		//  Reduce temperature effects on ventilation
		x = 356.0/c11 + 0.5
		x = (x>1) ? 1 : x
		//		y = pow(temperature-29,1.5)
		//		if (temperature > 37) {y = 23}
		y = temperature > 37 ? 23 : pow(temperature-29,1.5)
		c47 = lungs.ventilatoryCoupling * 0.000262*y*x
		c48 = 0.04 * (temperature - 26.0) * lungs.vitalCapacity
		
		// Increase respiratory rate effects of elastance changes
		c49 = 8.0 + pow(lungs.lungElastance, 0.75)
		c50 = (150 + lungs.ventilatoryCoupling)*0.0275*(temperature - 17)
		c51 = lungs.tidalVolume * lungs.respiratoryRate * 0.001
		c52 = lungs.totalLungVolume*0.03 - 20 + lungs.addedDeadSpace
		c53 = 0.8/ft;
		c54 = lungs.addedPFTDeadSpace * 0.001;
		
		c55 = 0.2/ft; // 0.1 / ft old value
		c56 = 0.001/ft;
		c57 = ft * 60;
		c58 = ft * 1.27;
		c59 = ft * 0.3;
		c60 = ft * 0.008;
		
		// Reduce rate of cardiac output increase at start exercise
		x = pow(metabolicRate * 0.01,1.45);
		if x > 12 {x = 12}
		c61 = 0.00025 * RCOAJ/(ft*x);
		//c61 = 0.22/ft; // old value
		c62 = ft * 50000.0/(lungs.neurogenicVentResponse+300.0);
		//c62 = ft * 240000./(lungs.neurogenicVentResponse+300.); // old value
		
		c63 = ft * c7 * 0.12;
		c64 = 0.01488*Hgb*(tissues.extraFluidVolume+venousPool.venousBloodVolume*0.001)
		c65 = 7.324 - lungs.neurogenicVentResponse*0.00005;
		c66 = c65 - 0.002;
		c67 = lungs.neurogenicVentResponse - 30.0;
		
		// Reduce rate increase of ventilation at start exercise
		c68 = ft * 1500.0/(metabolicRate + 200.0);
		//c68 = ft * 3000./(metabolicRate + 200.); // old value
		
		c69 = (fitness - 20)*0.00035;
		c70 = c29 * 1.3;
		
		// New constants for 2,3 DPG changes and fitness
		c71 = 21.7 + Double(male)*1.6
		c72 = ft * 0.002
		x = (metabolicRate*1.5 - 150.0)*0.02 - 7
		if (x < -7) {x = -7}
		if (x > 0) {x = 0}
		c73 = fitness + x
		c74 = 0.000005/ft
		c75 = 0.002/ft
		c76 = 0.05/ft
		
		// When user adds bicarb the total amount needs to be spread over the run time, so dose must be
		// adjusted according to the number of iterations in the run.  Only on the FIRST pass!
		if (cycle == 1) {
			venousPool.addBicarb = venousPool.addBicarb/Double(iterations)
		}
		
		DPH = 7.4 + (DPG - 3.8)*0.025
		if (DPH > 7.58) {DPH = 7.58}
		if (DPG > 13) {DPG = 13}
		
		// The code below allows instant changes in lung gas composition and pressures after
		// an acute change in barometric pressure.
		if (c11 < BARRF) {
			x = c11/BARRF;
			lungs.amountOfOxygen *= x
			lungs.amountOfCO2 *= x
			lungs.amountOfNitrogen *= x
			lungs.pO2 *= x
			lungs.pCO2 *= x
		}
		
		if (c11 > BARRF) {
			x = (c11-BARRF)*0.0083*lungs.totalLungVolume/BARRF;
			lungs.amountOfOxygen = lungs.amountOfOxygen + x * lungs.FiO2
			lungs.amountOfCO2 = lungs.amountOfCO2 + x * lungs.FiCO2
			lungs.amountOfNitrogen = lungs.amountOfNitrogen + x * (100 - lungs.FiCO2 - lungs.FiO2)
			xx = c11/(lungs.amountOfOxygen+lungs.amountOfCO2+lungs.amountOfNitrogen);
			lungs.pO2 = lungs.amountOfOxygen*xx
			lungs.pCO2 = lungs.amountOfCO2 * xx
		}
		
		// Adjust cardiac output for hypoxia, changes in oxygen consumption, etc. and limit to
		// reasonable values.  This is done by computing some constants and telling the myHeart
		// object to adjust the cardiac parameters.
		
		y = (arteries.oxygenContent * 0.056 < 0.4) ? 0.4 : arteries.oxygenContent*0.056
		heart.effectiveCardiacOutput = dampChange(((c8 + c9)/y)*c16, oldValue: heart.effectiveCardiacOutput, dampConstant: c61)
		if (heart.cardiacFunction < 3) {heart.effectiveCardiacOutput = e}
		heart.effectiveCardiacOutput = min(heart.effectiveCardiacOutput, heart.maximumCardiacOutput)
		heart.decilitersPerIteration = heart.effectiveCardiacOutput*c17
		heart.fitnessAdjustedOutputPerIteration = heart.decilitersPerIteration*(1 - c69 * heart.effectiveCardiacOutput)
		
		// THERE IS A PROBLEM HERE THAT I DO NOT UNDERSTAND AS THE VALUE IS SET 10 TIMES TOO LOW
		// FOR THE PRESENT I AM PATCHING OUT THE USE OF FITNESS ADJUSTED CARDIAC OUTPUT JUST TO GET
		// MACPUF DEBUGGED.  I WILL NEED TO COME BACK TO THIS ISSUE.
		// October 2011 - returning to this issue prior to Big Nerd Ranch
		// NOTE:  Check c69 because it may have been a constant relating to FT that is ten times larger in original FORTRAN
		
		// Oxygen content or pressure affects venous admixture and very slowly DPG
		DPG = (DPG + (23.3 - arteries.oxygenContent - DPG) * ft * 0.05)
		
		// Increase venous admixture if alveolar pO2 is very high
		x = lungs.pO2
		y = lungs.pO2
		x = ( x>200) ? 200 : x
		y = ( y>600) ? 600 : y
		x = (lungs.pO2 > 400) ? x - (y - 400.0)*0.3 : x
		x = (x > 55) ? x : 55
		
		// Venous admixture (effective) is changed by PEEP, alveolar pO2 and any
		// fixed right to left shunt
		
		// We also limit venous admixture so it cannot exceed 100
		heart.effectiveVenousAdmixture = max(((c18/x+c19)*c21 + heart.rightToLeftShunt),100)
		
		
		// Arterial CO2 and O2 amounts incremented by mixture of pure venous and pure
		// idealized pulmonary capillary blood, determined by ratios of x and pc.
		pc = 1.0 - heart.effectiveVenousAdmixture * 0.01
		
		// Nitrogen content is determined in terms of partial pressures assuming a linear dissociation curve
		arteries.amountOfN2 = arteries.amountOfN2 + heart.decilitersPerIteration*((x * tissues.pN2 + pc * (c11 - lungs.pO2 - lungs.pCO2))*0.00127 - arteries.effluentNitrogenContent)
		
		u = x * venousPool.carbonDioxideContent + pc * lungs.carbonDioxideContent
		v = x * venousPool.oxygenContent + pc * lungs.oxygenContent
		arteries.amountOfCO2 = arteries.amountOfCO2 + heart.decilitersPerIteration * (u - arteries.effluentCO2Content)
		arteries.amountOfCO2 = max(arteries.amountOfCO2, 0.001)
		
		arteries.amountOfOxygen = arteries.amountOfOxygen + heart.decilitersPerIteration * (v - arteries.effluentOxygenContent)
		
		// Contents passing to the tissues are affected by rates of blood flow
		w = c22/heart.effectiveCardiacOutput
		
		// If heart is effectively stopped then prevent changes in arterial blood composition
		if (w > 100) {w = 0}
		
		arteries.effluentOxygenContent = dampChange(arteries.amountOfOxygen*0.1, oldValue: arteries.effluentOxygenContent, dampConstant: w)
		arteries.effluentCO2Content = dampChange(arteries.amountOfCO2*0.1, oldValue: arteries.effluentCO2Content, dampConstant: w)
		arteries.effluentNitrogenContent = dampChange(arteries.amountOfN2*0.1, oldValue: arteries.effluentNitrogenContent, dampConstant: w)
		z = c17 * heart.effectiveCardiacOutput
		
		// Arterial O2 and CO2 contents will reach the chemoreceptors in the brain
		// To calculate the tensions we will call the FORTRAN GSINV routine
		// which has not yet been implemented.  Chemoreceptors are tension responsive,
		// not content responsive. First we must set the contents:
		arteries.oxygenContent = dampChange(v, oldValue: arteries.oxygenContent, dampConstant: z)
		arteries.carbonDioxideContent = dampChange(u, oldValue: arteries.carbonDioxideContent, dampConstant: z)
		arteries.carbonDioxideContent = max(arteries.carbonDioxideContent, 0.001)
		
		// We must also setup the bicarbonate  which must take into account
		// in vitro influence of arterial pCO2 on bicarbonate concentration:
		arteries.bicarbonateContent = c3 * (arteries.pCO2 - XC2PR) + venousPool.bicarbonateContent
		if (arteries.bicarbonateContent*arteries.pCO2 < 0) {
			print("Bicarbonate less than zero, patient is dead.")
			// need to go to a death routine somewhere but not yet defined
		}
		
		// And set the pH based on the adjusted bicarbonate:
		arteries.updatePh()
		
		// Estimate arterial pCO2 change for later effects on brain chemoceptors
		brain.C2CHN = Int(arteries.pCO2)
		arteries.calculatePressures(arteries.oxygenContent, carbonDioxideContent: arteries.carbonDioxideContent, pO2initial: arteries.pO2, pCO2initial: arteries.pCO2, pH: arteries.pH)
		brain.C2CHN = Int(arteries.pCO2) - brain.C2CHN
		pj = arteries.oxygenSaturation*100
		
		// u represents specified energy expenditure from metabolic rate potentially changed
		// by the user - this is incorporated in constant c7.
		s = lungs.effectiveVentResponse
		s = (s < 0) ? -s : s
		
		// First term of u is oxygen consumption of respiratory muscles and the second
		// term is oxygen consumption of heart.  In event of anaerobic metabolism the
		// energy requirements are the same but much more lactate is produced (11 times)
		// and oxygen is spared (XLACT factor).
		
		// In original MacPuf, there was a check to make sure the tissue amount of oxygen was
		// greater than an error term;  otherwise death routine was called.  However, in revisions
		// in 1987, the authors added the concept that tissue oxygen utilization will stop at
		// very low pressure, and if tissue pO2 were under 10, oxygen consumption needs to be
		// tapered off.
		
		u = ft * (pow(s,c4)*c5+c7 + heart.effectiveCardiacOutput)
		// PATCHOUT OF FITNESS ADJUSTMENT
		//    x=  [tissues.amountOfOxygen] + [heart.fitnessAdjustedOutputPerIteration] *
		//        ([arteries. effluentOxygenContent] - [tissues.oxygenContent]) - u + XLACT;
		x =  tissues.amountOfOxygen + 0.98 * heart.decilitersPerIteration * (arteries.effluentOxygenContent - tissues.oxygenContent) - u + XLACT
		
		// If pO2 under 10 then taper the oxygen consumption
		xu = (x * c31 < 10) ? c7 * ft * (tissues.pO2 - 10)/(tissues.pO2 - x * c31) : 0
		xu = (xu < c7*ft) ? xu : c7*ft										// XU = AMIN1(C7*FT,XU) - limit the adjustment value
		tissues.amountOfOxygen = x + xu										// add back in the oxygen value in x
		tissues.amountOfOxygen = max(tissues.amountOfOxygen, 0.01)  // handle decompression
		
		// Compute the tissue pO2 damping appropriately:
		tissues.pO2 = dampChange(tissues.amountOfOxygen*c31, oldValue: tissues.pO2, dampConstant: c55)
		x = tissues.amountOfOxygen - 250;
		if (x > 0 ) {tissues.pO2 + 45 + 0.09*x}	// FORTRAN Line 520

		
		// FORTRAN LINE 530 STARTS HERE
		// Lactate metabolism is handled here.  Y represents catabolism related to
		// cardiac output and metabolism
		y = c29*arteries.lactateConcentration
		
		// X is a threshold - when tissue pH less than 7.0 catabolism is impaired
		// Cerebral blood flow is used to give appropriate changes in lactate metabolism
		// with low pCO2 or alkalosis - this is convenience, not physiology.  CBF is computed
		// elsewhere in the simulation and happens to change in the appropriate way.
		w = [brain.bloodFlow]*0.019;
		if (w > 1) w = 1;
		x = [tissues.pH] * 10.0 - 69.0;
		if (x > w) x = w;
		
		// Z is catabolic rate for lactate.  First term is hepatic removal, second term is renal removal
		// with pH influence, and third term is blood flow related metabolism by muscles, made dependent
		// on cardiac output.  The entire expression is multipled by Y, a function of lactate concentration.
		z = y*(x*0.8612+0.0232*pow(2,(8-[tissues.pH])*3.33)+[heart.effectiveCardiacOutput]*0.01);
		w = c70/(w + 0.3);
		
		// Fitness is the threshold for switching to anaerobic metabolism;  by its name one can infer
		// it should relate to physical fitness!
		v = c73 - [tissues.pO2];
		
		// If the anaerobic trigger occurs, these statements rapidly increase lactate production (w) if
		// tissue pO2 is low.  In addition, catabolism (z) drops if tissue pO2 is too low.
		if (v > 0) {
			w = w + c42*pow(v+1,4);
			z = z *0.04*[tissues.pO2];
		}
		
		// XLACT is O2 sparing effect of lactic acid production;  it may not exceed actual O2 consumption (u).
		x = 2.04*(w - c32);
		if (x > u) x = u;
		XLACT = [self dampChange:x
		oldValue:XLACT
		dampConstant:c53];		// Fortran line 590
		
		// Limit of rate of lactate formation determined by metabolic drive to tissues, or the level of exercise.
		// It is also related to body size, which is captured in c29.
		
		if (w > c40) w = c40;
		
		// Reduce lactate catabolism (z) if effective cardiac output is less than 1/3 of normal resting
		// cardiac output to take account of likely diminished liver and kidney blood flow (and hence
		// reduced lactate clearance.
		
		if ([heart.effectiveCardiacOutput] < [heart.restingCardiacOutput]*0.3) {
			z = z * [heart.effectiveCardiacOutput]/c24;
		}
		
		// Increase total lactate by difference between production and catabolism
		v = w - z;
		[tissues.setLactateAmount:[tissues.lactateAmount] + v];
		
		// Reduce the rate of arterial lactate by using a greater damping constant;  this was
		// a change to using c75 in the FORTRAN source instead of c55.
		[arteries.setLactateConcentration:
			[arteries.dampChange:[tissues.lactateAmount]*2./weight
			oldValue:[arteries.lactateConcentration]
			dampConstant:[heart.effectiveCardiacOutput]*0.002/ft]];
		
		// FORTRAN LINE 640
		// Next we handle the nitrogen stores in tissues, moving N2 between fast (T)
		// and slow (S) tissue compartments according to partial pressure differences.
		x = ([tissues.pN2]-[tissues.slowN2]) * c60;
		
		// PATCHOUT ADJUSTMENT FOR FITNESS
		//    [tissues.setAmountOfNitrogen:
		//        [tissues.amountOfNitrogen] + [heart.fitnessAdjustedOutputPerIteration] *
		//        ([arteries. effluentNitrogenContent] - ([tissues.pN2]*0.00127))-x];
		[tissues.setAmountOfNitrogen:
			[tissues.amountOfNitrogen] + 0.98*[heart.decilitersPerIteration] *
			([arteries. effluentNitrogenContent] - ([tissues.pN2]*0.00127))-x];
		
		[tissues.setAmountSlowNitrogen: [tissues.amountSlowNitrogen] + x];
		
		// Test to see if slow space is supersaturated
		y = ([tissues.amountSlowNitrogen]*c26 - c11)*c27;
		
		// If supersaturated then augment excessNitrogen and decrease amountSlowNitrogen, or
		// vice versa if ambient pressure is relatively higher.
		// Bubbles is arbitrary index for symptoms from nitrogen bubbles in the tissue, taking
		// account of BTPS volume and loading by the number of molecules of gas - note that
		// bubbles is only a rough index and the program was still in development in 1987.  I
		// have incorporated the changes of 1987 by CJD to dampen the change in bubbles.
		if(y <= 0) {
			y = y * 0.3;
			if ([tissues.excessNitrogen] > 0) {
				[tissues.setAmountSlowNitrogen: [tissues.amountSlowNitrogen] - y];
    
				//[tissues.setBubbles:pow([tissues.excessNitrogen],1.2)*20/barometric];  OLD VERSION
				
				[tissues.setBubbles:
					[tissues.dampChange:pow([tissues.excessNitrogen],1.2)*c23
					oldValue:[tissues.bubbles]
					dampConstant:0.005/(12*ft)]];
				[tissues.setExcessNitrogen: [tissues.excessNitrogen] + y];
			}
		}
		
		
		// Compute the partial pressures
		[tissues.setSlowN2: [tissues.amountSlowNitrogen]*c26];
		[tissues.setPN2: [tissues.amountOfNitrogen]*c28];
		
		// Tissue CO2 exchanges.  U is still the metabolism factor calculated earlier
		// 0.001 converts from cc to litres
		// PATCHOUT FITNESS ADJUSTMENT
		//    [tissues.setAmountOfCO2:[tissues.amountOfCO2] +
		//        ([heart.fitnessAdjustedOutputPerIteration]*([arteries. effluentCO2Content]-[tissues.carbonDioxideContent])
		//         + [tissues.respiratoryQuotient]*u)*0.001];
		[tissues.setAmountOfCO2:[tissues.amountOfCO2] +
			(0.98*[heart.decilitersPerIteration]*([arteries. effluentCO2Content]-[tissues.carbonDioxideContent])
			+ [tissues.respiratoryQuotient]*u)*0.001];
		
		// Compute partial pressures from total CO2 and standard bicarbonate
		// These methods were completely revised in 1987 to track movement up or down in tissue CO2 and
		// modify the buffer constant accordingly.
		
		
		c2ref = [tissues.pCO2];
		[tissues.setPCO2:
			([tissues.amountOfCO2]*c30 - [tissues.bicarbonateAmount]*c36+c33)*c43];	// FORTRAN Line 5 past 670
		
		// Track movement up or down in tissue CO2 and modify buffer constant accordingly
		
		[tissues.setReferenceCO2:
			[tissues.referenceCO2] + ([tissues.pCO2] - c2ref)];
		[tissues.setTC3AJ:
			[tissues.dampChange:0.2*[tissues.referenceCO2]
			oldValue:[tissues.TC3AJ]
			dampConstant:c10]];
		
		xnew = [heart.fitnessAdjustedOutputPerIteration]*0.1*
		(([venousPool.bicarbonateContent] -(XC2PR - 40.)*c3)-[tissues.bicarbonateAmount]*c13);
		//   xnew = 0.98*[heart.decilitersPerIteration]*0.1*
		//       (([venousPool. bicarbonateContent] -(XC2PR - 40.)*c3)-[tissues.bicarbonateAmount]*c13);
  
		// 0.4 in line below represents buffers of lactic acid partly inside cells so that displacement of bicarbonate
		// is less than strict molar equivalence
		
		[tissues.setBicarbonateAmount:[tissues.bicarbonateAmount] + xnew - 0.4 * v];
		
		// Decrement pre-delay pool representing total amount on venous side although contents are effectively damped by the
		// delay line
		[venousPool. setBicarbonateAmount: ([venousPool. bicarbonateAmount] - xnew)];
		
		[tissues.setBicarbonateContent:[tissues.bicarbonateAmount]*c13+([tissues.pCO2]-40)*c3 - [tissues.TC3AJ]];
		if (([tissues.bicarbonateContent] * [tissues.pCO2]) <= 0) NSLog(@"We have a bad fucking arithmetic problem in tissue bicarb!");
		[tissues.updatePh];
		[tissues.calcContents:temperature:Hct:Hgb:DPG];
		
		// Amounts of gases in venous pool increase by arriving blood from tissues and decrement by blood going to lungs.
		// Same for bicarbonate.  Venous contents for oxygen and CO2 are then determined.
		x = c69*[heart.effectiveCardiacOutput] * [heart.decilitersPerIteration];  // Not sure of this translation
		
		// Bicarbonate addition adds CO2 (22.4 L = 1 mol HCO3)
		if ([venousPool. addBicarb] > 0)
		[venousPool. setAmountOfCO2:[venousPool. amountOfCO2]+22.4 * [venousPool. addBicarb]];
		
		// PATCHOUT Fitness adjustment
		//   [venousPool. setAmountOfCO2:
		//   [venousPool. amountOfCO2] + [heart.fitnessAdjustedOutputPerIteration]*[tissues.carbonDioxideContent]-
		//       [heart.decilitersPerIteration]*([venousPool. carbonDioxideContent]*c14 - [arteries. carbonDioxideContent]*
		//                                  [heart.leftToRightShunt])+x*[arteries. effluentCO2Content]];
		[venousPool.setAmountOfCO2:
		[venousPool.amountOfCO2] + 0.98*[heart.decilitersPerIteration]*[tissues.carbonDioxideContent]-
		[heart.decilitersPerIteration]*([venousPool.carbonDioxideContent]*c14 - [arteries.carbonDioxideContent]*
		[heart.leftToRightShunt])+x*[arteries.effluentCO2Content]];
		// NOT SURE IF THIS LINE SHOULD BE AVAILABLE OR NOT
		// I THINK NOT - pCO2 goes into toilet if I leave this in place so need to find ou where it came from
		//   [venousPool. setAmountOfCO2: [venousPool. amountOfCO2] + 0.1*[heart.fitnessAdjustedOutputPerIteration]*[tissues.carbonDioxideContent]];
		//   [venousPool. setAmountOfCO2: [venousPool. amountOfCO2] - [heart.decilitersPerIteration]*[venousPool. carbonDioxideContent]];
		//   [venousPool. setAmountOfCO2: [venousPool. amountOfCO2] + x * [arteries. effluentCO2Content]];
		
		
		//   [venousPool. setAmountOfOxygen:
		//       [venousPool. amountOfOxygen] + [heart.fitnessAdjustedOutputPerIteration]*[tissues.oxygenContent]-
		//       [heart.decilitersPerIteration]*([venousPool. oxygenContent]*c14 - [arteries. oxygenContent]*
		//                                  [heart.leftToRightShunt])+x*[arteries. effluentOxygenContent]];
		[venousPool.setAmountOfOxygen:
		[venousPool.amountOfOxygen] + 0.98*[heart.decilitersPerIteration]*[tissues.oxygenContent]-
		[heart.decilitersPerIteration]*([venousPool.oxygenContent]*c14 - [arteries.oxygenContent]*
		[heart.leftToRightShunt])+x*[arteries.effluentOxygenContent]];
		
		// Adjust tissue and venous pool bicarb amounts - bicarb moves after delay line into arterial side
		xnew = [heart.fitnessAdjustedOutputPerIteration]*0.1*([tissues.bicarbonateAmount]*c13 -([venousPool.bicarbonateContent]-
		(XC2PR-40)*c3));
		//   xnew = 0.98*[heart.decilitersPerIteration]*0.1*([tissues.bicarbonateAmount]*c13 -([venousPool. bicarbonateContent]-
		//                                                                                               (XC2PR-40)*c3));
		
		[venousPool. setBicarbonateAmount:[venousPool. bicarbonateAmount]+xnew + [venousPool.addBicarb]];
		[tissues.setBicarbonateAmount:[tissues.bicarbonateAmount]-xnew];
		
		// Do the venous oxygen and CO2 content changes
		[venousPool.setOxygenContent:[venousPool.amountOfOxygen]*c2];
		[venousPool.setCarbonDioxideContent:[venousPool.amountOfCO2]*c2];
		
		// Calculate bicarb content after infusion but before delay line
		[venousPool.setBicarbonateContent:[venousPool.bicarbonateAmount]*c1+([tissues.pCO2]-40)*c3-[tissues.TC3AJ]];
		XC2PR = [tissues.pCO2];
		if ([venousPool.bicarbonateAmount]<=0) NSLog(@"We have a big fucking arithmetic problem in venous bicarb!");
		
		// Call DELAY - will put this inline here.  New Year Day 2:13 PM
		
		nft = (int) (9*pow([heart.effectiveCardiacOutput], 0.75)*ft+0.5);
		nft = (nft < 1) ? 1 : nft;
		nft = (nft > 10) ? 10 : nft;
		m = pntdly + nft - 1;
		for(iter = pntdly; iter <= m; ++iter) {
			// NSLog(@"The var iter is %i.\n", iter);
			n = iter;
			if (n > 10) n = n - 10;
			veinDelay[n - 1] = [venousPool.oxygenContent];
			veinDelay[n + 9] = [venousPool.carbonDioxideContent];
			veinDelay[n + 19] = [venousPool.bicarbonateContent];
			veinDelay[n + 29] = XC2PR;
		}
		n = pntdly + nft;
		if (n > 10) n = n - 10;
		[venousPool.setOxygenContent:veinDelay[n - 1]];
		[venousPool.setCarbonDioxideContent:veinDelay[n+9]];
		[venousPool.setBicarbonateContent:veinDelay[n+19]];
		XC2PR = veinDelay[n+29];
		pntdly = n;
		
		// Should be the end of the delay loop
		// I have set up the setPh procedure to expect to use the bicarb and pCO2 from the SAME object
		// and this is usually right, but if I need to pass other parameters I have to fool it, as shown here:
		// The call in Macpuf is to PHFNC(VC3CT, XC2PR) instead of (VC3CT, VC2PR)
		
		[venousPool. updatePh:[venousPool.bicarbonateContent]
		CO2:XC2PR];
		
		// Next section concerns gas exchange in lungs.  PC is fraction of cardiac output perfectly mixed with
		// alveolar gases.  U and V are amounts of each gas taken in per unit fraction time (ft).
		
		pc = [heart.decilitersPerIteration]*c14*pc;
		x = [lungs.alveolarVentilationPerIteration]*c12;
		u = x * [lungs.FiO2];
		v = x * [lungs.FiCO2];
		
		// Calculate the amounts of each gas in the lungs.  W is the volume at end of nominal inspiration.
		
		[lungs.setAmountOfOxygen:[lungs.amountOfOxygen]+u];
		[lungs.setAmountOfCO2:[lungs.amountOfCO2]+v];
		[lungs.setAmountOfNitrogen:[lungs.amountOfNitrogen]+x*(100 - [lungs.FiO2] - [lungs.FiCO2])];
		w = [lungs.amountOfOxygen]+[lungs.amountOfCO2] + [lungs.amountOfNitrogen];
		
		// Now calculate partial pressures in the alveoli
		
		x = c11 / w;
		po2 = [lungs.amountOfOxygen]*x;		// These local copies of pO2 and pCO2 are used later
		pc2 = [lungs.amountOfCO2]*x;		// in the simulation loop.
		
		// Change alveolar gas amounts in accordance with blood gas contents entering from veins
		// and leaving the lungs.  PC = final amount of total gas at the end of everything.
		
		[lungs.setAmountOfOxygen:[lungs.amountOfOxygen] + pc*([venousPool.oxygenContent]-[lungs.oxygenContent])];
		[lungs.setAmountOfCO2:[lungs.amountOfCO2] + pc*
		([venousPool.carbonDioxideContent]-[lungs.carbonDioxideContent])];
		[lungs.setAmountOfNitrogen:[lungs.amountOfNitrogen] + pc *
		([tissues.pN2]*0.00127 - [arteries.effluentNitrogenContent])];
		pc = [lungs.amountOfOxygen]+[lungs.amountOfCO2] + [lungs.amountOfNitrogen];
		
		// In next section, FY becomes positive only if more gas goes out than in, in which case FY is later
		// brought into the calculation of effective dead space
		
		//   if (pl == 2) {
		//       fy = ([lungs.alveolarVentilationPerIteration]>= 20) ? (pc-w)*c34/[lungs.respiratoryRate]:0;
		//   }
		
		if (pl != 2) {
			if ([lungs.alveolarVentilationPerIteration]>=20) {
				fy = (pc-w)*c34/[lungs.respiratoryRate];
			}
		}
		else
		fy = 0;
		
		if (pl < 0) {
			// CALL BAGER (5, PC, X, C12, MMENU)  LINE 790
			NSLog(@"Call Bager from line 790");
		}
		
		// XVENT is volume exhaled in nominal time ft down to resting lung volume.  If this is negative
		// then there must be diffusion respiration in which case we have to do the relevant sections
		// that were in FORTRAN lines 720 and 730 - but I have moved them inline here to make more sense.
		
		[lungs.setExhaledVentilation:pc*c35 - [lungs.totalLungVolume]];
		
		if ([lungs.exhaledVentilation] < 0) {
			fd = [lungs.exhaledVentilation]*c12;
			[lungs.setAmountOfOxygen:[lungs.amountOfOxygen] - fd * [lungs.FiO2]];
			[lungs.setAmountOfCO2:[lungs.amountOfCO2] - fd * [lungs.FiCO2]];
			[lungs.setAmountOfNitrogen:[lungs.amountOfNitrogen]- fd * z];
		}
		else {
			x = [lungs.exhaledVentilation]*c25;
			[lungs.setTotalVentilation:x/pc];
			x = x/c11;
			y = x * [lungs.pO2];
			z = x * [lungs.pCO2];
			pc = x*(c11 - [lungs.pO2] - [lungs.pCO2]);
			
			//[lungs.setTotalVentilation:[lungs.exhaledVentilation]*c25/pc]; 	// OLD version
			//y = [lungs.totalVentilation]*[lungs.amountOfOxygen];			// I think no difference
			//z = [lungs.totalVentilation]*[lungs.amountOfCO2];
			//pc = [lungs.totalVentilation]*[lungs.amountOfNitrogen];
			qa = (u - y)/ft;
			qb = (z - v)/ft;
			//qa = u - y;
			//qb = z - v;
			if (pl > 0.5) {
				//CALL BAGER (4, XVENT, X, C12, MMENU)  LINE 820
				NSLog(@"Call BAGER from line 820");
				if (x < -9000) NSLog(@"We have a bad fucking arithmetic problem in Fortran line 820!");
			}
			
			
			if ([lungs.alveolarVentilationPerIteration] < e) {
				qa = 0.001;
				qb = e;
			}
			// Set the new amounts of gas
			[lungs.setAmountOfOxygen:(([lungs.amountOfOxygen]-y)>0.01) ? [lungs.amountOfOxygen] - y : 0.01];
			[lungs.setAmountOfCO2:(([lungs.amountOfCO2]-z) > 0.01) ? [lungs.amountOfCO2] - z : 0.01];
			[lungs.setAmountOfNitrogen:(([lungs.amountOfNitrogen]-pc)>0.01) ? [lungs.amountOfNitrogen] - pc : 0.01];
		}
  
		
		// FORTRAN line 850 !
		u = c11/([lungs.amountOfOxygen]+[lungs.amountOfCO2] + [lungs.amountOfNitrogen]);
		
		// Take account of inspiratory to expiratory duration ratio
		v = c37/[lungs.respiratoryRate];
		v = (v > 4) ? 4 : v;
		if ([lungs.alveolarVentilationPerIteration] < 20) v = 0;
		
		
		// Speed of change (x) of alveolar gas tensions is function of tidal volume
		x = ([lungs.tidalVolume]+100)*c38;
		// compute end expiratory partial pressures
		y = [lungs.amountOfOxygen]*u;
		z = [lungs.amountOfCO2] * u;
		[lungs.setPO2:
		[lungs.dampChange:(y+(po2 - y)*v)
		oldValue:[lungs.pO2]
		dampConstant:x]];
		
		[lungs.setPCO2:
		[lungs.dampChange:(z+(pc2-z)*v)
		oldValue:[lungs.pCO2]
		dampConstant:x]];
		if ([lungs.pO2] < 0.00001) [lungs.setPO2:0.00001];
		if ([lungs.pCO2] < 0.00001) [lungs.setPCO2:0.00001];
		
		// Determine respiratory quotient (expired) then alveolar gas tensions and then finally
		// the contents of O2 and CO2 in pulmonary capillary blood
		if (qa != 0) pc = qb/qa;
		//if (qa != 0) [tissues.setRespiratoryQuotient:qb/qa];
		x = [venousPool.bicarbonateContent] + c3*([lungs.pCO2] - XC2PR);
		if (x < e) NSLog(@"We have a bad fucking arithmetic problem in old Fortran line 930");
		// NOTE:  I am skipping some detailed arithmetic traps for now but anticipate having to go back!
		
		
		[lungs.updatePh:x
		CO2:[lungs.pCO2]];
		[lungs.calcContents:temperature:Hct:Hgb:DPG];
		
		// Now determine cerebral blood flow adjustments in relation to cardiac output and brain pH (pCO2 sensitive)
		z = sqrt([heart.effectiveCardiacOutput])*0.5;
		if (z > 1) z = 1;
		// Increase CBF for falling O2 saturation - pj was stored earlier and is 100*sat
		y = (7.40 - [brain.pH])*([brain.pCO2]*0.0184-[brain.bicarbDeviation]*0.1)*(117-pj)*0.05;
		if (y > 0) y = 300*pow(y,2);
		if (y > 4.4) y = 4.4;
		[brain.setBloodFlow:
		[brain.dampChange:(y-.12)*42.8*z+[brain.C2CHN]*7
		oldValue:[brain.bloodFlow]*z
		dampConstant:c76]];
		if ([heart.effectiveCardiacOutput]*2 > [brain.bloodFlow]) [brain.setBloodFlow:[heart.effectiveCardiacOutput]*2];
		
		// Compute brain gas amts by metab assuming RQ of 0.98 and allowing for different amts supplied by arterial blood
		// and leaving in venous blood.  Check for arithmetic errors and then calc brain gas tensions from
		// guesstimated dissocation curves.
		y = [brain.bloodFlow] * c39;
		x = c41 * ([brain.oxygenationIndex] + 0.25);
		z = x;
		if ([brain.pO2] <= 18) {
			z = x * ([brain.pO2] * 0.11 - 1);
			x = x*(19-[brain.pO2]);
			if (z < 0) z = 0;
		}
		
		[brain.setAmountOfOxygen:[brain.amountOfOxygen]+y*([arteries. oxygenContent]-[brain.oxygenContent])
		-2 * z *([brain.oxygenationIndex]+0.1)];
		if ([brain.amountOfOxygen] < 0.1) [brain.setAmountOfOxygen:0.1];
		
		[brain.setAmountOfCO2:[brain.amountOfCO2]+y*([arteries. carbonDioxideContent]-[brain.carbonDioxideContent])
		+ 2.15*x];
		[brain.setPO2:[brain.amountOfOxygen]*1.6];
		[brain.setPCO2:[brain.amountOfCO2]*0.078];
		w = [brain.pCO2] - 40;
		y = [brain.bicarbonateContent] + [brain.bicarbDeviation] + 0.2*w;
		
		// Small proportion of added bicarbnate is added also to CSF, affecting breathing appropriately
		[brain.setBicarbDeviation:[brain.bicarbDeviation] + (([arteries. bicarbonateContent]-24)*0.3 -
		[brain.bicarbDeviation])*c42];
		
		// Adjust bicarb to pCO2 then calc brain pH (i.e. pH at the receptors).  Then determine contents
		// of O2 and CO2 in blood leaving the brain.
		
		x = 6.1 + log10((2*y+[arteries. bicarbonateContent])/((2*[brain.pCO2]+[arteries. pCO2])*0.03));
		z = pow(((abs_r(x - [brain.pH])+e)*100),2)+.04;
		if (z > c17) z = c17;
		
		// Restrict rate of change of brain receptor pH
		// Fortran line 1080  NOTE that setpH is NOT same function as setPh!!
		[brain.setPH:
		[brain.dampChange:x
		oldValue:[brain.pH]
		dampConstant:z]];
		z = 6.1 + log10(([venousPool.bicarbonateAmount]*c1+([brain.pCO2]-40)*c3)/([brain.pCO2]*0.03));
		xc2 = [brain.pH];
		[brain.setPH:z];
		[brain.calcContents:temperature:Hct:Hgb:DPG];
		[brain.setPH:xc2];
		
		// Now we have some ventilation calculations, which hopefully will close the loop on old Puf.
		if ([myVentilator On]) [lungs.setTotalVentilation:c51];
		
		// Natural ventilation controls total vent (U and SVENT) = sum of central CO2 chemoreceptor drive
		// (slope x, intercept z) O2 lack receptor (slope y) central neurogenic drive (proportional to
		// oxygen consumption, etc.) and chemoceptors take account of rapid changes in CO2 as well as O2 and sat.
		// Fortran Line 1100
		
		y = (118 - pj)*0.05 + [brain.C2CHN]*0.05+[venousPool.addBicarb]*.2;
		z = y * 0.002;
		x = (c65 + z - [brain.pH])*1000*y;
		if (x < 0) x = 0;
		w = (c66 + z - [brain.pH])*150*y;
		// High brain pH or low CO2 only inhibits ventilation if learnt intrinsic drive (cz) is reduced or gone
		if (w < 0) {
			if (c67 > 0) w = 0;
		}
		z = ([brain.pCO2] - 120) * 0.25;
		if (z < 0) z = 0;
		y = (98 - pj)*([arteries.pCO2]-25)*.12;
		if (y < 0) y = 0;
		
		// Index of brain oxygenation lowers and stops breathing eventually if too low
		u = [brain.amountOfOxygen] - 10;
		u = (u <0) ? 0 : 1;
		[brain.setOxygenationIndex:
		[brain.dampChange:u
		oldValue:[brain.oxygenationIndex]
		dampConstant:c63]];
		// Prevent immediate changes in specified vent capacity
		XRESP = [self dampChange:c46
		oldValue:XRESP
		dampConstant:c68];
		// Compute total additive effects of ventilatory stimuli
		u = (c44*(x + w) + c45 * y + XRESP - z)*c47;
		if (u > c6) u = c6;  // restrict to a maximum value stored in c6
		
		// Damp the speed of response according to cardiac output and depth of breathing, include brain oxygenation index
		x = ([heart.effectiveCardiacOutput]+5)*c62/([lungs.tidalVolume]+400);
		[lungs.setEffectiveVentResponse:[brain.oxygenationIndex]*
		[self dampChange:u
		oldValue:[lungs.effectiveVentResponse]
		dampConstant:x]];
		
		// NOW A SERIOUS RAT NEST OF FORTRAN IF STATEMENTS:
		
		if (pl < 0) {
			[lungs.setTotalVentilation:e];
			[lungs.setRespiratoryRate:0.0001];
		}
			
		else { // pl > = 0
			if (([lungs.effectiveVentResponse] < c48) && [myVentilator Off]) {
				[lungs.setTotalVentilation:e];
				[lungs.setRespiratoryRate:0.0001];
			}
			else { // effectiveVentResponse must be > c48 but the ventilator could be on or off so we test
				if ([myVentilator Off]){
					[lungs.setTotalVentilation:[lungs.effectiveVentResponse]];
					[lungs.setRespiratoryRate:(c49 + pow([lungs.totalVentilation], 0.7)*0.37)*c50/(pj+40)];
				}
			}
			if (([lungs.respiratoryRate] > 1) && ([heart.effectiveCardiacOutput] > 0.5)) {
				u = [lungs.pO2] * 0.15;
				u = (u > 70) ? 70 : u;
				[lungs.setDeadSpace:[self dampChange:(c52+[lungs.totalVentilation]*100 / pow([lungs.respiratoryRate],1.12) + 20 * [lungs.totalVentilation]/([heart.effectiveCardiacOutput]+5)+u+fy+c54*([lungs.tidalVolume]+500))
					oldValue:[lungs.deadSpace]
					dampConstant:c55]];
			}
		}
		
		
		[lungs.setTidalVolume:[lungs.totalVentilation]*1000/[lungs.respiratoryRate]];
		if([myVentilator Off]) {
			[lungs.setTidalVolume:([lungs.tidalVolume]>c20) ? c20 : [lungs.tidalVolume]];
			[lungs.setRespiratoryRate:[lungs.totalVentilation]*1000/[lungs.tidalVolume]];
		}
		
		[lungs.setAlveolarVentilationPerIteration:[lungs.respiratoryRate]*([lungs.tidalVolume] - [lungs.deadSpace]) * ft];
		if ([lungs.alveolarVentilationPerIteration] <= 0) [lungs.setAlveolarVentilationPerIteration:e];
		[lungs.setAlveolarMinuteVent:[lungs.alveolarVentilationPerIteration]*c56];
		
		[brain.setSymptomFlag:([brain.oxygenationIndex]>0.3) ? [brain.symptomFlag]- [brain.oxygenationIndex]*c59
		: [brain.symptomFlag] - ([brain.oxygenationIndex]-1)*c58];
		// CALL DEATH
		
		BARRF = c11;
		
		
		// At end of simulation run (iterations) re-zero the added bicarbonate or acid variable so it won't add again
		if (i == iterations) [venousPool. setAddBicarb:0];
		
		
	}
	
}
