//
//  FPTransactionSuccessViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 14/2/21.
//

import UIKit

class FPTransactionSuccessViewController: BaseViewController {
    
    private lazy var headerView: UIView = {
        let uiview = HeaderView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.markAmountPaid()
        
        return uiview
    }()
    
    private lazy var paymentSuccessfulTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .hexStringToUIColor(hex: "#636696")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = K.UI.appFont(ofSize: 20, style: .medium)
        label.text = payment_successful_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var trxSuccessIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.backgroundColor = .hexStringToUIColor(hex: "#1DBF73")
        imageView.layer.cornerRadius = 46
        imageView.clipsToBounds = true
        imageView.setImageFromBundle(FPTransactionSuccessViewController.self, imageName: "largeWhiteTick")
        
        return imageView
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .hexStringToUIColor(hex: "#636696")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = K.UI.appFont(ofSize: 16, style: .medium)
        label.text = payment_successful_message_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var mainContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.clipsToBounds = true
        
        uiview.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: uiview.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor),
        ])
        
        uiview.addSubview(paymentSuccessfulTitleLabel)
        NSLayoutConstraint.activate([
            paymentSuccessfulTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            paymentSuccessfulTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 48),
            paymentSuccessfulTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            paymentSuccessfulTitleLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
        ])
        
        uiview.addSubview(trxSuccessIconImageView)
        NSLayoutConstraint.activate([
            trxSuccessIconImageView.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            trxSuccessIconImageView.topAnchor.constraint(equalTo: paymentSuccessfulTitleLabel.bottomAnchor, constant: 40),
            trxSuccessIconImageView.widthAnchor.constraint(equalToConstant: 92),
            trxSuccessIconImageView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        uiview.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            messageLabel.topAnchor.constraint(equalTo: trxSuccessIconImageView.bottomAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            messageLabel.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -20),
            messageLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
        ])
        
        return uiview
    }()
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(mainContainerView)
        NSLayoutConstraint.activate([
            mainContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            mainContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(mainScrollView)
        NSLayoutConstraint.activate([
            mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainScrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            DispatchQueue.main.async {
                self.dataHandler.epgwDelegate?.notifyMerchantWithTransactionReslt()
            }
        }
    }
    
}
