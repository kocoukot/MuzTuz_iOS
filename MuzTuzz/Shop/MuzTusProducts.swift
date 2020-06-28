//
//  File.swift
//  MuzTuzz
//
//  Created by Anton on 25.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import Foundation


public struct MuzTusProducts {

    public static let SwiftShopping = "com.kocoukot.MuzTuz.OneDollarCoins"
    

    //  private static let productIdentifiers: Set<ProductIdentifier> = ["com.kocoukot.MuzTuz.OneDollarCoins","com.kocoukot.MuzTuz.TwoDollarCoins", "com.kocoukot.MuzTuz.FourDollarCoins", "com.kocoukot.MuzTuz.EightDollarCoin"]
    private static let productIdentifiers: Set<ProductIdentifier> = ["com.kocoukot.MuzTuz.TwoDollarCoins", "com.kocoukot.MuzTuz.FourDollarCoins", "com.kocoukot.MuzTuz.EightDollarCoin","com.kocoukot.MuzTuz.OneDollarCoins"]

    public static let store = IAPHelper(productIds: MuzTusProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
