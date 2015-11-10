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
				
				hostDesc.textColor = NSColor.blackColor()
				userDesc.textColor = NSColor.blackColor()
			}
			else {
				host.enabled = false
				user.enabled = false
				hostDesc.textColor = NSColor.grayColor()
				userDesc.textColor = NSColor.grayColor()
			}
		}
	}

	@IBOutlet weak var source: NSTextField!
	@IBOutlet weak var destination: NSTextField!
	
	@IBOutlet weak var ssh: NSButton!
	@IBOutlet weak var host: NSTextField!
	@IBOutlet weak var user: NSTextField!
	
	@IBOutlet weak var lrpreviews: NSButton!
	@IBOutlet weak var compression: NSButton!
	
	@IBOutlet weak var hostDesc: NSTextField!
	@IBOutlet weak var userDesc: NSTextField!
	
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
		// Reset last backup date if source, destination or host have been changed
		if (Defaults.source != source.stringValue ||
			Defaults.destination != destination.stringValue ||
			Defaults.ssh != Bool(ssh.state) ||
			Defaults.host != host.stringValue ||
			Defaults.user != user.stringValue) {
				Defaults.lastBackup = nil
		}
		
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
	
	@IBAction func sshHelp(sender: NSButton?) {
		// Open up a help website for setting up SSH authentication
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys")!)
	}
}
