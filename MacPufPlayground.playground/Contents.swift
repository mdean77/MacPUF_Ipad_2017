//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let macpuf = Simulator()
macpuf.iterations = 180
macpuf.intervalFactor = 1
macpuf.simulate()
macpuf.intervalFactor = 10
macpuf.simulate()
macpuf.intervalFactor = 10
macpuf.simulate()


