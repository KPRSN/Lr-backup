//
//  Logger.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-09.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

class Logger {
	static let appSupportDir: AnyObject = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0]
	static let appDir = appSupportDir.URLByAppendingPathComponent(NSBundle.mainBundle().bundleIdentifier!)
	static let fileDir = appDir.URLByAppendingPathComponent("log.txt")
	
	// Log multiple error rows as string
	static func error(message: String) {
		log(message, error: true)
	}
	
	// Log multiple rows as string
	static func log(message: String, error: Bool = false) {
		// Remove whitespaces and add error messages
		var output: Array<String> = Array<String>()
		for m in message.componentsSeparatedByString("\n") {
			if !isWhitespace(m) {
				if error {
					output.append("[ERROR]: " + m)
				}
				else {
					output.append(m)
				}
			}
		}
		log(output)
	}
	
	// Log multiple rows as array of strings
	static func log(messages: Array<String>) {
		// Time of backup
		let date = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
		let dateString = dateFormatter.stringFromDate(date)
		
		// Add timestamps
		var output: Array<String> = Array<String>()
		for m in messages {
			output.append("[" + dateString + "]: " + m + "\n")
		}
		
		write(output)
	}
	
	// Finish successful backup
	static func succeeded() -> String {
		let message = "Backup done"
		log(message)
		write(["\n"])
		return message
	}
	
	// Finish failed backup
	static func failed() -> String {
		let message = "Backup failed"
		error(message)
		write(["\n"])
		return message
	}
	
	// Write a number of string messages to logfile
	static func write(messages: Array<String>) {
		// Create dir/log if it doesn't exist
		if (createDirectory() && createFile()) {
			let filehandle = NSFileHandle(forWritingToURL: fileDir, error: nil)
			filehandle?.seekToEndOfFile()
			
			var outstring = ""
			for m in messages {
				filehandle!.writeData(m.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
				outstring += m
			}
			
			filehandle?.closeFile()
			
			// Send notification with update
			NSNotificationCenter.defaultCenter().postNotificationName("LogUpdatedNotification", object: outstring)
		}
	}
	
	// Create application support directory if it doesn't exist
	static func createDirectory() -> Bool {
		if (!NSFileManager.defaultManager().fileExistsAtPath(appDir.path!)) {
			return NSFileManager.defaultManager().createDirectoryAtURL(appDir, withIntermediateDirectories: true, attributes: nil, error: nil)
		}
		return true
	}
	
	// Create file if it doesn't exist
	static func createFile() -> Bool {
		if (!NSFileManager.defaultManager().fileExistsAtPath(fileDir.path!)) {
			return NSFileManager.defaultManager().createFileAtPath(fileDir.path!, contents:nil, attributes:nil)
		}
		return true
	}
	
	// Check if a string is whitespace only
	static func isWhitespace(message: String) -> Bool {
		if count(message.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) <= 0 {
			return true
		}
		return false
	}
}
