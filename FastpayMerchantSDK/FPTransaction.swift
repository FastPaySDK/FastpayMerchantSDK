//
//  FPTransaction.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 24/2/21.
//

import Foundation

@objcMembers public class FPTransaction: NSObject {
    
    public internal(set) var transactionId: String?
    public internal(set) var orderId: String?
    public internal(set) var amount: Int?
    public internal(set) var currency: FPCurrency?
    public internal(set) var customerMobileNo: String?
    public internal(set) var customerName: String?
    public internal(set) var status: String?
    public internal(set) var transactionTime: String?
    
    internal override init(){
        
        super.init()
    }
    
    internal init(transactionId: String?, orderId: String?, amount: Int?, currency: FPCurrency?, customerMobileNo: String?, customerName: String?, status: String?, transactionTime: String?) {
        
        super.init()
        
        self.transactionId = transactionId
        self.orderId = orderId
        self.amount = amount
        self.currency = currency
        self.customerMobileNo = customerMobileNo
        self.customerName = customerName
        self.status = status
        self.transactionTime = transactionTime
        
    }
    
}
