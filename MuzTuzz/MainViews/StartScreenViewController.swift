
import UIKit

class StartScreenViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var fireImage: UIImageView!
    
    let screenWidth = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FreeCoinsRewardClass.freeAdd.adLoad()
        startButton.frame = CGRect(x:  10, y: UIScreen.main.bounds.height, width:  screenWidth-20, height:  screenWidth * 1.02)
        self.view.layoutIfNeeded()
        setMusic()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.9,delay:0.1,usingSpringWithDamping: 0.3,initialSpringVelocity: 0.2, options: .curveEaseInOut , animations: {
            self.startButton.frame = CGRect(x:  10, y:self.image.frame.height, width:  self.screenWidth-20, height:  self.screenWidth * 1.02)
        })
    }
    
    private func setMusic(){
        SoundsPlay.shared.prepareBackgroundMusic()
        if !Persistence.shared.first{
            SoundsPlay.shared.startBackgroundMusic()
            Persistence.shared.music = true
            Persistence.shared.zvuki = true
        } else if Persistence.shared.music{
            SoundsPlay.shared.startBackgroundMusic()
        }
    }
    
    @IBAction func playButton(_ sender: Any) {
        SoundsPlay.shared.playSound("common", "wav")
    }
    
    
}
