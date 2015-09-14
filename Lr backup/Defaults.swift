//
//  Defaults.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-12.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

 class Defaults {
	static var defaults = NSUserDefaults.standardUserDefaults()
	
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
	
	static var compression: Bool? {
		get {
			return defaults.objectForKey("compression") as? Bool
		}
		set {
			defaults.setObject(newValue, forKey: "compression")
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
		Defaults.compression = false
		Defaults.firstRun = false
	}
	
	// Hard reset of the system defaults for this application
	static func defaultsReset() {
		NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
	}
}
