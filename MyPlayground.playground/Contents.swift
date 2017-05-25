//: Playground - noun: a place where people can play


import Foundation

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

var myBag = Bag()
myBag.setupWithVolume(350, carbonDioxide: 0, oxygen: 100)
myBag

