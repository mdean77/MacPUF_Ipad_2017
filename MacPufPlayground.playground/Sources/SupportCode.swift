//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to MacPufPlayground.playground.
//
import Foundation

class DamperObject {
	
	func dampChange(newValue:Double, oldValue:Double, dampConstant:Double) -> Double {
		return (newValue * dampConstant + oldValue)/(dampConstant + 1)
	}
	
}