//: Playground - noun: a place where people can play

import Foundation
@testable import MacPUFFramework

let temperature = 38.0
let DPG = 3.7843
let Hct = 45.0
let Hgb = 14.8

let met = Metabolizer()
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

met.calculateContents()

met.calculateContents(temperature, DPG: DPG, Hct: Hct, Hgb: Hgb)
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

