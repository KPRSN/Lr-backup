//
//  Backup.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-08.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

// Backup handler
class Backup: NSObject {
	var tasks: Array<NSTask> = []
	var error: Bool = false
	
	var status: String = ""
	var running: Bool = false {
		didSet {
			// Notify delegates of backup
			NSNotificationCenter.defaultCenter().postNotificationName("BackupRunningNotification", object: self)
		}
	}
	
	func run() {
		if !running {
			if validatePreferences() {
				error = false
				status = "Running"
				running = true
				
				Logger.log("Backup started")
				
				// Generate backup tasks
				tasks = RsyncTaskGenerator.generate()
				
				// Notify on task termination
				NSNotificationCenter.defaultCenter().addObserver(
					self,
					selector: Selector("taskDidTerminate:"),
					name: NSTaskDidTerminateNotification,
					object: nil)
				
				// Start backup
				nextTask()
			}
			else {
				// Validation failed
				status = Logger.failed()
				error = true
				running = false
			}
		}
	}
	
	func cancel() {
		if running {
			if tasks.count > 0 {
				tasks[0].terminate()
			}
			running = false
		}
	}
	
	// Backup task finished
	func taskDidTerminate(sender: AnyObject?) {
		// Close output pipes
		tasks[0].standardOutput!.fileHandleForReading.readabilityHandler = nil
		tasks[0].standardError!.fileHandleForReading.readabilityHandler = nil
		
		// Remove task
		tasks.removeAtIndex(0)
		
		// Remove all tasks if there is an error
		if error {
			tasks = []
		}
		
		nextTask()
	}
	
	// Run next task in queue (or finish backup if done)
	func nextTask() {
		if tasks.count > 0 {
			// Configure pipes
			let task = tasks[0]
			
			// Pipe output
			task.standardOutput = NSPipe()
			task.standardOutput!.fileHandleForReading.readabilityHandler = { (file: NSFileHandle) -> Void in
				let data: NSData = file.availableData
				let output: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
				Logger.log(output as String)
			}
			
			// Pipe error
			task.standardError = NSPipe()
			task.standardError!.fileHandleForReading.readabilityHandler = { (file: NSFileHandle) -> Void in
				self.error = true
				let data: NSData = file.availableData
				let output: NSString = NSString(data: data, encoding: NSUTF8StringEncoding)!
				Logger.error(output as String)
			}
			
			task.launch()
		}
		else {
			// Remove observer
			NSNotificationCenter.defaultCenter().removeObserver(self)
			
			if error {
				status = Logger.failed()
			}
			else {
				// Backup successful
				Defaults.lastBackup = NSDate()
				Logger.succeeded()
			}
			
			running = false
		}
	}
	
	// Validate backup preferences
	func validatePreferences() -> Bool {
		// Check for missing fields/preferences
		if (Defaults.source?.characters.count < 1) {
			Logger.error("Source missing")
			return false
		}
		
		if (Defaults.destination?.characters.count < 1) {
			Logger.error("Destination missing")
			return false
		}
		
		if (Defaults.ssh!) {
			if (Defaults.host?.characters.count < 1) {
				Logger.error("SSH host misssing")
				return false
			}
			
			if (Defaults.user?.characters.count < 1) {
				Logger.error("SSH user missing")
				return false
			}
		}
		
		// Check for recursive source/destination
		if (!Defaults.ssh!) {
			if (Defaults.destination!.hasPrefix(Defaults.source!)) {
				Logger.error("Recursive backup: Destination is part of the source")
				return false
			}
		}
		return true
	}
}
