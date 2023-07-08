//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController {

	@IBOutlet weak var gifImageView: UIImageView!
	@IBOutlet weak var captionTextField: UITextField!
	var gif: Gif?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		gifImageView.image = gif?.gifImage
		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		unsubscribeToKeyboardNotifications()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let captionTextFieldAttributes: [NSAttributedString.Key : Any] = [
			.strokeColor: UIColor.black,
			.strokeWidth: -4,
			.foregroundColor: UIColor.white,
			.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? UIFont.systemFont(ofSize: 30)
		]
		self.captionTextField.defaultTextAttributes = captionTextFieldAttributes
		self.captionTextField.textAlignment = .center
		self.captionTextField.attributedPlaceholder = NSAttributedString(string: "Add Caption", attributes: captionTextFieldAttributes)
	}

	@IBAction func presentPreview(_ sender: Any) {
		let previewVC = self.storyboard?.instantiateViewController(identifier: "GifPreviewViewController") as! GifPreviewViewController
		previewVC.savedGifsVCDelegate = self.navigationController?.viewControllers.first as? GifPreviewViewControllerDelegate
		self.gif?.caption = self.captionTextField.text
		guard let sourceFileURL = self.gif?.videoURL else { return }
		let regift = Regift(sourceFileURL: sourceFileURL, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
		let captionFont = self.captionTextField.font
		guard let gifURL = regift.createGif(self.captionTextField.text, font: captionFont) else { return }
		let newGif = Gif(url: gifURL, videoURL: sourceFileURL, caption: self.captionTextField.text)
		previewVC.gif = newGif
		self.navigationController?.pushViewController(previewVC, animated: true)
	}
}

// MARK: UITextFieldDelegate
extension GifEditorViewController: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.placeholder = ""
	}
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

// MARK: Observe and respond to keyboard notifications
extension GifEditorViewController {

	private func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func unsubscribeToKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc private func keyboardWillShow(notification: Notification) {
		if self.view.frame.origin.y >= 0 {
			self.view.frame.origin.y -= self.keyboardHeight(notification: notification)
		}
	}

	@objc private func keyboardWillHide(notification: Notification) {
		if self.view.frame.origin.y < 0 {
			self.view.frame.origin.y += self.keyboardHeight(notification: notification)
		}
	}

	private func keyboardHeight(notification: Notification) -> CGFloat {
		guard let userInfo = notification.userInfo else { return 0 }
		guard let keyboardFrameEnd = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return 0 }
		let height = keyboardFrameEnd.cgRectValue.height
		return height
	}
}
