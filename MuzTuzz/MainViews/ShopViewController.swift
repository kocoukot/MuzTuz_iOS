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
    
    
    let ogonkiList = ["bm_ogonki_1_animaciya", "bm_ogonki_2_animaciya", "bm_ogonki_3_animaciya", "bm_ogonki_4_animaciya"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for b in [firstBuyButton,secondBuyButton,thirdBuyButton,fourthBuyButton,freeBuyButton ] {
            b!.shadowSet()
        }
       viewModel.delegate = self

        
        var i = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (t) in
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
        viewModel.viewDidSetup()
    }
    
    func showSingleAlert(withMessage message: String) {
         let alertController = UIAlertController(title: "FakeGame", message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.shopClosed()
    }

    
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
    
    private func getPriceFormatted(_ product: SKProduct) -> String?{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
    
    
    @IBAction func freeCoins(_ sender: Any) {
        FreeCoinsRewardClass.freeAdd.freeCoinsAdShow(self)
    }

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
