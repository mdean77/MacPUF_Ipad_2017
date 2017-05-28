//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let macpuf = Simulator()
macpuf.iterations = 60
macpuf.intervalFactor = 10
macpuf.simulate()

macpuf.human.brain
