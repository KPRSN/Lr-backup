//
//  PreferencesViewController.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-11.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
	var enableSSH: Int! {
		didSet {
			if enableSSH > 0 {
				host.enabled = true
				user.enabled = true
				password.enabled = true
				hostDesc.textColor = NSColor.blackColor()
				userDesc.textColor = NSColor.blackColor()
				passwordDesc.textColor = NSColor.blackColor()
			}
			else {
				host.enabled = false
				user.enabled = false
				password.enabled = false
				hostDesc.textColor = NSColor.grayColor()
				userDesc.textColor = NSColor.grayColor()
				passwordDesc.textColor = NSColor.grayColor()
			}
		}
	}

	@IBOutlet weak var source: NSTextField!
	@IBOutlet weak var destination: NSTextField!
	
	@IBOutlet weak var ssh: NSButton!
	@IBOutlet weak var host: NSTextField!
	@IBOutlet weak var user: NSTextField!
	@IBOutlet weak var password: NSSecureTextField!
	
	@IBOutlet weak var lrpreviews: NSButton!
	@IBOutlet weak var compression: NSButton!
	
	@IBOutlet weak var hostDesc: NSTextField!
	@IBOutlet weak var userDesc: NSTextField!
	@IBOutlet weak var passwordDesc: NSTextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		loadDefaults()
    }
	
	// Load default settings
	func loadDefaults() {
		source.stringValue = Defaults.source!
		destination.stringValue = Defaults.destination!
		ssh.state = Int(Defaults.ssh!)
		host.stringValue = Defaults.host!
		user.stringValue = Defaults.user!
		lrpreviews.state = Int(Defaults.lrpreviews!)
		compression.state = Int(Defaults.compression!)
		
		enableSSH = ssh.state
	}
	
	// Save default settings
	func saveDefaults() {
		Defaults.source = source.stringValue
		Defaults.destination = destination.stringValue
		Defaults.ssh = Bool(ssh.state)
		Defaults.host = host.stringValue
		Defaults.user = user.stringValue
		Defaults.lrpreviews = Bool(lrpreviews.state)
		Defaults.compression = Bool(compression.state)
	}
	
	@IBAction func sshClicked(sender: NSButton?) {
		enableSSH = ssh.state
	}
}
