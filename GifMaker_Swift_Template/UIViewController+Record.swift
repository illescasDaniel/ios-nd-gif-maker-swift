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
import AVFoundation

// this will be used on all our View controllers
// this is probably not recommended to do on a real app

// Regift constants
let frameCount = 16
let delayTime: Float = 0.2
let loopCount = 0 // 0 means loop forever
let frameRate = 15

extension UIViewController: UINavigationControllerDelegate {}

extension UIViewController: UIImagePickerControllerDelegate {

	@IBAction func presentVideoOptions(sender: AnyObject) {
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: .actionSheet)
			let recordVideo = UIAlertAction(title: "Record a video", style: .default, handler: { action in
				self.launchVideoCamera()
			})
			let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: .default, handler: { action in
				self.launchPhotoLibrary()
			})
			let cancel = UIAlertAction(title: "Cancel", style: .cancel)
			newGifActionSheet.addAction(recordVideo)
			newGifActionSheet.addAction(chooseFromExisting)
			newGifActionSheet.addAction(cancel)

			self.present(newGifActionSheet, animated: true)
			newGifActionSheet.view.tintColor = .systemPink
		} else {
			self.launchPhotoLibrary()
		}
	}

	private func launchVideoCamera() {
		launchPickerController(sourceType: .camera)
	}

	private func launchPhotoLibrary() {
		launchPickerController(sourceType: .photoLibrary)
	}

	private func launchPickerController(sourceType: UIImagePickerController.SourceType) {
		let recordVideoController = UIImagePickerController()
		recordVideoController.sourceType = sourceType
		recordVideoController.mediaTypes = [UTType.movie.identifier]
		recordVideoController.allowsEditing = true
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

		let start = (info[.init(rawValue: "_UIImagePickerControllerVideoEditingStart")] as? NSNumber)?.floatValue
		let end = (info[.init(rawValue: "_UIImagePickerControllerVideoEditingEnd")] as? NSNumber)?.floatValue
		let duration: Float?
		if let start, let end {
			duration = end - start
		} else {
			duration = nil
		}
		Task {
			do {
				try await cropVideoToSquare(videoURL: videoURL, start: start, duration: duration)
			} catch {
				print(error)
			}
		}
	}

	public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true)
	}

	// GIF conversion methods
	private func convertVideoToGIF(videoURL: URL, start: Float?, duration: Float?) {
		let regift: Regift
		if let start { // trimmed
			regift = Regift(sourceFileURL: videoURL, startTime: start, duration: duration ?? 0, frameRate: frameRate)
		} else { // untrimmed
			regift = Regift(sourceFileURL: videoURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
		}
		let gifURL = regift.createGif()
		let gif = Gif(url: gifURL!, videoURL: videoURL, caption: nil)
		displayGIF(gif)
	}

	private func displayGIF(_ gif: Gif) {
		let gifEditorVC = storyboard?.instantiateViewController(identifier: "GifEditorViewController") as! GifEditorViewController
		gifEditorVC.gif = gif
		navigationController?.pushViewController(gifEditorVC, animated: true)
	}

	enum CropVideoToSquareError: Error {
		case avAssetExportSessionError
		case failedOrCancelled
	}
	private func cropVideoToSquare(videoURL: URL, start: Float?, duration: Float?) async throws {
		//Create the AVAsset and AVAssetTrack
		let videoAsset = AVAsset(url: videoURL)
		let videoTrack = try await videoAsset.loadTracks(withMediaType: .video)[0]

		let videoNaturalSize = try await videoTrack.load(.naturalSize)

		// Crop to square
		let videoComposition = AVMutableVideoComposition()
		let renderSize = CGSize(width: videoNaturalSize.height, height: videoNaturalSize.height)
		videoComposition.renderSize = renderSize
		videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)

		//rotate to portrait
		let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
		let t1 = CGAffineTransform(translationX: videoNaturalSize.height, y: -(videoNaturalSize.width - videoNaturalSize.height) / 2)
		let t2 = t1.rotated(by: .pi / 2)
		transformer.setTransform(t2, at: .zero)

		let instruction = AVMutableVideoCompositionInstruction()
		instruction.timeRange = CMTimeRange(start: .zero, duration: CMTimeMake(value: .max, timescale: 30))
		instruction.layerInstructions = [transformer]
		videoComposition.instructions = [instruction]

		//export
		guard let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality) else {
			throw CropVideoToSquareError.avAssetExportSessionError
		}
		let outputFileURL = try createPath()
		exporter.outputFileType = .mov
		exporter.outputURL = outputFileURL
		exporter.videoComposition = videoComposition

		await exporter.export()
		switch exporter.status {
		case .completed:
			print("Export complete")
		case .failed, .cancelled:
			throw CropVideoToSquareError.failedOrCancelled
		default:
			break
		}
		self.convertVideoToGIF(videoURL: outputFileURL, start: start, duration: duration)
	}

	private func createPath() throws -> URL {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let outputFolder = documentsURL.appending(path: "output")
		try FileManager.default.createDirectory(at: outputFolder, withIntermediateDirectories: true)
		let outputFileURL = outputFolder.appending(path: "output.mov")
		try? FileManager.default.removeItem(at: outputFileURL)
		return outputFileURL
	}
}
