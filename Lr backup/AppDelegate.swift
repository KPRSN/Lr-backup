//
//  AppDelegate.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-08.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
	@IBOutlet weak var window: NSWindow!
	
	let preferences = Preferences(windowNibName: "Preferences")
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
	let statusMenu = NSMenuItem(title: "Lr backup", action: nil, keyEquivalent: "")
	let backupMenu = NSMenuItem(title: "", action: Selector("runBackup:"), keyEquivalent: "")
	let backup = Backup()
	var statusIcon: StatusIcon!
	
	// Show animation, error message and cancel option while running
	var running: Bool = false {
		didSet {
			if !running {
				self.backupMenu.title = "Backup"
			}
			else {
				self.backupMenu.title = "Cancel"
				statusIcon.running()
				status = backup.status
			}
		}
	}
	
	// Show the correct animation and error message after an error
	var error: Bool = false {
		didSet {
			if error {
				statusIcon.error()
				status = backup.status
			}
			else {
				statusIcon.idle()
			}
		}
	}
	
	var status: String {
		get {
			return self.statusMenu.title
		}
		set {
			// Print last line only
			self.statusMenu.title = newValue
		}
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Assign icon
		if let button = statusItem.button {
			statusIcon = StatusIcon(button: button)
		}

		// First run setup
		if (Defaults.firstRun == nil || Defaults.firstRun == true) {
			Defaults.standardUserDefaults()
		}
		
		// Observe backup actions
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("backupRunningNotification:"), name: "BackupRunningNotification", object: nil)
		
		// Initialize menu
		let menu = NSMenu()
		menu.addItem(statusMenu)
		menu.addItem(NSMenuItem.separatorItem())
		menu.addItem(backupMenu)
		menu.addItem(NSMenuItem.separatorItem())
		menu.addItem(NSMenuItem(title: "Log", action: Selector("openLog:"), keyEquivalent: ""))
		menu.addItem(NSMenuItem(title: "Preferences...", action: Selector("openPreferences:"), keyEquivalent: ""))
		menu.addItem(NSMenuItem.separatorItem())
		menu.addItem(NSMenuItem(title: "Quit", action: Selector("quit:"), keyEquivalent: ""))
		
		running = false
		statusItem.menu = menu
		updateStatus()
		menu.delegate = self
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func backupRunningNotification(notification: NSNotification) {
		error = backup.error
		running = backup.running
	}
	
	// Run backup
	func runBackup(sender: AnyObject?) {
		if running {
			backup.cancel()
		}
		else {
			backup.run()
		}
	}
	
	// Open application log
	func openLog(sender: AnyObject?) {
		openPreferences(self)
		preferences.toolbar.selectedItemIdentifier = "log"
		preferences.showLog(self)
	}
	
	// Open preferences pane
	func openPreferences(sender: AnyObject?) {
		preferences.showWindow(self)
		preferences.toolbar.selectedItemIdentifier = "preferences"
		preferences.showPreferences(self)
		NSApp.activateIgnoringOtherApps(true)
	}
	
	// Quit the application
	func quit(sender: AnyObject?) {
		backup.cancel()
		NSApplication.sharedApplication().terminate(self)
	}
	
	// Update status if needed
	func menuWillOpen(menu: NSMenu) {
		if !(running || error) {
			updateStatus()
		}
	}
	
	// Clear errors when the menu closes
	func menuDidClose(menu: NSMenu) {
		if !running {
			// Show normal status (last backup)
			error = false
		}
	}
	
	// Update last backup status
	func updateStatus() {
		var dateString = "Never"
		
		if (Defaults.lastBackup != nil) {
			let formatter = NSDateFormatter()
			formatter.timeStyle = NSDateFormatterStyle.ShortStyle
			formatter.dateStyle = NSDateFormatterStyle.FullStyle
			dateString = formatter.stringFromDate(Defaults.lastBackup!)
		}
		
		status = "Last backup: " + dateString
	}
}

