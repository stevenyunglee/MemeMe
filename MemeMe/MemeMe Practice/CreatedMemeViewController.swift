//
//  CreatedMemeViewController.swift
//  MemeMe Practice
//
//  Created by Lee, Steve on 4/9/18.
//  Copyright © 2018 Steve Lee. All rights reserved.
//

import Foundation
import UIKit

class CreatedMemeViewController: UIViewController {
  
    
    var memedImage: UIImage?

    @IBOutlet var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = memedImage
    }

}
