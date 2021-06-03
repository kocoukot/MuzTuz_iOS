

import UIKit

protocol PremiaChooseDelegate: NSObjectProtocol {
    func premiaNumber(_ number: PremiaCell)
}


class PremiaCell: UITableViewCell, MessageViewDelegate {
    
    weak var delegate: PremiaChooseDelegate?
    
    let messageView = MessageView.loadFromNIB()
    
    @IBOutlet weak var premiaButtonOutlet: UIButton!
    weak var blur: UIVisualEffectView? = nil
    let percentage = 80.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.alpha = 0
        messageView.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onPremiaChoose(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
        delegate?.premiaNumber(self)
    }
    
    func premiaStatusSet(_ index: Int,_ blur: UIVisualEffectView,_ view: UIView){
        self.blur = blur
        if index > 1 && index < 7{
            if openLvl(index){
                if !SaveLoadRealm.shared.getPremiaInfo(index){
                    SoundsPlay.shared.playSound("OpenPremia", "wav")
                    MessageView().showMessage(blur, "Поздравляем с открытием новой премии!", view,okButton: true, messageView )
                    SaveLoadRealm.shared.savePremiaInfo(index)
                }
                
                premiaButtonOutlet.setImage(UIImage(named: LevelsInfo.premiaDisksList[index][SaveLoadRealm.shared.getPremiaLevelsInfo(index).filter{solved in solved == true}.count]), for: .normal)
                premiaButtonOutlet.isUserInteractionEnabled = true
            } else {
                premiaButtonOutlet.setImage(UIImage(named: LevelsInfo.premiaDisksListClosed[index]), for: .normal)
                premiaButtonOutlet.isUserInteractionEnabled = false
            }
        } else {
            premiaButtonOutlet.setImage(UIImage(named: LevelsInfo.premiaDisksList[index][SaveLoadRealm.shared.getPremiaLevelsInfo(index).filter{solved in solved == true}.count]), for: .normal)
            premiaButtonOutlet.isUserInteractionEnabled = true
        }
    }
    
    private func openLvl(_ index: Int) -> Bool{
        if Double(SaveLoadRealm.shared.getPremiaLevelsInfo(index-1).filter{solved in solved == true}.count) / Double(SaveLoadRealm.shared.getPremiaLevelsInfo(index-1).count)*100 >= percentage{
            return true
        } else {
            return false
        }
    }
    
    
    func qestionAnswered(_ useHelp: Bool) {
        messageView.removeMessageView(self.blur!)
    }
    
}
