//
//  ShopViewController.swift
//  MuzTuzz
//
//  Created by Anton on 25.06.2020.
//  Copyright © 2020 Anton. All rights reserved.
//

import UIKit
import StoreKit

protocol ShopDelegate {
    func shopClosed()
}

class ShopViewController: UIViewController  {
    var delegate: ShopDelegate?
    
    var viewModel = ViewModel()
    
    
    
    @IBOutlet weak var ogonkiImage: UIImageView!
    @IBOutlet weak var firstBuyButton: UIButton!
    @IBOutlet weak var secondBuyButton: UIButton!
    @IBOutlet weak var thirdBuyButton: UIButton!
    @IBOutlet weak var fourthBuyButton: UIButton!
    @IBOutlet weak var freeBuyButton: UIButton!
    
//    var products: [SKProduct] = []
    
    let ogonkiList = ["bm_ogonki_1_animaciya", "bm_ogonki_2_animaciya", "bm_ogonki_3_animaciya", "bm_ogonki_4_animaciya"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonsList = [firstBuyButton,secondBuyButton,thirdBuyButton,fourthBuyButton,freeBuyButton ]
        for b in buttonsList {
            CommonFuncs().shadowSet(b!)
        }
       viewModel.delegate = self

        
        var i = 0
        _  = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (t) in
            self.ogonkiImage.image = UIImage(named: self.ogonkiList[i])
            
            if i + 1 > self.ogonkiList.count-1 {
                i = 0
            } else {
                i += 1
            }
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Notify the ViewModel object that the View part is ready.
        viewModel.viewDidSetup()
    }
    
    func showSingleAlert(withMessage message: String) {
         let alertController = UIAlertController(title: "FakeGame", message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
     }

    
//    func getProductForItem(at index: Int) -> SKProduct? {
//        // Search for a specific keyword depending on the index value.
//        let keyword: String
//
//        switch index {
//        case 0: keyword = "com.kocoukot.MuzTuz.OneDollarCoins"
//        case 1: keyword = "com.kocoukot.MuzTuz.TwoDollarCoins"
//        case 2: keyword = "com.kocoukot.MuzTuz.FourDollarCoins"
//        case 3: keyword = "com.kocoukot.MuzTuz.EightDollarCoin"
//        default: keyword = ""
//        }
//        guard let product = getProduct(containing: keyword) else { return nil }
//        return product
//    }
    
//    func getProduct(containing keyword: String) -> SKProduct? {
//        return ProductsLib.productClass.products.filter { $0.productIdentifier.contains(keyword) }.first
//    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.shopClosed()
    }
//
//    func showSingleAlert(withMessage message: String) {
//        let alertController = UIAlertController(title: "МузТус", message: message, preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    @IBAction func firstBuyCoin(_ sender: Any) {
        guard let product = viewModel.getProductForItem(at: 0) else {
            showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
            return
        }
        
        showAlert(for: product)
//        showAlert(index: 0)
    }
    
    @IBAction func secondBuyCoin(_ sender: Any) {
        guard let product = viewModel.getProductForItem(at: 1) else {
            showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
            return
        }
        
        showAlert(for: product)
//        showAlert(index: 1)
    }
    
    @IBAction func thirdBuyCoin(_ sender: Any) {
        guard let product = viewModel.getProductForItem(at: 2) else {
            showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
            return
        }
        
        showAlert(for: product)
//        showAlert(index: 2)
    }
    
    @IBAction func fourthBuyCoin(_ sender: Any) {
        guard let product = viewModel.getProductForItem(at: 3) else {
            showSingleAlert(withMessage: "Renewing this item is not possible at the moment.")
            return
        }
        
        showAlert(for: product)
//        showAlert(index: 3)
    }
    
    func showAlert(for product: SKProduct) {
         guard let price = IAPManager.shared.getPriceFormatted(for: product) else { return }
         print ( product.localizedTitle)
         print (product.localizedDescription)
         let alertController = UIAlertController(title: product.localizedTitle,
                                                 message: product.localizedDescription,
                                                 preferredStyle: .alert)
         
         alertController.addAction(UIAlertAction(title: "Buy now for \(price)", style: .default, handler: { (_) in
             
             if !self.viewModel.purchase(product: product) {
                 self.showSingleAlert(withMessage: "In-App Purchases are not allowed in this device.")
             }
             
         }))
         
         alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
         self.present(alertController, animated: true, completion: nil)
     }
    
    
    
    
    
//    func showAlert(index: Int) {
//        guard let product = getProductForItem(at: index) else {
//            showSingleAlert(withMessage: "К сожалению вы не можете приобрести данный товар в текущий момент.")
//            return
//        }
//        guard let price = getPriceFormatted(product) else { return }
//        let alertController = UIAlertController(title: product.localizedTitle,
//                                                message: product.localizedDescription,
//                                                preferredStyle: .alert)
//
//        alertController.addAction(UIAlertAction(title: "Купить за \(price)", style: .default, handler: { (_) in
//
//            if !IAPHelper.canMakePayments(){
//                self.showSingleAlert(withMessage: "К сожалению вы не можете приобрести данный товар на данном устройстве.")
//            } else {
//                MuzTusProducts.store.buyProduct(product)
//
//            }
//        }))
//
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    private func getPriceFormatted(_ product: SKProduct) -> String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    
    @IBAction func freeCoins(_ sender: Any) {
        FreeCoinsRewardClass.freeAdd.freeCoinsAdShow(self)
    }
    
//
//    func updateGameDataWithPurchasedProduct(_ product: SKProduct) {
//        if product.productIdentifier.contains("com.kocoukot.MuzTuz.OneDollarCoins"){
//            Persistence.shared.totalCoins! += 2999
//        } else if product.productIdentifier.contains("com.kocoukot.MuzTuz.TwoDollarCoins"){
//            Persistence.shared.totalCoins! += 5999
//        } else if product.productIdentifier.contains("com.kocoukot.MuzTuz.FourDollarCoins"){
//            Persistence.shared.totalCoins! += 12999
//        } else  {
//            Persistence.shared.totalCoins! += 999999
//        }
//    }
    
    
    @IBAction func removeShadow(_ sender: Any) {
          (sender as AnyObject).layer.shadowOffset = CGSize(width: 0, height: 0)
      }
      
      
      @IBAction func returnShadow(_ sender: Any) {
          (sender as AnyObject).layer.shadowOffset = CGSize(width: 2.5, height: 2.5)
      }
}


extension ShopViewController: ViewModelDelegate{
    func showIAPRelatedError(_ error: Error) {
        let message = error.localizedDescription
        showSingleAlert(withMessage: message)
    }
}
