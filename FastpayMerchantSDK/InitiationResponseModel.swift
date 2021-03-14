//
//  InitiationResponseModel.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 23/2/21.
//

import Foundation

// MARK: - InitiationResponseModel
class InitiationResponseModel: Codable {
    let code: Int?
    let message: String?
    let errors: [String]?
    let initiationData: InitiationData?

    enum CodingKeys: String, CodingKey {
        case code, message, errors
        case initiationData = "data"
    }

    init(code: Int?, message: String?, errors: [String]?, initiationData: InitiationData?) {
        self.code = code
        self.message = message
        self.errors = errors
        self.initiationData = initiationData
    }
}

// MARK: - InitiationData
class InitiationData: Codable {
    let storeName: String?
    let storeLogo: String?
    let orderId: String?
    let billAmount: Int?
    let currency, token, qrToken: String?

    init(storeName: String?, storeLogo: String?, orderId: String?, billAmount: Int?, currency: String?, token: String?, qrToken: String?) {
        self.storeName = storeName
        self.storeLogo = storeLogo
        self.orderId = orderId
        self.billAmount = billAmount
        self.currency = currency
        self.token = token
        self.qrToken = qrToken
    }
}
