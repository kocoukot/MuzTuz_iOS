//
//  PremiaVC.swift
//  MuzTuzz
//
//  Created by Anton on 13.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

protocol PremiaVCDelegate {
    func premiaInfoUpdate()
}


class PremiaVC: UIViewController, LevelChooseDelegate   {
    var delegate: PremiaVCDelegate?
    
    
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    let topBarVC = TopBar.loadFromNIB()


    var cardSize: CGSize?
    var selectedLevel = 0
    var premiaID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topBarVC.delegate = self
        topBarVC.coinsStarsUpdate()
        topBarView.addSubview(topBarVC)
    }
    
    func levelNumber(_ number: PremiaCollectionViewCell) {
        selectedLevel = self.collection.indexPath(for: number)!.row
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.premiaInfoUpdate()
        topBarVC.removeFromSuperview()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LevelViewController, segue.identifier == "levelSegue"{
            if let level = Level(levelImage: LevelsInfo().premiaImagesList[premiaID][selectedLevel], correctAnswers: LevelsInfo().correctAnswersList[premiaID][selectedLevel], albom:  LevelsInfo().AlbomsList[premiaID][selectedLevel], lvlID: selectedLevel,premiaID: premiaID){
                vc.levelInfo = level
                vc.delegate = self
            }
        }
    }
}

extension PremiaVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let w = UIScreen.main.bounds.size.width / 3 - 20
        return CGSize(width: w, height: w * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LevelsInfo().premiaImagesList[premiaID].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCard", for: indexPath) as! PremiaCollectionViewCell
        cell.levelButton.setImage(UIImage(named: LevelsInfo().premiaImagesList[premiaID][indexPath.row]), for: .normal)
        cell.solvedImage.isHidden = !SaveLoadRealm().getPremiaLevelsInfo(premiaID)[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension PremiaVC: LevelEndDelegate{
    func levelClosedUpdate() {
        topBarVC.iconsUpdate()
        topBarVC.coinsAmountLabel.text = "\(Persistence.shared.totalCoins!)"
        topBarVC.starsAmountLabel.text = "\(Persistence.shared.totalStars!)"

        collection.reloadData()
    }
}

extension PremiaVC: TopBarDelegate{
    func closeVC() {
        dismiss(animated: true)
    }
}
