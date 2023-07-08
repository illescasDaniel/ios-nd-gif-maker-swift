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
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
