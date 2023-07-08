//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class Gif: NSObject, NSSecureCoding {

	let url: URL?
	let videoURL: URL?
	var caption: String?
	let gifImage: UIImage?
	var gifData: Data?

	init(url: URL, videoURL: URL, caption: String?) {
		self.url = url
		self.videoURL = videoURL
		self.caption = caption
		self.gifImage = UIImage.animatedImage(withAnimatedGIFURL: url)
		self.gifData = nil
	}

	init(name: String) {
		self.url = nil
		self.caption = nil
		self.gifImage = UIImage.animatedImage(withAnimatedGIFName: name)
		self.videoURL = nil
		self.gifData = nil
	}

	required init?(coder: NSCoder) {
		self.url = coder.decodeObject(of: NSURL.self, forKey: "gifURL") as? URL
		self.caption = coder.decodeObject(of: NSString.self, forKey: "caption") as? String
		self.videoURL = coder.decodeObject(of: NSURL.self, forKey: "videoURL") as? URL
		self.gifImage = coder.decodeObject(of: UIImage.self, forKey: "gifImage")
		self.gifData = coder.decodeObject(of: NSData.self, forKey: "gifData") as? Data
		super.init()
	}

	static var supportsSecureCoding: Bool {
		return true
	}

	func encode(with coder: NSCoder) {
		coder.encode(self.url, forKey: "gifURL")
		coder.encode(self.caption, forKey: "caption")
		coder.encode(self.videoURL, forKey: "videoURL")
		coder.encode(self.gifImage, forKey: "gifImage")
		coder.encode(self.gifData, forKey: "gifData")
	}
}
