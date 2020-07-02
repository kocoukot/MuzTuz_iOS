//
//  PremiaCollectionViewCell.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

protocol LevelChooseDelegate: NSObjectProtocol {
    func levelNumber(_ number: PremiaCollectionViewCell)
}


class PremiaCollectionViewCell: UICollectionViewCell {
    weak var delegate: LevelChooseDelegate?
    
    @IBOutlet weak var solvedImage: UIImageView!
    @IBOutlet weak var levelButton: UIButton!

    override func awakeFromNib() {
          super.awakeFromNib()
        levelButton.contentMode = .scaleAspectFit
        levelButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
      }

    @IBAction func LevelChoose(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        delegate?.levelNumber(self)
    }
    
    deinit {
        self.removeFromSuperview()
    }
}
