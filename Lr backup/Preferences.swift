//
//  Preferences.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-11.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

class Preferences: NSWindowController, NSToolbarDelegate, NSWindowDelegate {
	@IBOutlet weak var toolbar: NSToolbar!
	
	let preferencesViewController = PreferencesViewController(nibName: "PreferencesViewController", bundle: nil)!
	let logViewController = LogViewController(nibName: "LogViewController", bundle: nil)!
	
    override func windowDidLoad() {
        super.windowDidLoad()
		
		toolbar.delegate = self
		
		// Set default menu
		toolbar.selectedItemIdentifier = "preferences"
		showPreferences(toolbar.selectedItemIdentifier!)
    }
	
	func windowWillClose(notification: NSNotification) {
		preferencesViewController.saveDefaults()
	}
    
	@IBAction func showPreferences(sender: AnyObject) {
		window?.contentView = preferencesViewController.view
	}
	
	@IBAction func showLog(sender: AnyObject) {
		window?.contentView = logViewController.view
	}
}
