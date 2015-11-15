//
//  LogViewController.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-11.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

class LogViewController: NSViewController {
	@IBOutlet weak var logScrollView: NSScrollView!
	var logTextView: NSTextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		logTextView = NSTextView(frame: NSMakeRect(0, 0, logScrollView.contentSize.width, logScrollView.contentSize.height))
		logTextView.editable = false
		logScrollView.documentView = logTextView
		logScrollView.hasHorizontalScroller = false
		logScrollView.hasVerticalScroller = true
		logScrollView.horizontalScroller?.hidden = true
		logScrollView.verticalScroller?.hidden = true
    }
	
	// Full log update from file
	func updateLog() {
		let logstring = try? String(contentsOfFile: Logger.fileDir.path!, encoding: NSUTF8StringEncoding)
		if logstring != nil {
			logTextView.string = logstring
			logTextView.scrollToEndOfDocument(self)
		}
		else {
			logTextView.string = ""
		}
	}

	// Update log window continously
	func logUpdatedNotification(notification: NSNotification) {
		// Synchronize with main queue
		dispatch_async(dispatch_get_main_queue(), {
			self.logTextView.textStorage?.beginEditing()
			self.logTextView.textStorage?.appendAttributedString(NSAttributedString(string: notification.object as! String))
			self.logTextView.textStorage?.endEditing()
		})
	}
	
	// Clear log file
    @IBAction func clear(sender: NSButton) {
		do {
			// Delete file
			try NSFileManager.defaultManager().removeItemAtURL(Logger.fileDir)
		} catch _ {
		}
		updateLog()
	}
	
	// Open log file in other application
	@IBAction func openIn(sender: NSButton) {
		// Open log in default text editor
		NSWorkspace.sharedWorkspace().openURL(Logger.fileDir)
	}
	
	override func viewWillAppear() {
		updateLog()
		
		// Observe further log updates
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("logUpdatedNotification:"), name: "LogUpdatedNotification", object: nil)
	}
	
	override func viewDidDisappear() {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}

}
