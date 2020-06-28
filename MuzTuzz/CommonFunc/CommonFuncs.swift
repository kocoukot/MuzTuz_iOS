//
//  File.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation
import UIKit

class CommonFuncs{
        
    func shadowSet(_ button: UIButton){
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
    func shadowRemove(_ button: UIButton){
    button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
    button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0.0
    button.layer.masksToBounds = false
    button.layer.cornerRadius = 4.0
    }
    
    func cornersSet(_ button: UIButton){
        button.layer.cornerRadius = 5
    }
    
    func openURL(_ url: String){
        if let url = NSURL(string: url){
         UIApplication.shared.open(url as URL, options:  [.universalLinksOnly: (Any).self])
        }
    }
}

class Level{
    var levelImage: String
    var correctAnswers: [String]
    var albom: String
    var lvlID: Int
    var premiaID: Int
    
    init?(levelImage: String,correctAnswers: [String], albom: String, lvlID: Int, premiaID: Int){
        self.levelImage = levelImage
        self.correctAnswers = correctAnswers
        self.albom = albom
        self.lvlID = lvlID
        self.premiaID = premiaID
    }
    

}
