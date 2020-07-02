//
//  TutorialViewController.swift
//  MuzTuzz
//
//  Created by Anton on 20.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit
protocol TutorialEndDelegate: NSObjectProtocol {
    func tutorialEndUpdate(_ lvlSolved: Bool)
}

class TutorialViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: TutorialEndDelegate?
    
    @IBOutlet weak var answerButton: UIButton!

    @IBOutlet weak var lettersAmountHelpButton: UIButton!
    @IBOutlet weak var oneLetterHelpButton: UIButton!
    @IBOutlet weak var songHelpButton: UIButton!
    @IBOutlet weak var answerHelpButton: UIButton!
    
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var songHelpLabel: UILabel!
    @IBOutlet weak var lettersLabel: UILabel!
    
    @IBOutlet weak var firstArrowImage: UIImageView!
    @IBOutlet weak var rightArrowImage: UIImageView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewAspectRatioConstr: NSLayoutConstraint!
    @IBOutlet weak var stackViewHelps: UIStackView!
    @IBOutlet weak var topBarView: UIView!
    
    let topBarVC = TopBar.loadFromNIB()
    let messageView = MessageView.loadFromNIB()
    let lettersView = LettersHelpView.loadFromNIB()
    var keyboardHeight: CGFloat = 0.0
    
    
    var levelInfo: Level? = nil
    
    var selectedLetter = -1
    let animDuration = 0.3
    var levelSolved = false
     var helpListBool = [false, false, false,false]
    var exitMessage = false
    var helpNum = 0
    var messageNum = 0
    let buttonsImageList = ["","","podskazka_kolichestvo_bukv","podskazka_lubay_bukva","podskazka_albom_pesny",""]
    let arrowList = ["strelka2_1_animaciya", "strelka2_2_animaciya"]
    let arrowListRight = ["strelka1_2_animaciya", "strelka1_1_animaciya"]
    
    
    let messagesList = ["Рады приветствовать Вас в МузТус!",
                        "Вы ведущий церемонии награждения престижной музыкальной премии. Рядом с вами на сцене стоят номинанты. \nСвет софитов бьет вам в глаза, не давая различить их лиц, а свою речь вы, как назло, забыли дома. \nКто же получит награду? Зал затаил дыхание…",
                        "Не все потеряно, в зале фанаты подняли плакаты с именем любимого исполнителя, сами буквы не видны, но можно посчитать их количество. Пока вы пристально вглядываетесь, оператор делает круглые глаза, в его взгляде читается: «Время - деньги!» Ничего страшного. Смело берите подсказку «Количество букв»!",
                        "Лицо оператора багровеет, глаза стекленеют от гнева. Время идёт, но это не помогает. К счастью, вы различаете одну из букв! Смело берите подсказку «Открыть букву»!",
                        "«Шанс - он не получка, не аванс», - как поется в одной известной пиратской песне. Но вот штрафа или выговора еще можно избежать, и вы обращаетесь к залу с просьбой назвать любимую песню у этого исполнителя. \nСмело берите подсказку «Название песни и альбома»!",
                        "Oтвет вводите в эту строчку. Достаточно имени и фамилии, только фамилии/псевдонима, названия группы. Написали? Нажимайте на галочку. Но помните, некоторые творцы очень трепетно относятся к своим именам.",
                        "Если возникли трудности с отгадываем персонажа или группы, можете воспользоваться последней подсказкой и открыть весь уровень. Правда в дальнейшем стоить это будет немало!",
                        "Поздравляем с окончанием обучения! Можете приступать к основным уровням!"]
    
    private let helpsName = ["Количество букв", "Показать выбранную букву", "Показать название песни и альбома","Показать ответ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerButton.layer.cornerRadius = 5
        CommonFuncs().shadowSet(answerButton)
        levelSolved =  SaveLoadRealm().getPremiaLevelsInfo(levelInfo!.premiaID)[levelInfo!.lvlID]

        topBarVC.delegate = self
        messageView.delegate = self
        answerTextField.delegate = self
        
        view.layoutIfNeeded()
        messageView.alpha = 0
        topBarVC.backButtonOutlet.isHidden = false
        topBarVC.coinsStarsUpdate()

        topBarView.addSubview(topBarVC)
        songHelpLabel.text = (levelInfo?.albom)!
        
        messageView.showMessage(nil, messagesList[messageNum], view, okButton: true, messageView)
        
        
        var i = 0
        var r = 0
        _  = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (t) in
            self.firstArrowImage.image = UIImage(named: self.arrowList[i])
            self.rightArrowImage.image = UIImage(named: self.arrowListRight[r])
            if i + 1 > self.arrowList.count-1 {
                i = 0
                r = 0
            } else {
                i += 1
                r += 1
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SaveLoadRealm().saveLvlInfo(levelInfo!.premiaID, levelInfo!.lvlID, levelInfo!.levelImage, levelSolved, helpListBool, selectedLetter)
        delegate?.tutorialEndUpdate(levelSolved)
    }
    
    
    
    @IBAction func checkAnswerButton(_ sender: Any) {
        let answer = answerTextField.text?.lowercased().trimmingCharacters(in: .whitespaces)
        for i in 0..<levelInfo!.correctAnswers.count{
            if (answer!.contains(levelInfo!.correctAnswers[i])){
               
                SoundsPlay.shared.playSound("win", "wav")
                levelSolved = true
                answerTextField.isEnabled = false
                animateViewMoving(up: false)
                messageView.showMessage(nil, messagesList[messageNum], view, okButton: true, messageView)
                 messageNum += 1

            }
        }
        if !levelSolved{
            SoundsPlay.shared.playSound("wrongAnswer", "wav")
            SoundsPlay.shared.vibrateNotify()

        }
    }
    
    // ------ первая подсказка
    @IBAction func lettersAmountHelp(_ sender: Any) {
        showHelpMessageView(0)
    }
    
    // ------ вторая подсказка
    @IBAction func oneLetterHelp(_ sender: Any) {
        showHelpMessageView(1)
    }
    
    // ------- Третья подсказка
    @IBAction func albomHelp(_ sender: Any) {
        showHelpMessageView(2)
    }
    
    
    @IBAction func answerHelp(_ sender: Any) {
        showHelpMessageView(3)
    }
    
    func oneLetter(){
        let xPos = LettersHelpView().frameWidth
        let amount = (levelInfo?.correctAnswers[0].count)!
        let buttonWidth = (xPos / CGFloat(amount))-2
        let correctAnswer = (levelInfo?.correctAnswers[0])!
        for i in 0..<amount{
            let button = UIButton()
            button.frame = CGRect(x:xPos / 2 - CGFloat(amount)/2*buttonWidth + CGFloat(i)*buttonWidth, y: lettersView.frame.height / 2 - lettersView.frame.height / 4, width: buttonWidth, height: lettersView.bounds.height-10)
            CommonFuncs().shadowSet(button)
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
            //            self.blur.alpha = 0
            self.lettersView.alpha = 0
            self.view.layoutIfNeeded()
        })
        LevelHelps().oneLetterHelp(lettersLabel: lettersLabel, oneLetterHelpButton: oneLetterHelpButton, correctAnswer: (levelInfo?.correctAnswers[0])!, id: button.tag)
        oneLetterHelpButton.isEnabled = false
        messageView.alpha = 0
        UIView.animate(withDuration: 0.6, delay: 0.2 ,animations: {
            self.messageView.buttonsStackView.isHidden = true
            self.messageView.okButton.isHidden = false
            self.messageView.alpha = 1
            self.infoMessages()
        })
        SoundsPlay.shared.playSound("spendMoney", "wav")
    }
    
    private func showHelpMessageView(_ num: Int){
        helpNum = num
        firstArrowImage.isHidden = true
        SoundsPlay.shared.playSound("appearingView", "wav")
        MessageView().showMessage(nil, "Вы уверены, что хотите использовать подсказку \"\(helpsName[num])?", view, okButton: false, messageView)
        messageView.noButton.isEnabled = false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false)
    }
    
    @IBAction func testAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func animateViewMoving (up:Bool){
        if up {
            NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShowTutorial),name: UIResponder.keyboardWillShowNotification, object: nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.bottomConstraint.constant = 0

            })
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillShowTutorial(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomConstraint.constant = self.keyboardHeight

            })
        }
    }
    
    func changeMessage(){
        UIView.animate(withDuration: 0.6,delay: 0.2 ,animations: {
            self.messageView.alpha = 0
            self.messageView.messageLabel.textAlignment = .center
            self.messageView.messageLabel.text = self.messagesList[self.messageNum]
            self.messageView.alpha = 1
        })
    }
}



extension TutorialViewController: MessageViewDelegate{
    func qestionAnswered(_ useHelp: Bool) {
        if useHelp{
            // обработка подсказок
            switch helpNum {
            case 1:                             //подсказка выбор одной буквы
                messageView.removeMessageView(nil,false)
                oneLetter()
            case 2:                             //подсказка альбом
                SoundsPlay.shared.playSound("spendMoney", "wav")
                messageView.removeMessageView()
                songHelpLabel.isHidden = false
                songHelpButton.isEnabled = false
                rightArrowImage.isHidden = true
                messageNum += 1
                messageView.messageLabel.textAlignment = .center
                messageView.messageLabel.text = messagesList[messageNum]
                messageView.buttonsStackView.isHidden = true
                messageView.okButton.isHidden = false
                firstArrowImage.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 50, y: answerTextField.frame.origin.y - 100, width: 100, height: 90)
                rightArrowImage.frame = CGRect(x: self.answerButton.frame.origin.x - 50 , y: answerTextField.frame.origin.y - 100, width: 100, height: 90)
                messageNum += 1
                UIView.animate(withDuration: 0.6,delay: 0.5, animations: {
                    self.messageView.alpha = 1
                    self.firstArrowImage.isHidden = false
                    self.rightArrowImage.isHidden = false
                })
            case 3:
                SoundsPlay.shared.playSound("answerHelp", "wav")
                messageView.removeMessageView()
                lettersLabel.text = "МУМИЙ ТРОЛЛЬ"
                lettersLabel.isHidden = false
                songHelpLabel.isHidden = false
                answerTextField.isEnabled = false
                answerButton.isEnabled = false
                answerHelpButton.isEnabled = false
                
            default:                        //подсказка количество букв
                SoundsPlay.shared.playSound("spendMoney", "wav")
                messageView.removeMessageView()
                lettersLabel.text = "_ _ _ _ _   _ _ _ _ _ _"
                lettersLabel.isHidden = false
                lettersAmountHelpButton.isEnabled = false
                messageNum += 1
                messageView.showMessage(nil, messagesList[messageNum], view, okButton: true, messageView) // Не все потеряно юзай перdую подсказку
            }
            
        }
        // информ сообщения
        else {
            if !exitMessage{
                infoMessages()
            } else {
                
                // обработка последних информ сообщенй и включение подсказок
                messageView.removeMessageView()
                switch messageNum {
                case 2:
                    firstArrowImage.frame = CGRect(x: stackViewHelps.frame.origin.x + lettersAmountHelpButton.frame.width/2 - 25 , y: stackViewHelps.frame.origin.y - 100, width: 100, height: 90)
                    firstArrowImage.isHidden = false
                    lettersAmountHelpButton.isEnabled = true
                case 3:

                    firstArrowImage.frame = CGRect(x:oneLetterHelpButton.frame.origin.x + oneLetterHelpButton.frame.width / 4   , y: stackViewHelps.frame.origin.y - 90, width: 100, height: 90)
                    firstArrowImage.isHidden = false
                    oneLetterHelpButton.isEnabled = true
                    
                case 4:
                    rightArrowImage.frame = CGRect(x: songHelpButton.frame.origin.x - songHelpButton.frame.width / 2, y: stackViewHelps.frame.origin.y - 90, width: 100, height: 90)
                    rightArrowImage.isHidden = false
                    songHelpButton.isEnabled = true
                    
                case 6:
                    firstArrowImage.isHidden = true
                    changeMessage()
                    rightArrowImage.frame = CGRect(x: answerHelpButton.frame.origin.x - answerHelpButton.frame.width / 2, y: stackViewHelps.frame.origin.y - 90, width: 100, height: 90)
                    rightArrowImage.isHidden = false
                    exitMessage = true
                    messageNum += 1
                    
                case 7:
                    firstArrowImage.isHidden = true
                    rightArrowImage.isHidden = true
                    answerButton.isEnabled = true
                    answerTextField.isEnabled = true
                    answerHelpButton.isEnabled = true

                    
                default:
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func infoMessages(){
        // вывод информ сообщений
        switch messageNum {
            
        case 0:
            messageNum += 1                 //рады приветствовать
            changeMessage()
        case 1:
            messageView.viewWidth = UIScreen.main.bounds.width / 1.28
            messageView.viewHeight = (messageView.viewWidth) * 0.9
            
            messageView.viewX = UIScreen.main.bounds.width / 2 - (messageView.viewWidth)/2
            messageView.viewY = UIScreen.main.bounds.height / 4
            
            messageView.layoutIfNeeded()
            messageNum += 1
            changeMessage()                 // вы ведущий
            exitMessage = true
        case 2:
            messageNum += 1
            changeMessage()
            exitMessage = true
        case 3:
            messageNum += 1
            changeMessage()
            exitMessage = true
        case 4:
            messageNum += 1
            changeMessage()
            exitMessage = true
            
        default:
            messageView.removeMessageView()
        }
    }
}

extension TutorialViewController: TopBarDelegate{
    func closeVC() {
        dismiss(animated: true)
    }
    
    
}

