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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		showWelcome()

		do {
			let gifsNSArray: NSArray? = try NSKeyedUnarchiver.securelyUnarchiveObject(ofClasses: [NSArray.self, Gif.self], fileURL: gifsFileURL) as? NSArray
			let unarchivedGifs = gifsNSArray as? [Gif] ?? []
			self.gifs = unarchivedGifs
		} catch {
			print(error)
		}

		reload()

		let bottomBlur = CAGradientLayer()
		bottomBlur.frame = CGRect(x: 0, y: self.view.frame.size.height - 100, width: self.view.frame.size.width, height: 100)
		bottomBlur.colors = [
			UIColor(white: 1, alpha: 0).cgColor,
			UIColor.white.cgColor
		]
		self.view.layer.insertSublayer(bottomBlur, above: self.collectionView.layer)
	}

	private func showWelcome() {
		if !UserDefaults.standard.bool(forKey: "WelcomeViewSeen") {
			let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
			self.navigationController?.pushViewController(welcomeViewController, animated: true)
		}
	}

	private var gifsFileURL: URL {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appending(path: "savedGifs")
	}

	private func reload() {
		if gifs.isEmpty {
			emptyView.isHidden = false
			self.title = String()
		} else {
			emptyView.isHidden = true
			self.title = "My Collection"
		}
		collectionView.reloadData()
	}
}

extension SavedGifsViewController: UICollectionViewDelegate {}

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

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let gif = self.gifs[indexPath.item]
		let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
		detailVC.gif = gif

		detailVC.modalPresentationStyle = .overCurrentContext
		self.present(detailVC, animated: true)
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
