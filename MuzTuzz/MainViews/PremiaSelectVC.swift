

import UIKit

protocol PremiaSelectVCDelegate {
    func topBarIconsUpdate()
}

class PremiaSelectVC: UIViewController, PremiaChooseDelegate {
    var delegate: PremiaSelectVCDelegate?
    
    @IBOutlet weak var premiaTable: UITableView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var blurEfect: UIVisualEffectView!
    
    let premiaList = ["obychenie_0", "lvl10", "lvl20", "3lvl0", "4lvl0", "5lvl0", "6lvl0", "7lvl0"]
    var selectedLevel = 0
    
    let topBarVC = TopBar.loadFromNIB()
    let messageView = MessageView.loadFromNIB()

    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBarVC.delegate = self
        topBarVC.coinsStarsUpdate()
        topBarVC.delegate = self
        messageView.delegate = self
        topBarView.addSubview(topBarVC)
        FreeCoinsRewardClass.freeAdd.interstitialAdLoad()

       
        
        if !Persistence.shared.totalSaved{
            SaveLoadRealm().saveRealmData()
        }
        
        if !Persistence.shared.first{
            
            messageView.showMessage(nil, "Похоже это твой первый визит в игру МузТус! Рекомендуем сперва пройти небольшое обучение, чтобы разобраться что к чему. К тому же, если пройдешь обучение, получишь небольшой приятный стартовый бонус.", view, okButton: true, messageView)
            Persistence.shared.first = true
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.topBarIconsUpdate()
    }
    
    func premiaNumber(_ number: PremiaCell) {
        selectedLevel = self.premiaTable.indexPath(for: number)!.row 
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PremiaVC, segue.identifier == "premiaChooseID"{
            vc.premiaID = selectedLevel
            vc.delegate = self
        } else if let vc = segue.destination as? TutorialViewController, segue.identifier == "tutorialCellID"{
            if let level = Level(levelImage: LevelsInfo().premiaImagesList[selectedLevel][0], correctAnswers: LevelsInfo().correctAnswersList[selectedLevel][0], albom: LevelsInfo().AlbomsList[selectedLevel][0], lvlID: selectedLevel, premiaID: selectedLevel){
                vc.delegate = self
                vc.levelInfo = level
            }
        }
    }
}

extension PremiaSelectVC: TopBarDelegate{
    func closeVC() {
        dismiss(animated: true)
    }
}

extension PremiaSelectVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return premiaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellID = ""
        if indexPath.row == 0 {
            cellID = "tutorialCell"
        } else {
            cellID = "premiaCell"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! PremiaCell
        cell.delegate = self
        cell.premiaStatusSet(indexPath.row, blurEfect, view)
        if indexPath.row == LevelsInfo().premiasAmount-1{
            cell.premiaButtonOutlet.isUserInteractionEnabled = false
        }
        return cell
    }
}

extension PremiaSelectVC: PremiaVCDelegate, TutorialEndDelegate, MessageViewDelegate{
    func qestionAnswered(_ useHelp: Bool) {
        messageView.removeMessageView(nil)
    }
    
    func tutorialEndUpdate(_ lvlSolved: Bool) {
        premiaTable.reloadData()
        if SaveLoadRealm().getPremiaLevelsInfo(0)[0] && !Persistence.shared.gotCoinsForTutorial{
            Persistence.shared.gotCoinsForTutorial = true
            LevelHelps().coinsChange(200, topBarVC.coinsAmountLabel)
        }
        topBarVC.iconsUpdate()
        
    }
    
    func premiaInfoUpdate() {
        topBarVC.iconsUpdate()
        topBarVC.coinsStarsUpdate()
        premiaTable.reloadData()
        
        _  = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            FreeCoinsRewardClass.freeAdd.interstitialAdShow(self)
            FreeCoinsRewardClass.freeAdd.interstitialAdLoad()
            t.invalidate()
        }
    }
}
