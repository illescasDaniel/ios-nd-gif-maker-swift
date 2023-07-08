//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class SavedGifsViewController: UIViewController {

	var gifs: [Gif] = []
	private let cellMargin: CGFloat = 12

	@IBOutlet
	private weak var collectionView: UICollectionView!

	@IBOutlet
	private weak var emptyView: UIStackView!

	override func viewDidLoad() {
		super.viewDidLoad()

		do {
			let gifsNSArray: NSArray? = try NSKeyedUnarchiver.securelyUnarchiveObject(ofClasses: [NSArray.self, Gif.self], fileURL: gifsFileURL) as? NSArray
			let unarchivedGifs = gifsNSArray as? [Gif] ?? []
			self.gifs = unarchivedGifs
		} catch {
			print(error)
		}

		emptyView.isHidden = !gifs.isEmpty
		collectionView.reloadData()
	}

	var gifsFileURL: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "savedGifs")
	}

	func reload() {
		emptyView.isHidden = !gifs.isEmpty
		collectionView.reloadData()
	}
}

extension SavedGifsViewController: UICollectionViewDelegate {

}

extension SavedGifsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.gifs.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
		let gif = self.gifs[indexPath.item]
		cell.configureForGif(gif: gif)
		return cell
	}


}

extension SavedGifsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (collectionView.frame.width - (cellMargin * 2)) / 2
		let size = CGSize(width: width, height: width)
		return size
	}
}

extension SavedGifsViewController: GifPreviewViewControllerDelegate {
	func previewVC(preview: GifPreviewViewController, didSaveGif gif: Gif?) {
		if let gif {
			gif.gifData = gif.url.flatMap { try? Data(contentsOf: $0) }
			self.gifs.append(gif)
			reload()
			do {
				try NSKeyedArchiver.securelyArchive(rootObject: NSArray(array: self.gifs), toFile: gifsFileURL)
			} catch {
				print(error)
			}
		}
	}
}
