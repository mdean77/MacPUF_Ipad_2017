//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let temperature = 38.0
let DPG = 3.7843
let Hct = 45.0
let Hgb = 14.8

let met = Metabolizer()
met.calculateContents()
met.amountOfCO2
met.amountOfCO2
met.amountOfOxygen
met.carbonDioxideContent
met.oxygenContent
met.oxygenSaturation
met.pCO2
met.pH
met.pO2
met.bicarbonateContent

let mike = Human()
mike.arteries.calculateContents()
mike.arteries.amountOfCO2
mike.arteries.amountOfCO2
mike.arteries.amountOfOxygen
mike.arteries.carbonDioxideContent
mike.arteries.oxygenContent
mike.arteries.oxygenSaturation
mike.arteries.pCO2
mike.arteries.pH
mike.arteries.pO2
mike.arteries.bicarbonateContent

mike.venousPool.calculateContents()
mike.venousPool.amountOfCO2
mike.venousPool.amountOfCO2
mike.venousPool.amountOfOxygen
mike.venousPool.carbonDioxideContent
mike.venousPool.oxygenContent
mike.venousPool.oxygenSaturation
mike.venousPool.pCO2
mike.venousPool.pH
mike.venousPool.pO2
mike.venousPool.bicarbonateContent