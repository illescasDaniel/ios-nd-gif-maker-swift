//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Daniel Illescas Romero on 8/7/23.
//  Copyright © 2023 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

	@IBOutlet weak var gifImageView: UIImageView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let proofOfConceptGif = UIImage.animatedImage(withAnimatedGIFName: "hotlineBling")
		gifImageView.image = proofOfConceptGif
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
