//
//  Persistence.swift
//  MuzTuzz
//
//  Created by Anton on 14.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation
import RealmSwift

class Persistence{
    static let shared = Persistence()
    private let userCoins = "Persistence.userCoins"
    private let userStars = "Persistence.userStars"
    private let userSave = "Persistence.userSave"
    private let musicOn = "Persistence.musicOn"
    private let zvukiOn = "Persistence.zvukiOn"
    private let firstStart = "Persistence.firstStart"
    private let coinsForTutorial = "Persistence.coinsForTutorial"
    private let freeCoinsInt = "Persistence.freeCoinsInt"

    
    
    var totalCoins: Int?{
        set { UserDefaults.standard.set(newValue, forKey: userCoins) }
        get { return UserDefaults.standard.integer(forKey: userCoins) }
    }
    
    var totalStars: Int?{
        set { UserDefaults.standard.set(newValue, forKey: userStars) }
        get { return UserDefaults.standard.integer(forKey: userStars) }
    }
    
    var totalSaved: Bool {
        set { UserDefaults.standard.set(newValue, forKey: userSave) }
        get { return UserDefaults.standard.bool(forKey: userSave) }
    }
    
    var music: Bool {
        set {UserDefaults.standard.set(newValue, forKey: musicOn)}
        get { return UserDefaults.standard.bool(forKey: musicOn) }
    }
    
    var zvuki: Bool {
        set {UserDefaults.standard.set(newValue, forKey: zvukiOn) }
        get { return UserDefaults.standard.bool(forKey: zvukiOn) }
    }
    
    var first: Bool {
        set {UserDefaults.standard.set(newValue, forKey: firstStart) }
        get { return UserDefaults.standard.bool(forKey: firstStart) }
    }
    
    var gotCoinsForTutorial: Bool{
        set {UserDefaults.standard.set(newValue, forKey: coinsForTutorial) }
        get { return UserDefaults.standard.bool(forKey: coinsForTutorial) }
    }
    
    var freeCoinsGotInt: Int{
        set { UserDefaults.standard.set(newValue, forKey: freeCoinsInt) }
        get { return UserDefaults.standard.integer(forKey: freeCoinsInt) }
    }
    
}

class RealmLevelInfo: Object{
    @objc dynamic var levelName = ""
    @objc dynamic var choosenLetter = -1
    @objc dynamic var levelSolved = false
    @objc dynamic var firstHelp = false
    @objc dynamic var secondHelp = false
    @objc dynamic var thirdHelp = false
    @objc dynamic var fourthHelp = false
    @objc dynamic var timeSpendToSolve = 0.0
    
}

class RealmLevelList: Object {
    @objc dynamic var premiaIsOpened = false
    var premiaLevels = List<RealmLevelInfo>()
}

class RealmPremiasList: Object{
    var premias = List<RealmLevelList>()
}

//SaveLoadRealm().savePremiaInfo

class SaveLoadRealm{
    private let realm = try! Realm()
    
    func saveRealmData(){
        let premiasList = RealmPremiasList()
        for p in 0..<LevelsInfo().AlbomsList.count{
            let premia = RealmLevelList()
            for l in 0..<LevelsInfo().AlbomsList[p].count{
                let level = RealmLevelInfo()
                level.levelName = LevelsInfo().premiaImagesList[p][l]
                level.levelSolved = LevelsInfo().levelSolvedList[p][l]
                level.firstHelp = LevelsInfo().helpsUsed[p][l][0]
                level.secondHelp = LevelsInfo().helpsUsed[p][l][1]
                level.thirdHelp = LevelsInfo().helpsUsed[p][l][2]
                level.fourthHelp = LevelsInfo().helpsUsed[p][l][3] ?? false

                level.timeSpendToSolve = 0.0
                premia.premiaLevels.append(level)
            }
            premia.premiaIsOpened = LevelsInfo().premiaIsOpendList[p]
            premiasList.premias.append(premia)
        }
        Persistence.shared.totalSaved = true
        try! realm.write{
            realm.add(premiasList)
        }
    }
    
    func deleteRealm(){
        
        //        if realm.objects(RealmPremiasList.self) != nil{
        //               let data = realm.objects(RealmPremiasList.self)
        //        try! realm.beginWrite()
        //            realm.delete(data)
        //          try! realm.commitWrite()
        //        }
        
        try! realm.write{
            realm.deleteAll()
        }
        
    }
    
    func savePremiaInfo(_ premia: Int){
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            try! realm.beginWrite()
            data[premia].premiaIsOpened = true
            try! realm.commitWrite()
        }
    }
    
    
    func saveLvlInfo(_ premia: Int,_ lvl: Int,_ levelName: String,_ levelSolved: Bool,_ helpsUsed: [Bool],_ choosenLetter: Int,timeSpend: Double = 0){
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            
            try! realm.beginWrite()
            data[premia].premiaLevels[lvl].levelName = levelName
            data[premia].premiaLevels[lvl].levelSolved = levelSolved
            data[premia].premiaLevels[lvl].firstHelp = helpsUsed[0]
            data[premia].premiaLevels[lvl].secondHelp = helpsUsed[1]
            data[premia].premiaLevels[lvl].thirdHelp = helpsUsed[2]
            data[premia].premiaLevels[lvl].fourthHelp = helpsUsed[3]

            data[premia].premiaLevels[lvl].choosenLetter = choosenLetter
            data[premia].premiaLevels[lvl].timeSpendToSolve += timeSpend
            try! realm.commitWrite()
        }
    }
    
    func getLevelHelpUse(_ premia: Int, lvl: Int) -> [Bool]{
        var helps: [Bool] = []
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            helps.append(data[premia].premiaLevels[lvl].firstHelp)
            helps.append(data[premia].premiaLevels[lvl].secondHelp)
            helps.append(data[premia].premiaLevels[lvl].thirdHelp)
            helps.append(data[premia].premiaLevels[lvl].fourthHelp)

        }
        return helps
    }
    
    func getLevelLetterHelp(_ premia: Int, lvl: Int) -> Int{
        var letterNum = 0
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            letterNum = data[premia].premiaLevels[lvl].choosenLetter
        }
        return letterNum
    }
    
    func getPremiaLevelsInfo(_ premia: Int) -> [Bool]{
        var premiaBool:[Bool] = []
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            for p in data[premia].premiaLevels{
                premiaBool.append(p.levelSolved)
            }
            
        }
        return premiaBool
    }
    
    func getPremiaInfo(_ premia: Int) -> Bool{
        var premiaIsOpened = false
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            premiaIsOpened = data[premia].premiaIsOpened
        }
        return premiaIsOpened
    }
    
    func getSumGameTime() -> [Double]{
        var sumTime = 0.0
        var minTime = 99999.0
        var minTP = 0
        var minTL = 0
        var maxTime = 0.0
        var maxTP = 0
        var maxTL = 0
        var levelsSolved = 0
        var helpsUsed = 0
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)

            for p in 1..<LevelsInfo().AlbomsList.count{
                for l in 0..<LevelsInfo().AlbomsList[p].count{
                    if !data.isEmpty, let timespend = data[p].premiaLevels[l].timeSpendToSolve as? Double  {
                        sumTime += timespend
                        if timespend < minTime && timespend != 0{
                            minTime = timespend
                            minTP = p
                            minTL = l
                        }
                        if timespend > maxTime {
                            maxTime = timespend
                            maxTP = p
                            maxTL = l
                        }
                    
                        if data[p].premiaLevels[l].firstHelp{
                            helpsUsed += 1
                        }
                        if data[p].premiaLevels[l].secondHelp{
                            helpsUsed += 1
                        }
                        if data[p].premiaLevels[l].thirdHelp{
                            helpsUsed += 1
                        }
                        if data[p].premiaLevels[l].fourthHelp{
                            helpsUsed += 1
                        }
                    } else {
                        break
                    }
                }}
            return [sumTime, minTime, maxTime, Double(minTP),Double(minTL),Double(maxTP),Double(maxTL), Double(helpsUsed)]

            
        }
        else {
            return [0, 0, 0, 0, 0, 0, 0, 0]
        }
    }
    
    func getSolvedLevelAmount() -> Int{
        var amount = 0
        if realm.objects(RealmLevelList.self) != nil{
            let data = realm.objects(RealmLevelList.self)
            for p in 1..<LevelsInfo().AlbomsList.count{
                for l in 0..<LevelsInfo().AlbomsList[p].count{
                    if !data.isEmpty && data[p].premiaLevels[l].levelSolved{
                       amount += 1
                    }
                }
            }
        }
        
        return amount
    }
}

//SaveLoadRealm().getLevelInfo
