//
//  StoreManager.swift
//  QuickWeather
//
//  Created by 이영빈 on 2022/02/21.
//

import StoreKit

class StoreManager: NSObject, ObservableObject, SKProductsRequestDelegate {
    @Published var myProducts = [SKProduct]()
    @Published var transactionState: SKPaymentTransactionState?
    
    @Published var showSuccessAlert = false
    @Published var showFailureAlert = false
    
    private var request: SKProductsRequest!
    
    func getPurchaseResult() {
        
    }

    override init() {
        super.init()
        let productID = ["com.enebin.QuickWeather.reset"]

        self.getProducts(productIDs: productID)
        SKPaymentQueue.default().add(self)
    }
    
    func priceStringForProduct(item: SKProduct) -> String? {
        let numberFormatter = NumberFormatter()
        let price = item.price
        let locale = item.priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: price)
    }
    
    private func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Request did fail: \(error)")
    }
    
    //HANDLE TRANSACTIONS
    
    func purchaseProduct(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
    }
}

extension StoreManager: SKPaymentTransactionObserver {
    /// 컴플리션은 없고 여기서 결과를 핸들링해야 하는 듯 하다.
    // TODO: 결과 재생 안됨 + 플레이도 안됨
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                print("PURCHASing!")
                transactionState = .purchasing
            case .purchased:
                print("PURCHASED!")
                queue.finishTransaction(transaction)
                transactionState = .purchased
                showSuccessAlert = true
            case .failed, .deferred:
                print("Payment Queue Error: \(String(describing: transaction.error))")
                queue.finishTransaction(transaction)
                transactionState = .failed
                showFailureAlert = true
            default:
                queue.finishTransaction(transaction)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Did receive response")
        
        if !response.products.isEmpty {
            for fetchedProduct in response.products {
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
        }
        
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid identifiers found: \(invalidIdentifier)")
        }
    }
    
}
