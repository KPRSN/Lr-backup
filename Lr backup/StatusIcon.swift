//
//  StatusIcon.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-11-10.
//  Copyright © 2015 Karl Persson. All rights reserved.
//
//	Class for handling and animating the status bar icons
//

import Cocoa

class StatusIcon: NSObject {
	var button: NSButton!
	var animationTimer: NSTimer!
	
	let idleImage = NSImage(named: "Icon-idle")
	let runningImages = [NSImage(named: "Icon-running1"), NSImage(named: "Icon-running2")]
	let errorImage = NSImage(named: "Icon-error")
	
	init(button: NSButton) {
		super.init()
		self.button = button
		
		// Set as templates to ensure that it will work with dark theme
		idleImage?.template = true
		errorImage?.template = true
		for image in runningImages {
			image!.template = true
		}
		
		idle()
	}
	
	func idle() {
		animationTimer?.invalidate()
		button.image = NSImage(named: "Icon-idle")
	}
	
	func running() {
		animationTimer?.invalidate()
		button.image = NSImage(named: "Icon-running1")
		animationTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "updateRunning", userInfo: nil, repeats: true)
	}
	
	func error() {
		animationTimer?.invalidate()
		button.image = NSImage(named: "Icon-error")
		animationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateError", userInfo: nil, repeats: true)
	}
	
	// Icon animations
	func updateError() {
		if button.image == errorImage {
			button.image = idleImage
		}
		else {
			button.image = errorImage
		}
	}
	
	func updateRunning() {
		if button.image == runningImages[0] {
			button.image = runningImages[1]
		}
		else {
			button.image = runningImages[0]
		}
	}
}
