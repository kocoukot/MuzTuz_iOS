//
//  TextEnums.swift
//  MuzTuzz
//
//  Created by Anton on 03.06.2021.
//  Copyright © 2021 Anton. All rights reserved.
//

import Foundation

enum HelpTexts: String, CaseIterable{
    case noMoney = "К сожалению для подсказки недостаточно монет!"
    case lettersAmountHelp = "Количество букв"
    case oneLetterHelp = "Показать выбранную букву"
    case songNameHelp = "Показать название песни и альбома"
    case showAnswerHelp = "Показать ответ"
    
}

enum HelpPrices: Int, CaseIterable{
    case zero = 0
    case lettersAmountPrice = -150
    case oneLetterPrice = -250
    case songNamePrice = -350
    case showAnswerPrice = -500
    
}

enum TextFields: String{
    case firstLaunch = "Вся информация, представленная в приложении, за исключением информации, имеющей ссылку на конкретный источник, является художественным вымыслом и не имеет отношения к реальным лицам и событиям. Автор не несет ответственности за случайным совпадения с реальными лицами и событиями."
    case adviceForFirstHelp = "Похоже это твой первый визит в игру МузТус! Рекомендуем сперва пройти небольшое обучение, чтобы разобраться что к чему. К тому же, если пройдешь обучение, получишь небольшой приятный стартовый бонус."
    
}


