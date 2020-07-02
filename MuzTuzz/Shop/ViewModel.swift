
import Foundation
import StoreKit

protocol ViewModelDelegate {
    func showIAPRelatedError(_ error: Error)
}


class ViewModel {
    
    // MARK: - Properties
    
    var delegate: ViewModelDelegate?
    
    private let model = Model()
    
    
    
    
    // MARK: - Init
    
    init() {
        
    }
    
    
    // MARK: - Fileprivate Methods
    fileprivate func updateGameDataWithPurchasedProduct(_ product: SKProduct) {
        if product.productIdentifier.contains("com.kocoukot.MuzTuz.OneDollarCoins"){
            Persistence.shared.totalCoins! += 2999
        } else if product.productIdentifier.contains("com.kocoukot.MuzTuz.TwoDollarCoins"){
            Persistence.shared.totalCoins! += 5999
        } else if product.productIdentifier.contains("com.kocoukot.MuzTuz.FourDollarCoins"){
            Persistence.shared.totalCoins! += 12999
        } else  {
            Persistence.shared.totalCoins! += 999999
        }
    }
    
    // MARK: - Internal Methods
    
    func getProductForItem(at index: Int) -> SKProduct? {
        // Search for a specific keyword depending on the index value.
        let keyword: String
        switch index {
        case 0: keyword = "com.kocoukot.MuzTuz.OneDollarCoins"
        case 1: keyword = "com.kocoukot.MuzTuz.TwoDollarCoins"
        case 2: keyword = "com.kocoukot.MuzTuz.FourDollarCoins"
        case 3: keyword = "com.kocoukot.MuzTuz.EightDollarCoin"
        default: keyword = ""
        }
        
        // Check if there is a product fetched from App Store containing
        // the keyword matching to the selected item's index.
        guard let product = model.getProduct(containing: keyword) else { return nil }
        return product
    }
    
    
    
    
    // MARK: - Methods To Implement
    
    func viewDidSetup() {
        
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let products):
                    self.model.products = products
                    print ("done ")
                case .failure(let error):
                    self.delegate?.showIAPRelatedError(error)
                    print ("error")
                }
            }
        }
    }
    
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(_):
                        print ("good")
                        SoundsPlay.shared.playSound("boughtCoins", "wav")
                        
                        self.updateGameDataWithPurchasedProduct(product)
                    case .failure(let error):
                        print ("bad")
                        self.delegate?.showIAPRelatedError(error)
                    }
                }
            }
        }
        return true
    }
    
}
