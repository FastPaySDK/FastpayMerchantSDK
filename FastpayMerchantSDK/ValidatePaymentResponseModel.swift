//
//  ValidatePaymentResponseModel.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 23/2/21.
//

import Foundation

// MARK: - ValidatePaymentResponseModel
class ValidatePaymentResponseModel: Codable {
    let code: Int?
    let message: String?
    let errors: [String]?
    let validateData: ValidateData?

    enum CodingKeys: String, CodingKey {
        case code, message, errors
        case validateData = "data"
    }

    init(code: Int?, message: String?, errors: [String]?, validateData: ValidateData?) {
        self.code = code
        self.message = message
        self.errors = errors
        self.validateData = validateData
    }
}

// MARK: - ValidateData
class ValidateData: Codable {
    let gwTransactionId, merchantOrderId: String?
    let receivedAmount: Int?
    let currency, status, customerName, customerMobileNumber: String?
    let at: String?

    enum CodingKeys: String, CodingKey {
        case gwTransactionId = "gw_transaction_id"
        case merchantOrderId = "merchant_order_id"
        case receivedAmount = "received_amount"
        case currency, status
        case customerName = "customer_name"
        case customerMobileNumber = "customer_mobile_number"
        case at
    }

    init(gwTransactionId: String?, merchantOrderId: String?, receivedAmount: Int?, currency: String?, status: String?, customerName: String?, customerMobileNumber: String?, at: String?) {
        self.gwTransactionId = gwTransactionId
        self.merchantOrderId = merchantOrderId
        self.receivedAmount = receivedAmount
        self.currency = currency
        self.status = status
        self.customerName = customerName
        self.customerMobileNumber = customerMobileNumber
        self.at = at
    }
}
