//
//  Defaults.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-12.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

 class Defaults {
	#if DEBUG
		static var defaults = NSUserDefaults(suiteName: "LrBackup-test")!
	#else
		static var defaults = NSUserDefaults.standardUserDefaults()
	#endif
	
	
	static var source: String? {
		get {
			return defaults.objectForKey("source") as? String
		}
		set {
			defaults.setObject(newValue, forKey: "source")
		}
	}
	
	static var destination: String? {
		get {
			return defaults.objectForKey("destination") as? String
		}
		set {
			defaults.setObject(newValue, forKey: "destination")
		}
	}
	
	static var ssh: Bool? {
		get {
			return defaults.objectForKey("ssh") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "ssh")
		}
	}
	
	static var host: String? {
		get {
			return defaults.objectForKey("host") as? String
		}
		set {
			defaults.setObject(newValue, forKey: "host")
		}
	}
	
	static var user: String? {
		get {
			return defaults.objectForKey("user") as? String
		}
		set {
			defaults.setObject(newValue, forKey: "user")
		}
	}
	
	static var lrpreviews: Bool? {
		get {
			return defaults.objectForKey("lrpreviews") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "lrpreviews")
		}
	}
	
	static var hiddenFiles: Bool? {
		get {
			return defaults.objectForKey("hiddenFiles") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "hiddenFiles")
		}
	}
	
	static var compression: Bool? {
		get {
			return defaults.objectForKey("compression") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "compression")
		}
	}
	
	static var lastBackup: NSDate? {
		get {
			return defaults.objectForKey("lastBackup") as? NSDate
		}
		set {
			defaults.setObject(newValue, forKey: "lastBackup")
		}
	}
	
	static var firstRun: Bool? {
		get {
			return defaults.objectForKey("firstRun") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "firstRun")
		}
	}
	
	static func standardUserDefaults() {
		Defaults.source = ""
		Defaults.destination = ""
		Defaults.ssh = false
		Defaults.host = ""
		Defaults.user = ""
		Defaults.lrpreviews = true
		Defaults.hiddenFiles = false
		Defaults.compression = false
		Defaults.lastBackup = nil
		Defaults.firstRun = false
	}
	
	// Hard reset of the system defaults for this application
	static func defaultsReset() {
		NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
	}
}
