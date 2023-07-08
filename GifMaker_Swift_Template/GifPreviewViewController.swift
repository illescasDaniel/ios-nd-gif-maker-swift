//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

protocol GifPreviewViewControllerDelegate: AnyObject {
	func previewVC(preview: GifPreviewViewController, didSaveGif gif: Gif?)
}

class GifPreviewViewController: UIViewController {

	@IBOutlet
	private weak var previewGif: UIImageView!

	var gif: Gif?
	weak var savedGifsVCDelegate: GifPreviewViewControllerDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		previewGif.image = gif?.gifImage
	}

	@IBAction func shareGif(_ sender: Any) {
		guard let gifURL = self.gif?.url else { return }
		guard let animatedGif = try? Data(contentsOf: gifURL) else { return }
		let activityController = UIActivityViewController(activityItems: [animatedGif], applicationActivities: nil)
		activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
			if completed {
				self.navigationController?.popToRootViewController(animated: true)
			}
		}
		self.present(activityController, animated: true)
	}

	@IBAction func createAndSave(_ sender: Any) {
		self.savedGifsVCDelegate?.previewVC(preview: self, didSaveGif: self.gif)
		self.navigationController?.popToRootViewController(animated: true)
	}
}
