//
//  AuthorsViewController.swift
//  MuzTuzz
//
//  Created by Anton on 25.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class AuthorsViewController: UIViewController {

    @IBOutlet weak var versionGameLabel: UILabel!
    @IBOutlet weak var ccRights: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonFuncs().cornersSet(ccRights)
        CommonFuncs().shadowSet(ccRights)
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        versionGameLabel.text! += " \(version)"
        
        
    }
    
        //https://yadi.sk/i/Gd7vNnOuFIgfQw
    @IBAction func ccRightsButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        CommonFuncs().openURL("https://yadi.sk/i/Gd7vNnOuFIgfQw")
    }

}
