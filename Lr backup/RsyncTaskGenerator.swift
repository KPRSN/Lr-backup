//
//  RsyncTaskGenerator.swift
//  Lr backup
//
//  Created by Karl Persson on 2015-08-20.
//  Copyright (c) 2015 Karl Persson. All rights reserved.
//

import Cocoa

// Class for generating rsync tasks (nstask)
class RsyncTaskGenerator {
	// Generate the tasks needed to perform a backup, based on the user configuration
	class func generate() -> Array<NSTask> {
		var tasks: Array<NSTask> = [photos(), catalogs()]
		
		if Defaults.lrpreviews! {
			tasks.append(previews())
		}
		
		return tasks
	}
	
	class func photos() -> NSTask {
		let task = rsyncTask()
		
		// Exclude lightroom files
		task.arguments!.append("--exclude=*.lrcat")
		task.arguments!.append("--exclude=*.lrdata")
		
		return task
	}
	
	class func catalogs() -> NSTask {
		let task = rsyncTask()
		
		// Exclude everything but *.lrcat
		task.arguments!.append("--include=*.lrcat")
		task.arguments!.append("--include=*/")
		task.arguments!.append("--exclude=*")
		
		return task
	}
	
	class func previews() -> NSTask {
		let task = rsyncTask()
		
		// Exclude everything but *.lrdata
		task.arguments!.append("--include=*.lrdata")
		task.arguments!.append("--include=*/")
		task.arguments!.append("--exclude=*")
		
		return task
	}
	
	class func rsyncTask() -> NSTask {
		let task = NSTask()
		
		task.launchPath = "/usr/bin/rsync"
		task.arguments = ["-abvh"]
		
		if Defaults.compression! {
			task.arguments!.append("-z")
		}
		
		if Defaults.ssh! {
			task.arguments!.append("-e ssh")
			task.arguments!.append(Defaults.source!)
			task.arguments!.append(Defaults.user! + "@" + Defaults.host! + ":" + Defaults.destination!)
		}
		else {
			task.arguments!.append(Defaults.source!)
			task.arguments!.append(Defaults.destination!)
		}
		
		if !Defaults.hiddenFiles! {
			task.arguments!.append("--exclude=.*")
		}
		
		return task
	}
}
