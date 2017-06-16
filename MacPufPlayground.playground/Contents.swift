//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let macpuf = Simulator()
macpuf.iterations = 180
macpuf.intervalFactor = 10
macpuf.simulate()
macpuf.human.lungs.FiO2 = 10
macpuf.simulate()





var mike = "Mike"



