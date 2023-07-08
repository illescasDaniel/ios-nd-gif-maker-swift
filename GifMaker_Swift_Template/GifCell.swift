//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {

	@IBOutlet weak var gifImageView: UIImageView!

	func configureForGif(gif: Gif) {
		self.gifImageView.image = gif.gifImage
	}
}
