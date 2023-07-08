//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var gifImageView: UIImageView!
	var gif: Gif!

	override func viewDidLoad() {
		super.viewDidLoad()
		gifImageView.image = gif.gifImage
	}

	@IBAction func shareAction() {
		guard let gifData: Data = self.gif?.gifData else { return }
		let activityVC = UIActivityViewController(activityItems: [gifData], applicationActivities: nil)
		activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
			if completed {
				self.dismiss(animated: true)
			}
		}
		self.present(activityVC, animated: true)
	}

	@IBAction func closeButtonAction() {
		dismiss(animated: true)
	}
}
