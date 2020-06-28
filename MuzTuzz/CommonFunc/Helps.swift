
import Foundation
import UIKit

class LevelHelps{
    weak var helpLabel: UILabel!
    private var buttonTapped: UIButton!
    
    let lettersView = LettersHelpView.loadFromNIB()
    let prices = [-150,-250,-350]
    var selectedLetter = 0
    var correctAnswer = ""
    
    func albomHelp(songHelpLabel: UILabel,songHelpButton: UIButton){
        self.helpLabel = songHelpLabel
        buttonTapped = songHelpButton
        helpLabel.isHidden = false
//        buttonTapped.setImage(UIImage(named: "podskazka_albom_pesny_zakrita"), for: .normal)
        buttonTapped.isEnabled = false

    }
    
    
    func lettersAmountHelp(lettersLabel: UILabel,lettersAmountHelpButton: UIButton, correctAnswer: String){
        self.helpLabel = lettersLabel
        buttonTapped = lettersAmountHelpButton
        self.correctAnswer = correctAnswer
        lettersSpacesSet(-1, lettersLabel,correctAnswer)
        buttonTapped.isEnabled = false

        
    }
    
    func lettersSpacesSet(_ id: Int = -1,_ helpLabel: UILabel,_ correctAnswer: String){
        var stringForHelp = ""
        var choosenLetter = ""
        if id >= 0 {
            let index = correctAnswer.index(correctAnswer.startIndex, offsetBy: id)
            choosenLetter = correctAnswer[index].uppercased()
        }
        for i in 0..<correctAnswer.count{
            if i == id {
                stringForHelp.append("\(choosenLetter) ")
            }else {
                let index = correctAnswer.index(correctAnswer.startIndex, offsetBy: i)
                if correctAnswer[index] != " "{
                    stringForHelp += "_ "
                } else {
                    stringForHelp += "   "
                }
            }
        }
        helpLabel.text = stringForHelp
        helpLabel.isHidden = false
    }
    
    func oneLetterHelp(lettersLabel: UILabel,oneLetterHelpButton: UIButton, correctAnswer: String, id: Int){
        self.helpLabel = lettersLabel
        buttonTapped = oneLetterHelpButton
        self.correctAnswer = correctAnswer
        lettersSpacesSet(id, lettersLabel,correctAnswer )
        buttonTapped.isUserInteractionEnabled = false
    }

    func starsChange(_ starsAmount: Int, _ starsLabel: UILabel? = nil){
        var step = 1
        let firstNum = Persistence.shared.totalStars!
        Persistence.shared.totalStars! += starsAmount
        let secondNum = Persistence.shared.totalStars!
        
        starsLabel!.tag = firstNum
        _  = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (t) in
            starsLabel!.text =  "\(starsLabel!.tag)"
            starsLabel!.tag += step
            if  starsLabel!.tag == secondNum+1 {
                t.invalidate()
            }
            
        }
    }

    
    func coinsChange(_ helpPrice: Int,_ coinsLabel: UILabel? = nil){
        var step = 0
        var stepStars = 0
        let firstNum = Persistence.shared.totalCoins!
        let firstNumStars = Persistence.shared.totalStars
        Persistence.shared.totalCoins! += helpPrice
        let secondNum = Persistence.shared.totalCoins!
        if helpPrice < 0 {
            step = -5
        } else {
            step = 1
        }
        
        coinsLabel!.tag = firstNum
        _  = Timer.scheduledTimer(withTimeInterval: 0.000001, repeats: true) { (t) in
            coinsLabel!.text =  "\(coinsLabel!.tag)"
            coinsLabel!.tag += step
            if step < 0 {
                if  coinsLabel!.tag <= secondNum-4 {
                    t.invalidate()
                }
            } else {
                if coinsLabel!.tag == secondNum+1{
                    t.invalidate()
                }
            }
        }
    }
    
    func enoughCoinsForHelp(_ helpPrice: Int) -> Bool{
        if Persistence.shared.totalCoins ?? 0 >=  abs(helpPrice) {
            return true
        } else {
            return false
        }
    }
}




