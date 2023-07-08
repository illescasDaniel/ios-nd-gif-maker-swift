//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

// this will be used on all our View controllers
// this is probably not recommended to do on a real app

// Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever

extension UIViewController: UINavigationControllerDelegate {}

extension UIViewController: UIImagePickerControllerDelegate {

	@IBAction func launchVideoCamera(sender: AnyObject) {
		let recordVideoController = UIImagePickerController()
		recordVideoController.sourceType = .camera
		recordVideoController.mediaTypes = [UTType.movie.identifier]
		recordVideoController.allowsEditing = false
		recordVideoController.delegate = self
		self.present(recordVideoController, animated: true)
	}

	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let mediaType = (info[.mediaType] as? String).map({ UTType($0) }),
			  mediaType == .movie,
			  let videoURL = info[.mediaURL] as? URL
		else {
			picker.dismiss(animated: true)
			return
		}
		picker.dismiss(animated: true)
		convertVideoToGIF(videoURL: videoURL)
	}

	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}

	// GIF conversion methods
	func convertVideoToGIF(videoURL: URL) {
		let regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
		let gifURL = regift.createGif()
		let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
		displayGIF(gif)
	}

	func displayGIF(_ gif: Gif) {
		let gifEditorVC = storyboard?.instantiateViewController(identifier: "GifEditorViewController") as! GifEditorViewController
		gifEditorVC.gif = gif
		navigationController?.pushViewController(gifEditorVC, animated: true)
	}
}
