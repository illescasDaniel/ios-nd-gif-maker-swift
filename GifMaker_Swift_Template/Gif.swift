//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class Gif {
	let url: URL?
	let videoURL: URL?
	var caption: String?
	let gifImage: UIImage?
	let gifData: Data?

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
}
