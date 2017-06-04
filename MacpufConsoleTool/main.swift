//
//  main.swift
//  MacpufConsoleTool
//
//  Created by J Michael Dean on 5/28/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation
print("Hello World")
let macpuf = Simulator()
macpuf.iterations = 60
macpuf.intervalFactor = 1
print("Iterations = \(macpuf.iterations)")
print("Interval factor = \(macpuf.intervalFactor)")
macpuf.simulate()

