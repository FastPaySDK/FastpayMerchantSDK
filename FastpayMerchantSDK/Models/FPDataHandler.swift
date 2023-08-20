//
//  FPDataHandler.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 15/2/21.
//

import Foundation

class FPDataHandler{
    
    static let shared = FPDataHandler()
    private init(){}
    
    //var storeId: String!
    //var storePassword: String!
    
    var orderId: String!
    var amount: Int!
    var storeId: String!
    var storePass: String!
    var selectedCurrency: FPCurrency!
    
    var initiationData: InitiationData?
    
    //var onTransactionCompletion: (() -> ())?
    
    var epgwDelegate: EPGWDelegate?
}
