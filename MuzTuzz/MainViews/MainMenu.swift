//
//  ViewController.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MessageViewDelegate {
    
    let topBarVC = TopBar.loadFromNIB()
    let messageView = MessageView.loadFromNIB()
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var statisticButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var creatirsButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var blur: UIVisualEffectView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let buttonsList = [playButton, statisticButton,resetButton,creatirsButton,shopButton  ]
        for b in buttonsList{
            CommonFuncs().shadowSet(b!)
        }
        
//        ProductsLib.productClass.loadShop()
        
        
        topBarVC.delegate = self
        messageView.delegate = self
        topBarVC.backButtonOutlet.isHidden = true
        topBarVC.coinsStarsUpdate()
        if !Persistence.shared.first{
            messageView.viewWidth = UIScreen.main.bounds.width / 1.28
            messageView.viewHeight = (messageView.viewWidth) * 0.9

            messageView.viewX = UIScreen.main.bounds.width / 2 - (messageView.viewWidth)/2
            messageView.viewY = UIScreen.main.bounds.height / 4
            MessageView().showMessage(blur, "Вся информация, представленная в приложении, за исключением информации, имеющей ссылку на конкретный источник, является художественным вымыслом и не имеет отношения к реальным лицам и событиям. Автор не несет ответственности за случайным совпадения с реальными лицами и событиями.", view,okButton: true, messageView )
        }
        topBarView.addSubview(topBarVC)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PremiaSelectVC, segue.identifier == "premiaList"{
            vc.delegate = self
        } else if let vc = segue.destination as? TestVC, segue.identifier == "shopSegueID"{
            vc.delegate = self
        }
    }
    
    
    @IBAction func playButtonClick(_ sender: Any) {
        SoundsPlay.shared.playSound("swipe2", "wav")
    }
    
    @IBAction func statisticButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
    }
    
    @IBAction func shopButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
    }
    
    @IBAction func resetButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        MessageView().showMessage(blur, "Вы уверены, что хотите удалить все свои достиженя?", view,okButton: false, messageView )
    }
    
    @IBAction func authorsButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
    }
    
    @IBAction func removeShadow(_ sender: Any) {
        (sender as AnyObject).layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    @IBAction func returnShadow(_ sender: Any) {
        (sender as AnyObject).layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
    }
    
    func qestionAnswered(_ useHelp: Bool) {
        if useHelp{
            Persistence.shared.totalSaved = false
            SaveLoadRealm().deleteRealm()
            Persistence.shared.totalStars = 0
            topBarVC.coinsStarsUpdate()
            SoundsPlay.shared.playSound("ResetAll", "wav")
        }
        blur.alpha = 0
        messageView.alpha = 0
    }
    
    
    @IBAction func vkButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        CommonFuncs().openURL("https://vk.com/kocou_kot")
    }
    
//    @IBAction func fbButton(_ sender: Any) {
//        SoundsPlay.shared.playSound("common", "wav")
//        CommonFuncs().openURL("https://www.facebook.com/shimpaks")
//    }
//    
//    @IBAction func twitButton(_ sender: Any) {
//        SoundsPlay.shared.playSound("common", "wav")
//        CommonFuncs().openURL("https://twitter.com/gugel_hunds")
//    }
    
    @IBAction func instaButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        CommonFuncs().openURL("https://www.instagram.com/alexzhegulov/")
    }
}


extension ViewController: PremiaSelectVCDelegate, ShopDelegate{
    func topBarIconsUpdate() {
        topBarVC.iconsUpdate()
        topBarVC.coinsStarsUpdate()
    }
    
    func shopClosed() {
        topBarVC.iconsUpdate()
        topBarVC.coinsStarsUpdate()
    }
}

extension ViewController: TopBarDelegate{
    func closeVC() {
    }
}

