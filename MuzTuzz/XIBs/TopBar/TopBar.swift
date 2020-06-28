//
//  TopBar.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit
import AVFoundation
protocol TopBarDelegate: NSObjectProtocol{
    func closeVC()
}


class TopBar: UIView {
    weak var delegate:TopBarDelegate?
    
    @IBOutlet weak var melodyButtonOutlet: UIButton!
    @IBOutlet weak var zvukButtonOutlet: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var coinsAmountLabel: UILabel!
    @IBOutlet weak var starsAmountLabel: UILabel!
    
    var melodyON = true
    var zvukON = true
    var backGroundMusic = AVAudioPlayer()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconsUpdate()
        
        CommonFuncs().shadowSet(melodyButtonOutlet)
        CommonFuncs().shadowSet(zvukButtonOutlet)
        CommonFuncs().shadowSet(backButtonOutlet)
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
    }
    
    
    @IBAction func topBarBackButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        delegate?.closeVC()
    }
    

    
    @IBAction func melodySelected(_ sender: Any) {
        if Persistence.shared.music
        {
            SoundsPlay.shared.playSound("OffMusic", "wav")
            SoundsPlay.shared.pauseBackgroundMusic()
            melodyButtonOutlet.setImage(UIImage(named: "melodiy_otklyuchen"), for: .normal)
            Persistence.shared.music = false
        } else{
            SoundsPlay.shared.playSound("OnMusic", "wav")
            SoundsPlay.shared.resumeBackgroundMusic()
            melodyButtonOutlet.setImage(UIImage(named: "melodiy"), for: .normal)
            Persistence.shared.music = true
        }
    }
    
    @IBAction func addCoinsButton(_ sender: Any) {
    }
    
    @IBAction func removeCoins(_ sender: Any) {
    }
    
    @IBAction func zvukButton(_ sender: Any) {
        if Persistence.shared.zvuki
        {
            SoundsPlay.shared.playSound("OffMusic", "wav")
            zvukButtonOutlet.setImage(UIImage(named: "zvuk_otklyuchen"), for: .normal)
            Persistence.shared.zvuki = false
        } else{
            SoundsPlay.shared.playSound("OnMusic", "wav")

            zvukButtonOutlet.setImage(UIImage(named: "zvuk"), for: .normal)
            Persistence.shared.zvuki = true
        }
    }
    
    func iconsUpdate(){
        if Persistence.shared.zvuki {
            zvukButtonOutlet.setImage(UIImage(named: "zvuk"), for: .normal)
        } else{
            zvukButtonOutlet.setImage(UIImage(named: "zvuk_otklyuchen"), for: .normal)
        }
        
        if Persistence.shared.music {
            melodyButtonOutlet.setImage(UIImage(named: "melodiy"), for: .normal)
        } else{
            melodyButtonOutlet.setImage(UIImage(named: "melodiy_otklyuchen"), for: .normal)
        }
    }
    
    func coinsStarsUpdate(){
        coinsAmountLabel.text = "\(Persistence.shared.totalCoins!)"
        starsAmountLabel.text = "\(Persistence.shared.totalStars!)"
    }
    
 
    static func loadFromNIB() -> TopBar{
        let nib = UINib(nibName: "TopBar", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! TopBar
    }
}

