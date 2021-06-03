//
//  File.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func shadowSet(){
        let button = self
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
    func shadowRemove(){
        let button = self
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 4.0
    }
    
    func cornersSet(){
        let button = self
        button.layer.cornerRadius = 5
    }
}

extension Int{
    func secondsToHoursMinutesSeconds () -> String {
        let seconds = self
        return " \((seconds % 3600) / 60) мин. \((seconds % 3600) % 60) сек."
    }
    
}


func openURL(_ url: String){
    if let url = NSURL(string: url){
        UIApplication.shared.open(url as URL, options:  [.universalLinksOnly: (Any).self])
    }
}
