//
//  LevelViewController.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit
import AudioToolbox


protocol LevelEndDelegate: NSObjectProtocol {
    func levelClosedUpdate()
}

class LevelViewController: UIViewController, UITextFieldDelegate  {
    weak var delegate: LevelEndDelegate?
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var answerTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewAspectRatioConstr: NSLayoutConstraint!
    @IBOutlet weak var stackViewHelps: UIStackView!
    @IBOutlet weak var freeCoinsButton: UIButton!
    
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var blur: UIVisualEffectView!
    // Labels
    @IBOutlet weak var songHelpLabel: UILabel!
    @IBOutlet weak var lettersLabel: UILabel!
    var keyboardHeight: CGFloat = 0.0
    
    
    //Buttons
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var songHelpButton: UIButton!
    @IBOutlet weak var lettersAmountHelpButton: UIButton!
    @IBOutlet weak var oneLetterHelpButton: UIButton!
    @IBOutlet weak var answerHelpButton: UIButton!
    
    let topBarVC = TopBar.loadFromNIB()
    let messageView = MessageView.loadFromNIB()
    let lettersView = LettersHelpView.loadFromNIB()
    let finishLevelView = FinishLvlView.loadFromNIB()
    
    var levelInfo: Level? = nil
    
    var selectedLetter = -1
    private let animDuration = 0.3
    private let doubleDuration: Double = 7
    private var helpUsed = false
    private var helpListBool = [false, false, false,false]
    private var levelSolved = false
    private var helpNum = 0
    private var timeSpend = 0.0
    private var starsViewList: [UIImageView] = []
    private let startTime = Date()
    private var interval = 0.0
    
    let prisesAmount = FinishLvlView().prisesAmount
    let smallStarsAmountWon = FinishLvlView().smallStarsAmountWon
    
    var starsAmount = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Persistence.shared.freeCoinsGotInt >= 5{
            Persistence.shared.freeCoinsGotInt = 0
        }
        levelSolved =  levelInfo?.isSolved ?? false
        starsViewList = [finishLevelView.firstStarImage, finishLevelView.secondStarImage, finishLevelView.thirdStarImage]
        FreeCoinsRewardClass.freeAdd.delegate = self
        answerButton.layer.cornerRadius = 5
        topBarVC.delegate = self
        messageView.delegate = self
        finishLevelView.delegate = self
        answerTextField.delegate = self
        selectedLetter = SaveLoadRealm.shared.getLevelLetterHelp(levelInfo!.premiaID, lvl: levelInfo!.lvlID)
        helpListBool = SaveLoadRealm.shared.getLevelHelpUse(levelInfo!.premiaID, lvl: levelInfo!.lvlID)
        
        view.layoutIfNeeded()
        topBarVC.backButtonOutlet.isHidden = true
        topBarVC.coinsStarsUpdate()
        answerButton.shadowSet()
        topBarView.addSubview(topBarVC)
        setLevelInfo()
        if levelSolved{
           
            setAnswerLabel()
            songHelpLabel.isHidden = false
            lettersLabel.isHidden = false
            helpsNOTAllowed()
        } else {
            helpsAllowed()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SaveLoadRealm.shared.saveLvlInfo(levelInfo!.premiaID, levelInfo!.lvlID, levelInfo!.levelImage, levelSolved, helpListBool, selectedLetter, timeSpend: interval)
        delegate?.levelClosedUpdate()
        
    }
    
    deinit {
    }
    
    func setLevelInfo(){
        mainImage.image = UIImage(named: (levelInfo?.levelImage)!)
        songHelpLabel.text = (levelInfo?.albom)!
    }
    
    func setAnswerLabel(){
        let correctAnswer = (levelInfo?.correctAnswers[0])!
        lettersLabel.text = ""
        for i in 0..<(correctAnswer.count){
            let index = correctAnswer.index(correctAnswer.startIndex, offsetBy: i)
            lettersLabel.text! += "\(correctAnswer[index].uppercased()) "
        }
    }
    
    @IBAction func checkAnswerButton(_ sender: Any) {
        let answer = answerTextField.text?.lowercased().trimmingCharacters(in: .whitespaces)
        for i in 0..<levelInfo!.correctAnswers.count{
            if (answer!.contains(levelInfo!.correctAnswers[i])){
                SoundsPlay.shared.playSound("win", "wav")
                if Persistence.shared.freeCoinsGotInt > 0{
                    Persistence.shared.freeCoinsGotInt += 1
                }

                var doublePrize = 1
                let endTime = Date()
                interval = Double(endTime.timeIntervalSince(startTime))
                if interval < doubleDuration {
                    doublePrize = 2
                }
                levelSolved = true
                starsAmount -= helpListBool.filter { used in used == true}.count
                finishLevelView.starsSet(starsAmount, starsViewList,doublePrize)
                LevelHelps().starsChange(smallStarsAmountWon[starsAmount], self.topBarVC.starsAmountLabel)
                LevelHelps().coinsChange(finishLevelView.prisesAmount[starsAmount] * doublePrize, self.topBarVC.coinsAmountLabel)


                answerTextField.isEnabled = false
                animateViewMoving(up: false)
                view.addSubview(finishLevelView)
                let colors = [UIColor(red: 1, green: 0, blue: 0, alpha: 0.1), UIColor(red: 0, green: 1, blue: 0, alpha: 0.1),UIColor(red: 0, green: 0, blue: 1, alpha: 0.1)]
                var i = 0
                blur.alpha = 0.9

                _  = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (t) in
                    self.blur.backgroundColor = colors[i]
                    if i + 1 > colors.count-1 {
                        i = 0
                    } else {
                        i += 1
                    }
                }
                break
                
            }
        }
        if !levelSolved{
            SoundsPlay.shared.playSound("wrongAnswer", "wav")
            SoundsPlay.shared.vibrateNotify()
            
        }
    }
    
    
    // ------ первая подсказка
    @IBAction func lettersAmountHelp(_ sender: Any) {
        if LevelHelps().enoughCoinsForHelp(HelpPrices.lettersAmountPrice.rawValue){
            showMessageView(1)
        } else {
            showMessageView(0,1)
        }
    }
    
    // ------ вторая подсказка
    @IBAction func oneLetterHelp(_ sender: Any) {
        if LevelHelps().enoughCoinsForHelp(HelpPrices.oneLetterPrice.rawValue){
            showMessageView(2)
        } else {
            showMessageView(0,2)
        }
    }
    
    // ------- Третья подсказка
    @IBAction func albomHelp(_ sender: Any) {
        if LevelHelps().enoughCoinsForHelp(HelpPrices.songNamePrice.rawValue){
            showMessageView(3)
        } else {
            showMessageView(0,3)
        }
    }
    
        // ------- Четвертая подсказка
    @IBAction func answerHelp(_ sender: Any) {
        if LevelHelps().enoughCoinsForHelp(HelpPrices.showAnswerPrice.rawValue){
            showMessageView(4)
        } else {
            showMessageView(0,4)
        }
    }
    
    func oneLetter(){
        let xPos = LettersHelpView().frameWidth
        let amount = (levelInfo?.correctAnswers[0].count)!
        let buttonWidth = (xPos / CGFloat(amount))-2
        let correctAnswer = (levelInfo?.correctAnswers[0])!
        for i in 0..<amount{
            let button = UIButton()
            button.frame = CGRect(x:xPos / 2 - CGFloat(amount)/2*buttonWidth + CGFloat(i)*buttonWidth, y: lettersView.frame.height / 2 - lettersView.frame.height / 4, width: buttonWidth, height: lettersView.bounds.height-10)
            button.shadowSet()
            let index = correctAnswer.index(correctAnswer.startIndex, offsetBy: i)
            if correctAnswer[index] != " "{
                button.isUserInteractionEnabled = true
                button.setImage(UIImage(named: "vybor_bukvy_podskazki"), for: .normal)
                button.setImage(UIImage(named: "vybor_bukvy_podskazki_tap"), for: .highlighted)
                button.setImage(UIImage(named: "vybor_bukvy_podskazki_tap"), for: .selected)
            } else {
                button.setImage(UIImage(named: "vybor_bukvy_podskazki_space"), for: .normal)
                button.isUserInteractionEnabled = false
            }
            button.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
            button.adjustsImageWhenHighlighted = false
            button.tag = i
            button.addTarget(self, action: #selector (letterSelected), for: .touchUpInside)
            lettersView.stackView.addSubview(button)
        }
        lettersView.stackView.spacing = 5
        lettersView.stackView.distribution = .fillEqually
        lettersView.stackView.alignment = .center
        view.addSubview(lettersView)
    }
    
    
    @objc func letterSelected(_ button: UIButton!,_ view: UIView){
        SoundsPlay.shared.playSound("common", "wav")
        
        selectedLetter = button.tag
        UIView.animate(withDuration: 0.4, animations: {
            self.blur.alpha = 0
            self.lettersView.alpha = 0
            //            self.view.layoutIfNeeded()
        })
        LevelHelps().oneLetterHelp(lettersLabel: lettersLabel, oneLetterHelpButton: oneLetterHelpButton, correctAnswer: (levelInfo?.correctAnswers[0])!, id: button.tag)
        oneLetterHelpButton.isEnabled = false
        lettersAmountHelpButton.isEnabled = false
        
        LevelHelps().coinsChange(HelpPrices.allCases[helpNum].rawValue,topBarVC.coinsAmountLabel)
        SoundsPlay.shared.playSound("spendMoney", "wav")
        helpListBool[helpNum-1] = true
        helpListBool[0] = true
    }
    
    
    @IBAction func freeCoinsInLevel(_ sender: Any) {

       if FreeCoinsRewardClass.freeAdd.freeCoinsAdShow(self){
        topBarVC.coinsAmountLabel.text = ("\(Persistence.shared.totalCoins!)")
            freeCoinsButton.isHidden = true
        }
//        topBarVC.coinsStarsUpdate()
    }
    
    private func showMessageView(_ num: Int,_ helpPrice: Int = 0){
        helpNum = num
        if num > 0{
            
            SoundsPlay.shared.playSound("appearingView", "wav")
            MessageView().showMessage(blur, "Вы уверены, что хотите использовать подсказку \"\(HelpTexts.allCases[num].rawValue)\"?\n(\(abs(HelpPrices.allCases[helpNum].rawValue)) монет)", view, okButton: false, messageView)
        } else {
            SoundsPlay.shared.playSound("WarningView", "wav")
            MessageView().showMessage(blur, "\(HelpTexts.allCases[num].rawValue)\n(Необходимо \(abs(HelpPrices.allCases[helpPrice].rawValue)) монет)", view, okButton: true, messageView)
        }
        
    }
    
    
    private func helpsAllowed(){
        if helpListBool[0]{
            lettersAmountHelpButton.isEnabled = false
            LevelHelps().lettersSpacesSet(selectedLetter, lettersLabel, (levelInfo?.correctAnswers[0])!)
        }
        if helpListBool[1]{
            lettersAmountHelpButton.isEnabled = false
            oneLetterHelpButton.isEnabled = false
            LevelHelps().lettersSpacesSet(selectedLetter, lettersLabel, (levelInfo?.correctAnswers[0])!)
        }
        
        if helpListBool[2]{
            songHelpButton.isEnabled = false
            songHelpLabel.isHidden = false
        }
                
        if Persistence.shared.freeCoinsGotInt == 0 {
            freeCoinsButton.isHidden = false
        }
    }
    
    private func helpsNOTAllowed(){
        for b in [lettersAmountHelpButton,oneLetterHelpButton,songHelpButton,answerButton,answerTextField,answerHelpButton]{
            b!.isEnabled = false
        }
        freeCoinsButton.isHidden = true
        answerTextField.placeholder = "Персонаж отгадан"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false)
    }
    
    func animateViewMoving (up:Bool){
        if up {
            NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = 0
                self.stackViewAspectRatioConstr.constant = 0
                self.stackViewHelps.spacing = 25
            })
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomConstraint.constant = self.keyboardHeight
                self.stackViewAspectRatioConstr.constant = 0
                self.stackViewHelps.spacing = 25
            })
        }
    }
}

extension LevelViewController: MessageViewDelegate{
    func qestionAnswered(_ useHelp: Bool) {
       if useHelp{
            switch helpNum {
            case 2:                             //подсказка выбор одной буквы
                messageView.removeMessageView(blur,false)
                oneLetter()
            case 3:                             //подсказка альбом
                SoundsPlay.shared.playSound("spendMoney", "wav")
                helpListBool[helpNum-1] = true
                messageView.removeMessageView(blur)
                
                LevelHelps().coinsChange(HelpPrices(rawValue: helpNum)!.rawValue,topBarVC.coinsAmountLabel)
                LevelHelps().albomHelp(songHelpLabel: songHelpLabel, songHelpButton: songHelpButton)
            case 4:
                 SoundsPlay.shared.playSound("answerHelp", "wav")
                 messageView.removeMessageView(blur)
                 setAnswerLabel()
                 helpListBool[helpNum-1] = true
                 lettersLabel.isHidden = false
                 songHelpLabel.isHidden = false
                 levelSolved = true
                 LevelHelps().coinsChange(HelpPrices(rawValue: helpNum)!.rawValue,topBarVC.coinsAmountLabel)
                 helpsNOTAllowed()
                let endTime = Date()
                interval = Double(endTime.timeIntervalSince(startTime))
            default:                        //подсказка количество букв
                SoundsPlay.shared.playSound("spendMoney", "wav")
                helpListBool[helpNum-1] = true
                messageView.removeMessageView(blur)
                LevelHelps().coinsChange(HelpPrices(rawValue: helpNum)!.rawValue,topBarVC.coinsAmountLabel)
                LevelHelps().lettersAmountHelp(lettersLabel: lettersLabel, lettersAmountHelpButton: lettersAmountHelpButton, correctAnswer: (levelInfo?.correctAnswers[0])!)
            }
        } else {
            messageView.removeMessageView(blur)
        }
    }
    
}
extension LevelViewController: TopBarDelegate {
    func closeVC() {
    }
}

extension LevelViewController: FinishLvlViewDelegate{
    func okCkicked() {
       self.dismiss(animated:true, completion: nil)
    }
}

extension LevelViewController: FreeCoinsDelegate{
    func freeCoinsSuccess() {
        topBarVC.coinsStarsUpdate()
    }
    
    
}
