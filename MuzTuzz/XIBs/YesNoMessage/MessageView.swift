//
//  MessageView.swift
//  MuzTuzz
//
//  Created by Anton on 14.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

protocol MessageViewDelegate: NSObjectProtocol{
    func qestionAnswered(_ useHelp: Bool)
}

class MessageView: UIView {
    weak var delegate: MessageViewDelegate?
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    let animDuration = 0.3
    var viewWidth = UIScreen.main.bounds.width / 1.5
    var viewHeight = (UIScreen.main.bounds.width / 1.5) * 0.7

    var viewX = UIScreen.main.bounds.width / 2 - (UIScreen.main.bounds.width / 1.5)/2
    var viewY = UIScreen.main.bounds.height / 3
    

    //    let messageViewww = MessageView.loadFromNIB()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CommonFuncs().shadowSet(yesButton)
        CommonFuncs().shadowSet(noButton)

        yesButton.layer.cornerRadius = 10
        noButton.layer.cornerRadius = 10
        self.layer.cornerRadius = 15
        
        
        self.frame = CGRect(x: viewX  , y: viewY, width: viewWidth , height: viewHeight)
    }
    
    
    
    
    @IBAction func yesAnswer(_ sender: Any) {
        delegate?.qestionAnswered(true)
        

    }

    
    @IBAction func okAnswer(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")        // click sound
        delegate?.qestionAnswered(false)

    }
    
    @IBAction func noAnswer(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")        // click sound
        delegate?.qestionAnswered(false)

    }
    
    func showMessage(_ blur:UIVisualEffectView? = nil,_ text: String,_ view: UIView,okButton: Bool,_ messageView: MessageView){
        
        if okButton{
            messageView.buttonsStackView.isHidden = true
            messageView.okButton.isHidden = false
            messageView.messageLabel.textAlignment = .center
        } else {
            messageView.buttonsStackView.isHidden = false
            messageView.okButton.isHidden = true
            messageView.messageLabel.textAlignment = .left
        }
        messageView.alpha = 0
        messageView.messageLabel.text = text
        view.addSubview(messageView)
        UIView.animate(withDuration: 0.5, animations: {
            messageView.alpha = 1
            blur?.alpha = 0.9
        })
    }
    
    func removeMessageView(_ blur:UIVisualEffectView? , _ removeBlur: Bool = true){
        UIView.animate(withDuration: animDuration, animations: {
            if removeBlur {
                blur?.alpha = 0
            }
            self.alpha = 0
        })
    }
    
    static func loadFromNIB() -> MessageView{
        let nib = UINib(nibName: "HelpQuestionView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! MessageView
    }
}

