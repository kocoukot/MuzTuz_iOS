//
//  FinishLvlView.swift
//  MuzTuzz
//
//  Created by Anton on 14.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

protocol FinishLvlViewDelegate: NSObjectProtocol{
    func okCkicked()
}

class FinishLvlView: UIView {
    weak var delegate: FinishLvlViewDelegate?
    
    @IBOutlet weak var firstStarImage: UIImageView!
    @IBOutlet weak var secondStarImage: UIImageView!
    @IBOutlet weak var thirdStarImage: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var coinsLabel: UILabel!
    var shown = true
    
    var imageList: [UIImageView?] = []
    
    @IBOutlet weak var coinsFlyImage: UIImageView!
    @IBOutlet weak var starFlyImage: UIImageView!
    
    let frameWidth = UIScreen.main.bounds.width / 1.15
    let frameHeight = (UIScreen.main.bounds.width / 1.1) / 1.5
    let starsImageList = ["zvezda1_prizovogo_okna", "zvezda2_prizovogo_okna", "zvezda2_prizovogo_okna"]
    let prisesAmount = [5,10,20,30]
    let smallStarsAmountWon = [0,1,2,3]
    
    
    override func layoutSubviews() {
        imageList = [firstStarImage,secondStarImage,thirdStarImage]
        
        super.layoutSubviews()
        self.layer.cornerRadius = 10
        CommonFuncs().shadowSet(okButton)
        let animDuration = 0.25
        self.frame = CGRect(x: UIScreen.main.bounds.width / 2 - frameWidth/2  , y: UIScreen.main.bounds.height / 2 - frameHeight / 2, width: frameWidth , height: frameHeight )
        self.layoutIfNeeded()
        if shown {
            for i in 0..<imageList.count{
                UIView.animate(withDuration: animDuration,delay: (animDuration*Double(i)),usingSpringWithDamping: 0.5, initialSpringVelocity: 30,options: .curveEaseInOut, animations: {
                    self.imageList[i]!.frame = CGRect(x: (self.imageList[i]!.frame.origin.x) - ((self.imageList[i]!.frame.width))/2 ,
                                                      y: (self.imageList[i]!.frame.origin.y) - ((self.imageList[i]!.frame.height))/2,
                                                      width: self.imageList[i]!.frame.width*2,
                                                      height: self.imageList[i]!.frame.height*2)
                }, completion: { (isCompleted) in
                    self.firstStarImage.frame = CGRect(x: (self.imageList[i]!.frame.origin.x),
                                                       y: (self.imageList[i]!.frame.origin.y),
                                                       width: self.imageList[i]!.frame.width*2,
                                                       height: self.imageList[i]!.frame.height*2)
                })
            }
            
            UIView.animate(withDuration: 0.6, delay: 0.3,options: .curveEaseInOut, animations: {
                self.coinsFlyImage.frame = CGRect(x:  UIScreen.main.bounds.width-self.coinsFlyImage.frame.width*1.3,
                                                  y: -self.coinsFlyImage.bounds.origin.y - (UIScreen.main.bounds.height / 2 - self.frameHeight / 2) + 20,
                                                  width: self.coinsFlyImage.frame.width*0.5,
                                                  height: self.coinsFlyImage.frame.height*0.5)
                self.coinsFlyImage.alpha = 0.25
                self.starFlyImage.frame = CGRect(x:  UIScreen.main.bounds.width-170,
                                                 y: -self.starFlyImage.bounds.origin.y - (UIScreen.main.bounds.height / 2 - self.frameHeight / 2) + 20,
                                                 width: self.starFlyImage.frame.width*0.5,
                                                 height: self.starFlyImage.frame.height*0.5)
                self.starFlyImage.alpha = 0.25
            },completion: {isComplition in
                self.coinsFlyImage.alpha = 0
                self.starFlyImage.alpha = 0
            })
            shown = false
        }
    }
    
    
    func starsSet(_ starsAmount: Int,_ imageList: [UIImageView],_ doublePrize: Int){
        coinsLabel.text = String(prisesAmount[starsAmount])
        starsLabel.text = String(smallStarsAmountWon[starsAmount])
        if doublePrize == 2 {
            coinsLabel.text! += " x2"
        }
        if starsAmount > 0{
            for i in 0..<starsAmount{
                imageList[i].image = UIImage(named: starsImageList[i])
            }
        }
    }
    
    
    @IBAction func okButtonAction(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        
        delegate?.okCkicked()
    }
    
    
    
    @IBAction func removeShadow(_ sender: Any) {
        (sender as AnyObject).layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    @IBAction func returnShadow(_ sender: Any) {
        (sender as AnyObject).layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
    
    static func loadFromNIB() -> FinishLvlView{
        let nib = UINib(nibName: "FinishLvl", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! FinishLvlView
    }
}
