//
//  NSKeyedArchiver+securelyArchive.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation

extension NSKeyedArchiver {
	static func securelyArchive<T: NSSecureCoding>(rootObject: T, toFile fileURL: URL) throws {
		let data = try NSKeyedArchiver.archivedData(withRootObject: rootObject, requiringSecureCoding: true)
		try data.write(to: fileURL)
	}
}
