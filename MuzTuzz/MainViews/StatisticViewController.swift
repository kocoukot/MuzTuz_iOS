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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet var statisticImage: [UIImageView]!
    @IBOutlet weak var stackView: UIStackView!
    
    var statisticController = StatisticController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 15
        setLabelsInfo()
    }
    
    func setLabelsInfo(){
        if statisticController.hasStatistic(){
            setTextLabels()
            setImages()
        } else {
            titleLable.text = "К сожалению статистика пуста на данный момент."
            backView.isHidden = true
            stackView.isHidden = true
        }
    }
    
    private func setTextLabels(){
        let statisticTime = statisticController.getTimeForStatisticLabels()
        sumGameTime.text! += statisticController.getSumTime()
        fastestTime.text! += statisticTime[0]
        longestTime.text! += statisticTime[1]
        levelsSolved.text! += " \(statisticController.getLevelsSolvedAmount()) / \(LevelsInfo.levelsAmount())"
        helpsUsed.text! += " \(statisticController.getHelpsUsed())"
    }
    
    private func setImages(){
        let imageList = statisticController.getImages()
        for i in 0..<statisticImage.count{
            statisticImage[i].image = UIImage(named:imageList[i])
        }
    }
}

