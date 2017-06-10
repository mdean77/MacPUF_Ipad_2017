//
//  main.swift
//  MacpufConsoleTool
//
//  Created by J Michael Dean on 5/28/17.
//  Copyright © 2017 J Michael Dean. All rights reserved.
//

import Foundation
let macpuf = Simulator()
macpuf.iterations = 180
macpuf.intervalFactor = 10
macpuf.simulate()
macpuf.human.lungs.FiO2 = 10
macpuf.simulate()

