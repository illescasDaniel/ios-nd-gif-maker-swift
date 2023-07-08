//
//  GifPreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifPreviewViewController: UIViewController {

	@IBOutlet weak var previewGif: UIImageView!
	var gif: Gif?

    override func viewDidLoad() {
        super.viewDidLoad()
		previewGif.image = gif?.gifImage
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
