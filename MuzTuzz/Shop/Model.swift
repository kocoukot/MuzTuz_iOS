
import Foundation
import StoreKit

class Model {
    
    var products = [SKProduct]()
    
    
    func getProduct(containing keyword: String) -> SKProduct? {
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
}
