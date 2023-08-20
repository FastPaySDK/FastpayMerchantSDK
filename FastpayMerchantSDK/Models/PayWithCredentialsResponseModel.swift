//
//  PayWithCredentialsResponseModel.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 23/2/21.
//

import Foundation

class PayWithCredentialsResponseModel: Codable {
    let code: Int?
    let message: String?
    let errors: [String]?
    let paymentData: PaymentData?

    enum CodingKeys: String, CodingKey {
        case code, message, errors
        case paymentData = "data"
    }

    init(code: Int?, message: String?, errors: [String]?, paymentData: PaymentData?) {
        self.code = code
        self.message = message
        self.errors = errors
        self.paymentData = paymentData
    }
}

// MARK: - PaymentData
class PaymentData: Codable {
    let summary: Summary?

    init(summary: Summary?) {
        self.summary = summary
    }
}

// MARK: - Summary
class Summary: Codable {
    let recipient: Recipient?
    let invoiceId: String?

    enum CodingKeys: String, CodingKey {
        case recipient
        case invoiceId = "invoice_id"
    }

    init(recipient: Recipient?, invoiceId: String?) {
        self.recipient = recipient
        self.invoiceId = invoiceId
    }
}

// MARK: - Recipient
class Recipient: Codable {
    let name, mobileNumber: String?
    let avatar: String?

    enum CodingKeys: String, CodingKey {
        case name
        case mobileNumber = "mobile_number"
        case avatar
    }

    init(name: String?, mobileNumber: String?, avatar: String?) {
        self.name = name
        self.mobileNumber = mobileNumber
        self.avatar = avatar
    }
}
