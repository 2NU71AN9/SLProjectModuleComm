//
//  AppPurchaseManager.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit
import SwiftyStoreKit
import StoreKit

public class AppPurchaseManager: NSObject {
    public static let shared = AppPurchaseManager()
    private override init() {
        super.init()
    }
}

extension AppPurchaseManager {
    
    /**
     在启动时添加应用程序的观察者可确保在应用程序的所有启动过程中都会持续，从而允许您的应用程序接收所有支付队列通知。如果此时有任何待处理的事务，将触发block，以便可以更新应用程序状态和UI。如果没有待处理的事务，则不会调用。
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AppPurchaseManager.shared.completeTransactions()
         return true
     }
     */
    /// 完成购买
    public func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                   if purchase.needsFinishTransaction {
                       SwiftyStoreKit.finishTransaction(purchase.transaction)
                   }
                   print("已购买: \(purchase)")
                }
            }
        }
    }
    
    /// 获取产品信息
    public func getProductList(ids: [String], complete: @escaping (SKProduct?, Error?) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo(Set(ids)) { result in
            if let product = result.retrievedProducts.first {
                print("产品: \(product.localizedDescription), 价格: \(product.localizedPrice ?? "未知")")
                complete(product, nil)
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("无效产品id: \(invalidProductId)")
                complete(nil, result.error)
            } else {
                print("报错: \(String(describing: result.error))")
                complete(nil, result.error)
            }
        }
    }
    
    /// 进行购买, 只进行了本地验证, 最好进行苹果服务器验证
    public func purchaseProduct(_ productId: String, complete: @escaping (PurchaseDetails?, SKError?) -> Void) {
        SwiftyStoreKit.purchaseProduct(productId) { result in
            switch result {
            case .success(let purchase):
                print("购买成功: \(purchase.productId)")
                complete(purchase, nil)
            case .error(let error):
                switch error.code {
                case .unknown:
                    // 未知错误
                    print("Unknown error. Please contact support")
                case .clientInvalid:
                    // 不允许付款
                    print("Not allowed to make the payment")
                case .paymentCancelled:
                    // 取消支付
                    print("Not allowed to make the payment")
                case .paymentInvalid:
                    // 购买标识符无效
                    print("The purchase identifier was invalid")
                case .paymentNotAllowed:
                    // 设备不允许付款
                    print("The device is not allowed to make the payment")
                case .storeProductNotAvailable:
                    // 该产品在当前店面中不可用
                    print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied:
                    // 不允许访问云服务信息
                    print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed:
                    // 无法连接到商店
                    print("Could not connect to the network")
                case .cloudServiceRevoked:
                    // 用户已吊销使用此云服务的权限
                    print("User has revoked permission to use this cloud service")
                default:
                    print((error as NSError).localizedDescription)
                }
                complete(nil, error)
            }
        }
    }
}
