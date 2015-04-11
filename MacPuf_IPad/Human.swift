//
//  Human.swift
//  MacPuf_IPad
//
//  Created by J Michael Dean on 4/11/15.
//  Copyright (c) 2015 J Michael Dean. All rights reserved.
//

import Foundation

class Human: DamperObject{
	
	let arteries: ArterialPool
	let heart: Heart
	let bag: Bag
	let venousPool: VenousPool
	
	override init(){
		arteries = ArterialPool()
		heart = Heart()
		bag = Bag()
		venousPool = VenousPool()
		
	}
	
	func dummy(){
			arteries.effluentCO2Content = 99
		println("Value of resting cardiac output is \(heart.restingCardiacOutput)")
	}
}