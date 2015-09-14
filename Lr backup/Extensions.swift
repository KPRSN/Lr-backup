//
//  Extensions.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-12.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Foundation

// Int to bool extension
extension Bool {
	init<T : IntegerType>(_ integer: T) {
		self.init(integer != 0)
	}
}

// Bool to int extension
extension Int {
	init<T : BooleanType>(_ bool: T) {
		if bool {
			self.init(1)
		}
		else {
			self.init(0)
		}
	}
}