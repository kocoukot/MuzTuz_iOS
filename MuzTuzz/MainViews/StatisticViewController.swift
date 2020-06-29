//
//  StatisticViewController.swift
//  MuzTuzz
//
//  Created by Anton on 23.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit

class StatisticViewController: UIViewController {

    @IBOutlet weak var sumGameTime: UILabel!
    @IBOutlet weak var levelsSolved: UILabel!
    @IBOutlet weak var helpsUsed: UILabel!
    @IBOutlet weak var fastestTime: UILabel!
    @IBOutlet weak var longestTime: UILabel!
    
    @IBOutlet weak var fastestLevelImage: UIImageView!
    @IBOutlet weak var longestImage: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    let infoList = SaveLoadRealm().getSumGameTime()
    let levelsSolvedAmount = SaveLoadRealm().getSolvedLevelAmount()
//    [sumTime, minTime, maxTime, Double(minTP),Double(minTL),Double(maxTP),Double(maxTL) Double(helpsUsed)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timeFormat = DateFormatter()
        backView.layer.cornerRadius = 15
        let timeLabelList = [sumGameTime,fastestTime,longestTime]
        if infoList[0] > 0 {
        for i in 1..<timeLabelList.count{
            timeLabelList[i]?.text! += " \(String(format: "%.3f",infoList[i])) сек."
        }
            timeLabelList[0]?.text! += secondsToHoursMinutesSeconds(seconds: Int(infoList[0].rounded()))   // " \(String(format: "%.3f",infoList[0])) сек."

        fastestLevelImage.image = UIImage(named: LevelsInfo().premiaImagesList[Int(infoList[3])][Int(infoList[4])])
        longestImage.image = UIImage(named: LevelsInfo().premiaImagesList[Int(infoList[5])][Int(infoList[6])])
        
        levelsSolved.text! += " \(levelsSolvedAmount) / \(String(describing: LevelsInfo().levelsAmount()))"
        helpsUsed.text! += " \(Int(infoList[7]))"
        } else {
            titleLable.text = "К сожалению статистика пуста на данный момент."
            backView.isHidden = true
            stackView.isHidden = true
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
      return " \((seconds % 3600) / 60) мин. \((seconds % 3600) % 60) сек."
    }
    

    

}
