//
//  FPQRViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 14/2/21.
//

import UIKit

class FPQRViewController: BaseViewController {
    
    private var trxResultCheckTimer: Timer?
    
    private lazy var headerView: UIView = {
        let uiview = HeaderView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        
        return uiview
    }()
    
    private lazy var payViaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 12, style: .medium)
        label.textAlignment = .natural
        label.text = "Pay via"
        
        return label
    }()
    
    private lazy var fpLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setImageFromBundle(FPAuthViewController.self, imageName: "logoFP-en")
        
        return imageView
    }()
    
    private lazy var fpLogoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        stackView.addArrangedSubview(payViaLabel)
        stackView.addArrangedSubview(fpLogoImageView)
        
        return stackView
    }()
    
    private lazy var horizontalBarBelowFPLogoStackView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .hexStringToUIColor(hex: "#D8E5EB")
        
        return uiview
    }()
    
    private lazy var qrTipLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 12, style: .medium)
        label.text = "Use another mobile or let your friends & family help"
        
        return label
    }()
    
    private lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var qrContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .clear
        uiview.layer.cornerRadius = 20
        uiview.layer.borderWidth = 1
        uiview.layer.borderColor = UIColor.hexStringToUIColor(hex: "#E9EEF2").cgColor
        uiview.clipsToBounds = true
        
        uiview.addSubview(qrImageView)
        NSLayoutConstraint.activate([
            qrImageView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 18),
            qrImageView.topAnchor.constraint(equalTo: uiview.topAnchor, constant: 18),
            qrImageView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -18),
            qrImageView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -18)
        ])
        
        return uiview
    }()
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 13, style: .regular)
        label.textAlignment = .natural
        label.text = "Or"
        
        return label
    }()
    
    private lazy var useCredentialButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.hexStringToUIColor(hex: "#2892D7"), for: .normal)
        button.titleLabel?.font = K.UI.appFont(ofSize: 14, style: .medium)
        button.setTitle("Use Login Credential", for: .normal)
        
        button.addTarget(self, action: #selector(useLoginCredTapped(_:)), for: .touchUpInside)
        
        return button
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
        
        uiview.addSubview(fpLogoStackView)
        NSLayoutConstraint.activate([
            fpLogoStackView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            fpLogoStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            fpLogoStackView.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28)
        ])
        
        uiview.addSubview(horizontalBarBelowFPLogoStackView)
        NSLayoutConstraint.activate([
            horizontalBarBelowFPLogoStackView.leadingAnchor.constraint(equalTo: fpLogoStackView.leadingAnchor),
            horizontalBarBelowFPLogoStackView.topAnchor.constraint(equalTo: fpLogoStackView.bottomAnchor, constant: 6),
            horizontalBarBelowFPLogoStackView.trailingAnchor.constraint(equalTo: fpLogoStackView.trailingAnchor),
            horizontalBarBelowFPLogoStackView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        uiview.addSubview(qrTipLabel)
        NSLayoutConstraint.activate([
            qrTipLabel.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 40),
            qrTipLabel.topAnchor.constraint(equalTo: horizontalBarBelowFPLogoStackView.bottomAnchor, constant: 20),
            qrTipLabel.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -40),
            qrTipLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
        ])
        
        uiview.addSubview(qrContainerView)
        NSLayoutConstraint.activate([
            qrContainerView.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            qrContainerView.topAnchor.constraint(equalTo: qrTipLabel.bottomAnchor, constant: 20),
            qrContainerView.widthAnchor.constraint(equalTo: uiview.widthAnchor, multiplier: 0.6933, constant: 0),
            qrContainerView.heightAnchor.constraint(equalTo: qrContainerView.widthAnchor, multiplier: 1)
        ])
        
        uiview.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: qrContainerView.bottomAnchor, constant: 30)
        ])
        
        uiview.addSubview(useCredentialButton)
        NSLayoutConstraint.activate([
            useCredentialButton.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            useCredentialButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            useCredentialButton.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            useCredentialButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -20),
            useCredentialButton.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
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
        
        qrImageView.image = generateQRCode(from: dataHandler.initiationData?.qrToken ?? "")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trxResultCheckTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkTransaction(_:)), userInfo: nil, repeats: true)
    }
    
    
    @objc private func checkTransaction(_ sender: Timer){
        
        let storeId = dataHandler.epgwDelegate?.getMerchantCred().storeId
        let storePassword = dataHandler.epgwDelegate?.getMerchantCred().storePassword
        
        webserviceHandler.validate(orderId: dataHandler.orderId, storeId: storeId ?? "", storePassword: storePassword ?? "", shouldShowLoader: false) { (response) in
                
            if response.code == 200{
                
                if response.validateData?.status?.lowercased() == "success"{
                    
                    self.trxResultCheckTimer?.invalidate()
                    self.trxResultCheckTimer = nil
                    
                    let vc = FPTransactionSuccessViewController()
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            
        } onFailure: { ( _) in
            
        }

    }
    
    @objc private func useLoginCredTapped(_ sender: UIButton){
        self.trxResultCheckTimer?.invalidate()
        self.trxResultCheckTimer = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        
                let data = string.data(using: String.Encoding.ascii)
        
                if let filter = CIFilter(name: "CIQRCodeGenerator") {
                    filter.setValue(data, forKey: "inputMessage")
                    let transform = CGAffineTransform(scaleX: 3, y: 3)
        
                    if let output = filter.outputImage?.transformed(by: transform) {
                        return UIImage(ciImage: output)
                    }
                }
        
                return nil
        
//        let data = string.data(using: String.Encoding.ascii)
//
//        if let filter = CIFilter(name: "CIQRCodeGenerator"){
//
//            filter.setValue(data, forKey: "inputMessage")
//
//            guard let qrImage = filter.outputImage else {return nil}
//            let scaleX = self.qrImageView.frame.size.width / qrImage.extent.size.width
//            let scaleY = self.qrImageView.frame.size.height / qrImage.extent.size.height
//            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
//
//            if let output = filter.outputImage?.transformed(by: transform){
//
//                let context:CIContext = CIContext(options: nil)
//                guard let cgImage:CGImage = context.createCGImage(output, from: output.extent) else { return nil }
//
//                return UIImage(cgImage: cgImage)
//            }
//        }
//        return nil
    }
    
    
    deinit {
        trxResultCheckTimer?.invalidate()
        trxResultCheckTimer = nil
    }

}
