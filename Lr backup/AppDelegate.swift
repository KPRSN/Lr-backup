//
//  AppDelegate.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-08.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!
	
	let preferences = Preferences(windowNibName: "Preferences")
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
	let statusMenu = NSMenuItem(title: "Lr backup", action: nil, keyEquivalent: "")
	let backupMenu = NSMenuItem(title: "", action: Selector("runBackup:"), keyEquivalent: "")
	let backup = Backup()
	
	var running: Bool = false {
		didSet {
			if !running {
				self.backupMenu.title = "Backup"
			}
			else {
				self.backupMenu.title = "Cancel"
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
	
	override init () {
		super.init()
	}

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		if let button = statusItem.button {
			button.image = NSImage(named: "StatusBarButtonImage")
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
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func backupRunningNotification(notification: NSNotification) {
		running = backup.running
		status = backup.status
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
		preferences.window?.makeKeyAndOrderFront(self)
	}
	
	// Quit the application
	func quit(sender: AnyObject?) {
		backup.cancel()
		NSApplication.sharedApplication().terminate(self)
	}
}

