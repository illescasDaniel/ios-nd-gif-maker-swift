//
//  NSKeyedUnarchiver+securelyUnarchive.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

extension NSKeyedUnarchiver {

	enum SecureUnarchiveError: Error {
		case invalidContentsAtPath
	}
	static func securelyUnarchiveObject(ofClasses classes: [AnyClass], fileURL: URL) throws -> Any? {
		guard let data = FileManager.default.contents(atPath: fileURL.path()) else {
			throw SecureUnarchiveError.invalidContentsAtPath
		}
		let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
		unarchiver.requiresSecureCoding = true
		let value = try unarchiver.decodeTopLevelObject(of: classes, forKey: NSKeyedArchiveRootObjectKey)
		unarchiver.finishDecoding()
		return value
	}
}
