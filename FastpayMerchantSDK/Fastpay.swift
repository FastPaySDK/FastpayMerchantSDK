//
//  Fastpay.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import Foundation
import UIKit

@objc public protocol FastPayDelegate: class {
    func fastpayTransactionSucceeded(with transaction: FPTransaction)
    func fastpayTransactionFailed(with orderId: String)
}

internal protocol EPGWDelegate {
    func notifyMerchantWithTransactionReslt()
    func getMerchantCred() -> (storeId: String, storePassword: String)
}

@objc public class Fastpay: NSObject, EPGWDelegate{
    
    @objc weak public var delegate: FastPayDelegate?
    
    var storeId: String
    var storePassword: String
    
    var navigationController: UINavigationController!
    
    @objc public init(storeId: String, storePassword: String, orderId: String, amount: Int, currency: FPCurrency, language: FPLanguage){
        
        FPLanguageHandler.shared.currentLanguage = language
        
        self.storeId = storeId
        self.storePassword = storePassword
        FPDataHandler.shared.orderId = orderId
        FPDataHandler.shared.amount = amount
        FPDataHandler.shared.selectedCurrency = currency
    }
    
    @objc public func start(in viewController: UIViewController, for environment: FPEnvironment){
        
        FPWebServiceHandler.shared.currentEnvironment = environment
        
        let vc = SplashViewController()
        navigationController = UINavigationController.init(rootViewController: vc)
        navigationController.navigationBar.isHidden = true
        
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        
        viewController.present(navigationController, animated: true, completion: {
            
            FPWebServiceHandler.shared.initiate(storeId: self.storeId, storePassword: self.storePassword, amount: FPDataHandler.shared.amount, orderId: FPDataHandler.shared.orderId, currency: FPDataHandler.shared.selectedCurrency, shouldShowLoader: false) { (response) in
                
                
                if response.code == 200{
                    
                    FPDataHandler.shared.initiationData = response.initiationData
                    
                    DispatchQueue.main.async {
                        UIView.transition(with: vc.view, duration: 0.5, options: .transitionCrossDissolve) {
                            
                            self.navigationController.viewControllers = [FPAuthViewController()]
                            
                        } completion: { ( _) in
                            FPDataHandler.shared.epgwDelegate = self
                        }
                    }
                    
                }else{
                    vc.showDialog(title: nil, message: (response.errors?.joined(separator: "\n") ?? K.Messages.DefaultErrorMessage)) {
                        self.navigationController.dismiss(animated: true) {}
                    }
                }
                
            } onFailure: { ( _) in
                vc.showDialog(title: nil, message: K.Messages.DefaultErrorMessage) {
                    self.navigationController.dismiss(animated: true) {}
                }
            } onConnectionFailure: {
                vc.showDialog(title: nil, message: no_internet_message_text[FPLanguageHandler.shared.currentLanguage.identifier] ?? K.Messages.DefaultErrorMessage) {
                    self.navigationController.dismiss(animated: true) {}
                }
            }
            
        })
    }
    
    
    func notifyMerchantWithTransactionReslt() {
        
        FPWebServiceHandler.shared.validate(orderId: FPDataHandler.shared.orderId, storeId: storeId, storePassword: storePassword, shouldShowLoader: false) { (response) in

            if response.code == 200{
                
                self.navigationController.presentingViewController?.dismiss(animated: true, completion: {
                    self.delegate?.fastpayTransactionSucceeded(with: .init(transactionId: response.validateData?.gwTransactionId, orderId: response.validateData?.merchantOrderId, amount: response.validateData?.receivedAmount, currency: .init(code: response.validateData?.currency ?? ""), customerMobileNo: response.validateData?.customerMobileNumber, customerName: response.validateData?.customerName, status: response.validateData?.status, transactionTime: response.validateData?.at))
                })
            }else{
                self.navigationController.presentingViewController?.dismiss(animated: true, completion: {
                    self.delegate?.fastpayTransactionFailed(with: FPDataHandler.shared.orderId)
                })
            }
            
        } onFailure: { ( _) in
            self.navigationController.presentingViewController?.dismiss(animated: true, completion: {
                self.delegate?.fastpayTransactionFailed(with: FPDataHandler.shared.orderId)
            })
        }
    }
    
    func getMerchantCred() -> (storeId: String, storePassword: String){
        return (storeId, storePassword)
    }
    
}
