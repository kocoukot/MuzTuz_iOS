//
//  StatisticController.swift
//  MuzTuzz
//
//  Created by Anton on 03.06.2021.
//  Copyright © 2021 Anton. All rights reserved.
//

import Foundation

class StatisticController{
    
    private var statisticModel: StatisticModel = {
        let infoList = SaveLoadRealm.shared.getSumGameTime()
        
        let model = StatisticModel(sumTime: infoList[0], minTime: infoList[1], maxTime: infoList[2], minTimeImage: LevelsInfo.premiaImagesList[Int(infoList[3])][Int(infoList[4])], maxTimeImage: LevelsInfo.premiaImagesList[Int(infoList[5])][Int(infoList[6])], helpsUsed: Int(infoList[7]))
        return model
    }()
    
    
    func getSumTime() -> String{
        return Int(statisticModel.sumTime.rounded()).secondsToHoursMinutesSeconds()
    }
    func getTimeForStatisticLabels()->[String]{
        return [String(format: "%.3f",statisticModel.minTime), String(format: "%.3f",statisticModel.maxTime)]
    }
    
    func getLevelsSolvedAmount() -> Int {
        return SaveLoadRealm.shared.getSolvedLevelAmount()
    }
    
    func getHelpsUsed()-> Int{
        return statisticModel.helpsUsed
    }
    
    func getImages() -> [String]{
        return [statisticModel.minTimeImage, statisticModel.maxTimeImage]
    }
    
    func hasStatistic() -> Bool{
        return statisticModel.sumTime > 0
    }
    
    
    
}
