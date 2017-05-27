//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let macpuf = Simulator()
macpuf.simulate()
macpuf.intervalFactor = 1
macpuf.simulate()
macpuf.intervalFactor = 30
macpuf.simulate()

