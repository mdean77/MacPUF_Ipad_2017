//: Playground - noun: a place where people can play

import Foundation

class DamperObject {
	
	func dampChange(newValue:Double, oldValue:Double, dampConstant:Double) -> Double {
		return (newValue * dampConstant + oldValue)/(dampConstant + 1)
	}
	
}

class Metabolizer: DamperObject {
	
	
	var amountOfOxygen:Double
	var	pO2:Double
	var	oxygenContent:Double
	var	oxygenSaturation:Double
	var	amountOfCO2:Double
	var	pCO2:Double
	var	carbonDioxideContent:Double
	var	bicarbonateContent:Double
	var	pH:Double
	
	override init(){
		(amountOfOxygen, pO2,oxygenContent,oxygenSaturation,amountOfCO2,pCO2,carbonDioxideContent,bicarbonateContent,pH) = (0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
	}
	
	// sign(f,g) = sgn(g) * abs(f)
	func sign(op1:Double, op2:Double) -> Double {
		return op2 < 0 ? -abs(op1) : abs(op1)
	}
	
	// This method replaces the MacPuf GASES subroutine.  It accepts any values of pO2, pCO2 and pH and
	// works out O2 and CO2 contents and the saturation of O2.  It also needs values for temperature,
	// hematocrit, hemoglobin and DPG.  Since these values are usually normal I have provided default values
	// but these can be overridden if the developer allows these parameters to be changed by the user.
	
	func calculateContents(temperature:Double = 37.0,DPG:Double = 3.7843,
		Hct:Double = 45.0, Hgb:Double = 14.8){
			
			// Series of constants needed for the Kelman equations
			let a1 = -8.532229E3
			let a2 = 2.121401E3
			let a3 = -6.707399E1
			let a4 = 9.359609E5
			let a5 = -3.134626E4
			let a6 = 2.396167E3
			let a7 = -6.710441E1
			
			var (p, pk, dox, x, t, sol) = (0.0, 0.0,0.0,0.0,0.0,0.0)
			var (dr, cp, cc, h, sat, a, b, c, dph) = (0.0, 0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)
			
			// Original FORTRAN: X=PO2*10.**(.4*(PH-DPH)+.024*(37.-TEMP)+.026057699*(ALOG(40./PC2)))
			
			dph = 7.4 + (DPG - 3.8) * 0.25
			dph = (dph > 7.58) ? 7.58 : dph
			a = 0.4*(pH - dph)
			b = 0.024*(37.0-temperature)
			c = 0.026057699 * (log(40.0/pCO2))
			x = pO2*pow(10.0,(a + b + c ))
			x = (x < 0.01) ? 0.01 : x   // Make sure x is at least greater than 0.01
			sat = (x >= 10) ? (x*(x*(x*(x+a3)+a2)+a1))/(x*(x*(x*(x+a7)+a6)+a5)+a4) : (0.003683+0.000584*x)*x
			p = 7.4 - pH
			pk = 6.086 + p * 0.042 + (38.0 - temperature) * (0.00472 + 0.00139 * p)
			t = 37.0 - temperature
			sol = 0.0307+(0.00057+0.00002*t)*t
			dox = 0.590 + (0.2913-0.0844*p)*p
			dr = 0.664+(0.2275-0.0938*p)*p
			t = dox + (dr - dox) * (1 - sat)
			cp = sol*pCO2*(1+pow(10, pH - pk))
			cc = t * cp
			h = Hct * 0.01
			
			var saturation = sat
			var o2Content = Hgb*sat*1.34 + 0.003*pO2
			o2Content = (o2Content < 0.001) ? 0.001 : o2Content
			var co2Content = (cc*h+(1-h)*cp)*2.22
			co2Content = (co2Content < 0.001) ? 0.001 : co2Content
			
			oxygenContent = o2Content
			carbonDioxideContent = co2Content
			oxygenSaturation = saturation
	}
}

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
	
	
	
	// This method replaces the MacPuf GSINV subroutine.  It accepts values of O2 and CO2 content and using
	// successive approximation it iterates to the respective partial pressures.  I am using exactly the same logic
	// as the original version but have tried to make it clear how it works.
	
	func calculatePressures(oxygenContent:Double, carbonDioxideContent:Double, pO2initial:Double,
		pCO2initial:Double, pH:Double, temperature:Double = 37.0, DPG:Double = 3.7842, Hct:Double = 45.0,
		Hgb: Double = 14.8){
			
			let err = 0.01
			var (trialO2Content, trialCO2Content) = (0.0, 0.0)
			var (deltaOxygen1, deltaOxygen2, deltaCarbonDioxide1, deltaCarbonDioxide2) = (0.0,0.0,0.0,0.0)
			var (guessOxygen1, guessOxygen2, guessCarbonDioxide1, guessCarbonDioxide2) = (0.0,0.0,0.0,0.0)
			
			// Flags to track status of iterators
			//	ICH3 is a flag that indicates a bracket is being pursued for pO2
			//	ICH1 is a flag that indicates if pO2 is adequately approximated (ICH1 = 0)
			//	ICH4 is a flag that indicates a bracket is being pursued for pCO2
			//	ICH2 is a flag that indicates if pCO2 is adequately approximated (ICH2 = 0)
			var (ich1, ich2, ich3, ich4) = (1,1,1,1)
			
			// Magnitudes of iterative change
			var (D1Z, D2Z, D1, D2, DS) = (2.0, 2.0, 0.0, 0.0, 0.0)
			var x = 0.0
			
			var pO2 = pO2initial		//set initial estimate as what was fed in from MacPuf
			var pCO2 = pCO2initial	//set initial estimate as what was fed in from MacPuf
			
			do {
				// Do the first estimation by calling calculateContents with these initial guesses
				calculateContents(temperature:temperature, DPG:DPG, Hct:Hct, Hgb:Hgb)
				
				// Calculate the delta, but must be non-zero or we will get division by zero error later
				deltaOxygen2 = (trialO2Content - oxygenContent) == 0 ?  0.001 : trialO2Content - oxygenContent
				
				deltaCarbonDioxide2 = (trialCO2Content - carbonDioxideContent) == 0 ? 0.001 : trialCO2Content - carbonDioxideContent
				
				guessOxygen2 = pO2
				guessCarbonDioxide2 = pCO2
				
				if (ich3 == 1) {
					ich3 = 0
					D1 = sign(D1Z, op2: -deltaOxygen2)
				}
				
				if (ich4 == 1) {
					ich4 = 0
					D2 = sign(D2Z, op2: -deltaCarbonDioxide2)
				}
				// check for convergence
				if (abs(deltaOxygen2) < err) {
					ich1 = 0
				}
				if (abs(deltaCarbonDioxide2) < err) {
					ich2 = 0
				}
				if ((ich1 + ich2) == 0) {
					return
				}
				
				DS = D1 * Double(ich1)		// clever way to suppress further changes if already converged
				x = pO2 + DS - pO2 * 0.25;
				if (x<0) {
					DS = -pO2 * 0.75;
				}
				pO2 = pO2 + DS;		// new pO2 value to try.  This directly changes the object pO2.
				
				DS = D2 * Double(ich2)
				x = pCO2 + DS - pCO2 * 0.25;
				if (x<0) {
					DS = -pCO2 * 0.75;
				}
				pCO2 = pCO2 + DS;		// new pCO2 value to try.  This directly changes the object pCO2.
				
				if (pO2 < 0.1) {
					pO2 = 0.1;
				}
				if (pCO2 < 0.1) {
					pCO2 = 0.1;
				}
				
				calculateContents(temperature:temperature, DPG:DPG, Hct:Hct, Hgb:Hgb)
				
				// Calculate the delta, but must be non-zero or we will get division by zero error later
				deltaOxygen1 = deltaOxygen2
				deltaOxygen2 = (trialO2Content - oxygenContent) == 0 ?  0.001 : trialO2Content - oxygenContent
				
				deltaCarbonDioxide1 - deltaCarbonDioxide2
				deltaCarbonDioxide2 = (trialCO2Content - carbonDioxideContent) == 0 ? 0.001 : trialCO2Content - carbonDioxideContent
				
				guessOxygen1 = guessOxygen2
				guessOxygen2 = pO2
				guessCarbonDioxide1 = guessCarbonDioxide2
				guessCarbonDioxide2 = pCO2
				
				// Check the oxygen content results for suitability
				ich1 = 0;
				if (abs(deltaOxygen2) > err) {
					ich1 = 1;		// Not done
					
					if ((deltaOxygen2 * D1) > 0) {
						ich3 = 1;
						pO2 = guessOxygen1 + (guessOxygen2 - guessOxygen1)*abs(deltaOxygen1)/(abs(deltaOxygen2)+abs(deltaOxygen1));
						D1Z = D1Z * 0.5;
					}
					
					if ((deltaOxygen2 * D1) < 0) {
						D1 = (guessOxygen2 == guessOxygen1) ? sign(D1Z, op2: -deltaOxygen2) : (guessOxygen2 - guessOxygen1)*abs(deltaOxygen2)/abs(deltaOxygen2 - deltaOxygen1);
					}
				}
				
				// Check the carbon dioxide content results for suitability
				ich2 = 0;
				if (abs(deltaCarbonDioxide2) > err) {
					ich2 = 1;
					
					if ((deltaCarbonDioxide2 * D2) > 0) {
						ich4 = 1;
						pCO2 = guessCarbonDioxide1 + (guessCarbonDioxide2 - guessCarbonDioxide1)*abs(deltaCarbonDioxide1)/(abs(deltaCarbonDioxide2)+abs(deltaCarbonDioxide1));
						D2Z = D2Z * 0.5;
					}
					
					if ((deltaCarbonDioxide2 * D2) < 0) {
						D2 = (guessCarbonDioxide2 == guessCarbonDioxide1) ? sign(D2Z, op2: -deltaCarbonDioxide2) : (guessCarbonDioxide2 - guessCarbonDioxide1)*abs(deltaCarbonDioxide2)/abs(deltaCarbonDioxide2 - deltaCarbonDioxide1);
					}
				}
				
			} while (ich1 + ich2) != 0
			
			return
	}
	
	
}

class VenousPool: Metabolizer {
	
	var	bicarbonateAmount:Double = 0.0			// MacPuf variable VC3MT  Factor 86
	var	addBicarb:Double = 0.0							// additional bicarbonate, use negative to give acid
	// In venous pool because is administered there
	// MacPuf variable ADDC3  Factor 21
	var	venousBloodVolume:Double = 0.0			// MacPuf variable VBLVL  Factor 20
	
	override init(){
		super.init()
		amountOfOxygen = 434.7640
		//pO2 = 40.0;  Irrelevant I think because will be back calculated
		oxygenContent = 14.4921
		oxygenSaturation = 0									// value made up - needs to be connected to simulator
		amountOfCO2 = 1543.2665
		//pCO2 = 45.7; Irrelevant I think because will be back calculated
		carbonDioxideContent = 51.4422
		bicarbonateContent = 25.4605
		bicarbonateAmount = 71.2432
		addBicarb = 0.000
		pH = 7.3710
		venousBloodVolume = 3000.000
		
	}
	
	
}

class Heart : Metabolizer {
	
	var	cardiacFunction:Double = 0.0										// MacPuf variable CO		Factor 3
	var	effectiveCardiacOutput:Double = 0.0             // MacPuf variable COADJ	Factor 93
	var	maximumCardiacOutput:Double = 0.0               // MacPuf variable COMAX	Factor 27
	var	restingCardiacOutput:Double = 0.0               // MacPuf variable CONOM	Factor 82
	var	leftToRightShunt:Double = 0.0										// MacPuf variable SHUNT	Factor 28
	var	rightToLeftShunt:Double = 0.0										// MacPuf variable FADM		Factor 5
	var	admixtureEffect:Double = 0.0										// MacPuf variable VADM		Factor 9
	var	effectiveVenousAdmixture:Double = 0.0           // MacPuf variable PW		Factor 80
	var	decilitersPerIteration:Double = 0.0             // MacPuf variable FTCO
	var	fitnessAdjustedOutputPerIteration:Double = 0.0	// MacPuf variable FTCOC
	
	
	
	override init(){
		super.init()
		cardiacFunction = 100.000;
		effectiveCardiacOutput = 4.9528;
		maximumCardiacOutput = 35.0000;
		restingCardiacOutput = 4.6000;
		leftToRightShunt = 0.000;
		rightToLeftShunt = 0.000;
		admixtureEffect = 3.0000;
		effectiveVenousAdmixture = 2.3618;
		decilitersPerIteration = 0.82546666; // assumes ft = 1/60 and is deciliters per iteration
		fitnessAdjustedOutputPerIteration = 0.80895;
	}
}

class Bag {
	
	var volume:Double = 0.0						// MacPuf variable BAG   Factor 116
	var carbonDioxide:Double = 0.0		// MacPuf variable BAGC  Factor 38
	var oxygen:Double = 0.0						// MacPuf variable BAGO  Factor 37
	
	func setupWithVolume(volume:Double, carbonDioxide:Double, oxygen:Double){
		self.volume = volume
		self.carbonDioxide = carbonDioxide
		self.oxygen = oxygen
	}
}

class Human: DamperObject{
	
	let arteries: ArterialPool
	let heart: Heart
	let bag: Bag
	let venousPool: VenousPool
	
	override init(){
		arteries = ArterialPool()
		heart = Heart()
		bag = Bag()
		venousPool = VenousPool()
		
	}
	
	func dummy(){
		arteries.effluentCO2Content = 99
		println("Value of resting cardiac output is \(heart.restingCardiacOutput)")
	}
}

let human = Human()
human.heart.restingCardiacOutput
human.arteries.calculateContents()
human.arteries.pO2 = 9
human.arteries.calculateContents()
human.heart.oxygenContent
human.heart.pO2
human.arteries.pO2
human.heart.pO2
human.arteries.oxygenContent = 20
human.arteries.calculatePressures(oxygenContent:arteries.oxygenContent, carbonDioxideContent: carbonDioxideContent, pO2initial: 0, pCO2initial: 0, pH: 7.4, temperature: 37, DPG: 3.7842, Hct: 45, Hgb: 14.8)
