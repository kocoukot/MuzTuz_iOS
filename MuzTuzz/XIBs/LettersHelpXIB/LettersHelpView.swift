//
//  LettersHelpView.swift
//  MuzTuzz
//
//  Created by Anton on 14.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class LettersHelpView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    let frameWidth = UIScreen.main.bounds.width / 1.1
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        
        self.frame = CGRect(x: UIScreen.main.bounds.width / 2 - frameWidth/2  , y: UIScreen.main.bounds.height / 3, width: frameWidth , height: (UIScreen.main.bounds.width / 3.5) )
        self.layoutIfNeeded()
    }
    
    static func loadFromNIB() -> LettersHelpView{
        let nib = UINib(nibName: "LettersHelp", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! LettersHelpView
    }
    
}
