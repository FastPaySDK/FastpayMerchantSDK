//
//  FPAuthViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import UIKit

class FPAuthViewController: BaseViewController {
    
    private var trxResultCheckTimer: Timer?
    
    private lazy var headerView: UIView = {
        let uiview = HeaderView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        
        return uiview
    }()
    
    private lazy var payViaLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#43466E")
        label.font = K.UI.appFont(ofSize: 15, style: .medium)
        label.textAlignment = .natural
        label.text = "How would you like to pay?"
        
        return label
    }()
    
    private lazy var fpLogoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.setImageFromBundle(FPAuthViewController.self, imageName: "logoFP-en")
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        return imageView
    }()
    
    private lazy var fpLogoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        
//        stackView.addArrangedSubview(payViaLabel)
        stackView.addArrangedSubview(fpLogoImageView)
        
        return stackView
    }()
    
//    private lazy var horizontalBarBelowFPLogoStackView: UIView = {
//        let uiview = UIView()
//        uiview.translatesAutoresizingMaskIntoConstraints = false
//        uiview.backgroundColor = .hexStringToUIColor(hex: "#D8E5EB")
//        
//        return uiview
//    }()
    
    private lazy var typeSelectionSegmentedControl:UISegmentedControl = {
        
        let segmentedControl = UISegmentedControl(items: ["Scan QR Code", "Login to Pay"])
        
        // Set properties
        segmentedControl.selectedSegmentIndex = 0
        
        if #available(iOS 13.0, *) {
            
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor:K.UI.PrimaryTintColor
            ]
            
            let selectedAttribute: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.hexStringToUIColor(hex: "#FFFFFF")
            ]
            
            segmentedControl.selectedSegmentTintColor = K.UI.PrimaryTintColor
            segmentedControl.backgroundColor = .white
            segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
            segmentedControl.setTitleTextAttributes(selectedAttribute, for: .selected)
            
            
//            let borderColor = K.UI.PrimaryTintColor
//            let borderImage = UIImage.createBorderImage(color: borderColor, size: CGSize(width: 1, height: 32))
//            
//            segmentedControl.setBackgroundImage(borderImage, for: .normal, barMetrics: .default)
//            segmentedControl.setBackgroundImage(borderImage, for: .selected, barMetrics: .default)
//
//            segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            
        } else {
            segmentedControl.tintColor = .white
            segmentedControl.backgroundColor = K.UI.PrimaryTintColor
        }
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        
        // Add to the view
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
        
    }()
    
    @objc func segmentedValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginWithCredContainerView.isHidden = true
            payWithQRContainerView.isHidden     = false
        }else{
            loginWithCredContainerView.isHidden = false
            payWithQRContainerView.isHidden     = true
        }
    }
        
    private lazy var loginWithCredContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        
        return uiview
    }()
        
    private lazy var mobileNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 12, style: .medium)
        label.textAlignment = .natural
        label.text = mobile_number_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var mobileNumberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = true
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.semanticContentAttribute = .forceLeftToRight
        textField.keyboardType = .phonePad
        textField.textColor = .hexStringToUIColor(hex: "#000000")
        textField.font = K.UI.appFont(ofSize: 14, style: .medium)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#C4C4C4").cgColor
        textField.layer.cornerRadius = 24
        textField.tag = 100
        textField.delegate = self
        
        let label = UILabel()
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 14, style: .medium)
        label.text = "    " + K.Misc.CountryCode + " -"
        textField.addLeftView(label, for: .always)
        
        let labelII = UILabel()
        labelII.text = "    "
        textField.addRightView(labelII, for: .always)
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
//    private var isPasswordVisible = false {
//        didSet {
//            if isPasswordVisible {
//                self.passwordTextField.isSecureTextEntry = false
//                eyeButton.setImageFromBundle(FPAuthViewController.self, imageName: "eye", for: .normal)
//            } else {
//                self.passwordTextField.isSecureTextEntry = true
//                eyeButton.setImageFromBundle(FPAuthViewController.self, imageName: "eye_slash", for: .normal)
//            }
//        }
//    }
//    
//    private let eyeButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImageFromBundle(FPAuthViewController.self, imageName: "eye_slash", for: .normal)
//        button.tintColor = .gray
//        button.addTarget(FPAuthViewController.self, action: #selector(eyeButtonTapped), for: .touchUpInside)
//        return button
//    }()
//    
//    @objc private func eyeButtonTapped(){
//        self.isPasswordVisible.toggle()
//    }
//    
    private lazy var passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 12, style: .medium)
        label.textAlignment = .natural
        label.text = password_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isEnabled = true
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.semanticContentAttribute = .forceLeftToRight
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.textColor = .hexStringToUIColor(hex: "#000000")
        textField.font = K.UI.appFont(ofSize: 14, style: .medium)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.hexStringToUIColor(hex: "#C4C4C4").cgColor
        textField.layer.cornerRadius = 24
        textField.tag = 101
        textField.delegate = self
        
        let labelII = UILabel()
        labelII.text = "    "
        textField.addLeftView(labelII, for: .always)
        textField.addRightView(labelII, for: .always)
        
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var tocCheckButton: CheckBoxButton = {
        let button = CheckBoxButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.onStateChange = {( _) in
            self.checkInputs()
        }
        
        return button
    }()
    
    private lazy var tocIAcceptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 12, style: .medium)
        label.textAlignment = .natural
        label.text = i_accept_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var tocButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let underlineAttributedString = NSAttributedString(string: toc_text[currentLanguage?.identifier ?? ""] ?? "", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.hexStringToUIColor(hex: "#2892D7"), NSAttributedString.Key.font: K.UI.appFont(ofSize: 12, style: .medium)])
        button.setAttributedTitle(underlineAttributedString, for: .normal)
        
        button.addTarget(self, action: #selector(tocTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var tocStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        stackView.addArrangedSubview(tocCheckButton)
        stackView.addArrangedSubview(tocIAcceptLabel)
        stackView.addArrangedSubview(tocButton)
        
        NSLayoutConstraint.activate([
            tocCheckButton.widthAnchor.constraint(equalToConstant: 15),
            tocCheckButton.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        return stackView
    }()
    
    private lazy var proceedButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.hexStringToUIColor(hex: "#2892D7").cgColor
        button.layer.cornerRadius = 24
        button.backgroundColor = .hexStringToUIColor(hex: "#2892D7")
        button.setTitle("\(procceed_to_text[currentLanguage?.identifier ?? ""] ?? "") \(dataHandler.amount!) \(dataHandler.selectedCurrency.code())", for: .normal)
        button.titleLabel?.font = K.UI.appFont(ofSize: 12, style: .bold)
        button.clipsToBounds = true
        
        button.isEnabled = false
        button.addSubview(overlayForDisableButton)
        NSLayoutConstraint.activate([
            overlayForDisableButton.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            overlayForDisableButton.topAnchor.constraint(equalTo: button.topAnchor),
            overlayForDisableButton.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            overlayForDisableButton.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        
        button.addTarget(self, action: #selector(proceedTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var overlayForDisableButton: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .white
        uiview.alpha = 0.4
        
        return uiview
    }()
    
//    private lazy var orLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .hexStringToUIColor(hex: "#000000")
//        label.font = K.UI.appFont(ofSize: 13, style: .regular)
//        label.textAlignment = .natural
//        label.text = or_text[currentLanguage?.identifier ?? ""]
//        
//        return label
//    }()
//    
//    private lazy var qrButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImageFromBundle(FPAuthViewController.self, imageName: "qrButtonIcon", for: .normal)
//        
//        button.addTarget(self, action: #selector(qrTapped(_:)), for: .touchUpInside)
//        
//        return button
//    }()
//    
//    private lazy var generateQRLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .hexStringToUIColor(hex: "#2892D7")
//        label.font = K.UI.appFont(ofSize: 14, style: .medium)
//        label.textAlignment = .natural
//        label.text = generate_qr_text[currentLanguage?.identifier ?? ""]
//        
//        return label
//    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.hexStringToUIColor(hex: "#43466E"), for: .normal)
        button.backgroundColor = .hexStringToUIColor(hex: "#D8E5EB")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = K.UI.appFont(ofSize: 12, style: .medium)
        button.setTitle(back_text[currentLanguage?.identifier ?? ""], for: .normal)
        
        button.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var qrCancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.hexStringToUIColor(hex: "#43466E"), for: .normal)
        button.backgroundColor = .hexStringToUIColor(hex: "#D8E5EB")
        button.layer.cornerRadius = 8
        button.titleLabel?.font = K.UI.appFont(ofSize: 12, style: .medium)
        button.setTitle(back_text[currentLanguage?.identifier ?? ""], for: .normal)
        
        button.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    //QR View Components
    private lazy var payWithQRContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    private lazy var qrTipLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor     = .hexStringToUIColor(hex: "#000000")
        label.font          = K.UI.appFont(ofSize: 14, style: .regular)
        label.text          = "Scan to pay via Fastpay"
        
        return label
    }()
    
    private lazy var qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode     = .scaleAspectFit
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
            fpLogoStackView.centerXAnchor.constraint(equalTo: uiview.centerXAnchor, constant: 0),
            fpLogoStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            fpLogoStackView.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28)
        ])
        

        uiview.addSubview(typeSelectionSegmentedControl)
        
        // Set constraints
        NSLayoutConstraint.activate([
            typeSelectionSegmentedControl.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            typeSelectionSegmentedControl.topAnchor.constraint(equalTo: fpLogoStackView.bottomAnchor, constant: 40),
            typeSelectionSegmentedControl.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
            typeSelectionSegmentedControl.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        uiview.addSubview(payViaLabel)
        NSLayoutConstraint.activate([
            payViaLabel.leadingAnchor.constraint(equalTo: typeSelectionSegmentedControl.leadingAnchor),
            payViaLabel.topAnchor.constraint(equalTo: typeSelectionSegmentedControl.topAnchor, constant: -35),
            payViaLabel.trailingAnchor.constraint(equalTo: typeSelectionSegmentedControl.trailingAnchor)
        ])
        
        uiview.addSubview(loginWithCredContainerView)
        NSLayoutConstraint.activate([
            loginWithCredContainerView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 0),
            loginWithCredContainerView.topAnchor.constraint(equalTo: typeSelectionSegmentedControl.bottomAnchor, constant: 23),
            loginWithCredContainerView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: 0),
            loginWithCredContainerView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: 0)
        ])
        
        uiview.addSubview(payWithQRContainerView)
        NSLayoutConstraint.activate([
            payWithQRContainerView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 0),
            payWithQRContainerView.topAnchor.constraint(equalTo: typeSelectionSegmentedControl.bottomAnchor, constant: 23),
            payWithQRContainerView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: 0),
            payWithQRContainerView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: 0)
        ])
        
        
        payWithQRContainerView.addSubview(qrTipLabel)
        NSLayoutConstraint.activate([
            qrTipLabel.leadingAnchor.constraint(greaterThanOrEqualTo: payWithQRContainerView.leadingAnchor, constant: 40),
            qrTipLabel.topAnchor.constraint(equalTo: payWithQRContainerView.topAnchor, constant: 0),
            qrTipLabel.trailingAnchor.constraint(lessThanOrEqualTo: payWithQRContainerView.trailingAnchor, constant: -40),
            qrTipLabel.centerXAnchor.constraint(equalTo: payWithQRContainerView.centerXAnchor)
        ])
        
        payWithQRContainerView.addSubview(qrContainerView)
        NSLayoutConstraint.activate([
            qrContainerView.centerXAnchor.constraint(equalTo: payWithQRContainerView.centerXAnchor),
            qrContainerView.topAnchor.constraint(equalTo: qrTipLabel.bottomAnchor, constant: 20),
            qrContainerView.widthAnchor.constraint(equalTo: payWithQRContainerView.widthAnchor, multiplier: 0.6933, constant: 0),
            qrContainerView.heightAnchor.constraint(equalTo: qrContainerView.widthAnchor, multiplier: 1)
        ])
        
        payWithQRContainerView.addSubview(qrCancelButton)
        NSLayoutConstraint.activate([
            qrCancelButton.centerXAnchor.constraint(equalTo: payWithQRContainerView.centerXAnchor, constant: 0),
            qrCancelButton.topAnchor.constraint(equalTo: qrContainerView.bottomAnchor, constant: 15),
          //  backButton.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            qrCancelButton.bottomAnchor.constraint(equalTo: payWithQRContainerView.bottomAnchor, constant: -20),
            qrCancelButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        loginWithCredContainerView.addSubview(mobileNumberTitleLabel)
        NSLayoutConstraint.activate([
            mobileNumberTitleLabel.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 35),
            mobileNumberTitleLabel.topAnchor.constraint(equalTo: loginWithCredContainerView.topAnchor, constant: 0),
            mobileNumberTitleLabel.trailingAnchor.constraint(equalTo: loginWithCredContainerView.trailingAnchor, constant: -28),
        ])
        
        loginWithCredContainerView.addSubview(mobileNumberTextField)
        NSLayoutConstraint.activate([
            mobileNumberTextField.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 28),
            mobileNumberTextField.topAnchor.constraint(equalTo: mobileNumberTitleLabel.bottomAnchor, constant: 8),
            mobileNumberTextField.trailingAnchor.constraint(equalTo: loginWithCredContainerView.trailingAnchor, constant: -28),
            mobileNumberTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        loginWithCredContainerView.addSubview(passwordTitleLabel)
        NSLayoutConstraint.activate([
            passwordTitleLabel.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 28),
            passwordTitleLabel.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 20),
            passwordTitleLabel.trailingAnchor.constraint(equalTo: loginWithCredContainerView.trailingAnchor, constant: -28),
        ])
        
        loginWithCredContainerView.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 28),
            passwordTextField.topAnchor.constraint(equalTo: passwordTitleLabel.bottomAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: loginWithCredContainerView.trailingAnchor, constant: -28),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
//        uiview.addSubview(eyeButton)
//        NSLayoutConstraint.activate([
//            eyeButton.bottomAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
//            eyeButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -8),
//            eyeButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20),
//            eyeButton.heightAnchor.constraint(equalToConstant: 34),
//            eyeButton.widthAnchor.constraint(equalToConstant: 45)
//        ])
        
        loginWithCredContainerView.addSubview(tocStackView)
        NSLayoutConstraint.activate([
            tocStackView.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 28),
            tocStackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            tocStackView.trailingAnchor.constraint(lessThanOrEqualTo: loginWithCredContainerView.trailingAnchor, constant: -28),
        ])
        
        loginWithCredContainerView.addSubview(proceedButton)
        NSLayoutConstraint.activate([
            proceedButton.leadingAnchor.constraint(equalTo: loginWithCredContainerView.leadingAnchor, constant: 28),
            proceedButton.topAnchor.constraint(equalTo: tocStackView.bottomAnchor, constant: 20),
            proceedButton.trailingAnchor.constraint(equalTo: loginWithCredContainerView.trailingAnchor, constant: -28),
            proceedButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
//        loginWithCredContainerView.addSubview(orLabel)
//        NSLayoutConstraint.activate([
//            orLabel.centerXAnchor.constraint(equalTo: loginWithCredContainerView.centerXAnchor),
//            orLabel.topAnchor.constraint(equalTo: proceedButton.bottomAnchor, constant: 20)
//        ])
//        
//        loginWithCredContainerView.addSubview(qrButton)
//        NSLayoutConstraint.activate([
//            qrButton.centerXAnchor.constraint(equalTo: loginWithCredContainerView.centerXAnchor),
//            qrButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20)
//        ])
//        
//        loginWithCredContainerView.addSubview(generateQRLabel)
//        NSLayoutConstraint.activate([
//            generateQRLabel.leadingAnchor.constraint(greaterThanOrEqualTo: loginWithCredContainerView.leadingAnchor, constant: 28),
//            generateQRLabel.topAnchor.constraint(equalTo: qrButton.bottomAnchor, constant: 20),
//            generateQRLabel.trailingAnchor.constraint(lessThanOrEqualTo: loginWithCredContainerView.trailingAnchor, constant: -28),
//            generateQRLabel.centerXAnchor.constraint(equalTo: loginWithCredContainerView.centerXAnchor)
//        ])
                
        loginWithCredContainerView.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: loginWithCredContainerView.centerXAnchor, constant: 0),
            backButton.topAnchor.constraint(equalTo: proceedButton.bottomAnchor, constant: 30),
          //  backButton.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            backButton.bottomAnchor.constraint(equalTo: loginWithCredContainerView.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 120)
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
    
    var initialized:Bool?
    
    override var scrollViewToOverride: UIScrollView?{
        return mainScrollView
    }
    
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
        
        loginWithCredContainerView.isHidden = true
        payWithQRContainerView.isHidden     = false
        
        self.addSpashView()
        self.initialization()
    }
    
    let splashView = SplashViewController().view!
    private func addSpashView() {
        view.addSubview(splashView)
        NSLayoutConstraint.activate([
            splashView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            splashView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            splashView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            splashView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func removeSplashView() {
        splashView.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let isInitialized = initialized{
            if !isInitialized{
                self.dismiss(animated: true, completion: { self.delegate?.fastPayProcessStatus(with: .CANCEL) })
            }
        }
        
        self.mobileNumberTextField.text = ""
        self.passwordTextField.text     = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trxResultCheckTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkTransaction(_:)), userInfo: nil, repeats: true)
    }
    
    //MARK: - API Calls
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
    
    private func initialization() {
        FPWebServiceHandler.shared.initiate(storeId: dataHandler.storeId, storePassword: dataHandler.storePass, amount: FPDataHandler.shared.amount, orderId: FPDataHandler.shared.orderId, currency: FPDataHandler.shared.selectedCurrency, shouldShowLoader: true) { [self] (response) in
            self.removeSplashView()
            if response.code == 200{
                print("--1--")
                if let qrCode = response.initiationData?.qrToken{
                    var urlComponents    = URLComponents()
                    urlComponents.scheme = "appFpp"
                    urlComponents.host   = "fast-pay.cash"
                    urlComponents.path   = "/qrpay"
                    let queryItem0       = URLQueryItem(name: "qrdata", value: qrCode)
                    let queryItem1       = URLQueryItem(name: "clientUri", value: "appfpclient"+FPDataHandler.shared.uri)
                    let queryItem2       = URLQueryItem(name: "transactionId", value: FPDataHandler.shared.orderId)
                    urlComponents.queryItems = [queryItem0, queryItem1, queryItem2]
                    let appURL               = urlComponents.url //URL(string: "appfpp://fast-pay.cash/qrpay")

//                    print(appURL ?? "")
                    if UIApplication.shared.openURL(appURL!) {
                        self.delegate?.fastPayProcessStatus(with: .PAYMENT_WITH_FASTPAY_APP)
                        self.dismiss(animated: true, completion: {
                            UIApplication.shared.open(appURL!, options: [:], completionHandler: nil)
                        })
                    } else {
                        self.delegate?.fastPayProcessStatus(with: .PAYMENT_WITH_FASTPAY_SDK)
                        FPDataHandler.shared.initiationData = response.initiationData
                        self.qrImageView.image = generateQRCode(from: response.initiationData?.qrToken ?? "")
                        self.initialized = true
                    }
                }else{
                    FPDataHandler.shared.initiationData = response.initiationData
                    self.initialized = true
                }
            }else{
                
                self.initialized = false
                DispatchQueue.main.async {
                    let vc = FPTransactionFailureViewController()
                    vc.modalTransitionStyle   = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    vc.msg = response.errors?.first ?? "initaialization failed!"
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        } onFailure: { ( _) in
            self.removeSplashView()
            self.initialized = false
            DispatchQueue.main.async {
                let vc = FPTransactionFailureViewController()
                vc.modalTransitionStyle   = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                vc.msg = "initaialization failed!-"
                self.present(vc, animated: true, completion: nil)
            }
        } onConnectionFailure: {
            self.removeSplashView()
            self.initialized = false
            DispatchQueue.main.async {
                let vc = FPTransactionFailureViewController()
                vc.modalTransitionStyle   = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                vc.msg = "initaialization failed!--"
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func tocTapped(_ sender: UIButton){
        let vc = ToCViewController()
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc private func proceedTapped(_ sender: UIButton){
        let mobileNumer = formatMobileNumberEscapingSpecialChar(mobileNumberTextField.text)
        let password    = passwordTextField.text()
      //  print("Mobile  : \(mobileNumer) token: \(self.dataHandler.initiationData?.token ?? "")")
        webserviceHandler.sentOTP(mobileNumber: K.Misc.CountryCode + mobileNumer, password: password, orderId: dataHandler.orderId, token: dataHandler.initiationData?.token ?? "", shouldShowLoader: true) { (response) in
           
            let failureMsg = response.message ?? K.Messages.DefaultErrorMessage
            if response.code == 200{
                
                let vc = OTPViewController(mobileNumber: mobileNumer, password: password, msg: response.message ?? "")
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
                
            }else{
                //self.showDialog(title: nil, message: response.errors?.joined(separator: "\n") ?? K.Messages.DefaultErrorMessage, onDefaultActionButtonTap: nil)
                let vc = FPTransactionFailureViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                vc.msg = failureMsg
                
                self.present(vc, animated: true, completion: nil)
            }
            
        } onFailure: { ( _) in
            //self.showDialog(title: nil, message: K.Messages.DefaultErrorMessage, onDefaultActionButtonTap: nil)
            let vc = FPTransactionFailureViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc private func qrTapped(_ sender: UIButton){
        
        let vc = FPQRViewController()
        vc.modalTransitionStyle = .flipHorizontal
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
    }
    
    @objc private func backTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: {
            self.delegate?.fastPayProcessStatus(with: .CANCEL)
        })
    }
    
    override func checkInputs() {
        super.checkInputs()
        
        var shouldProceed = true
        
        if (!mobileNumberTextField.hasText || getMobileNoLengthEscapingSpecialChar(mobileNumberTextField.text) < K.Misc.MobileNoLength){
            shouldProceed = false
        }
        
        if !passwordTextField.hasText {
            shouldProceed = false
        }
        
        if (shouldProceed && tocCheckButton.isChecked){
            proceedButton.isEnabled = true
            overlayForDisableButton.removeFromSuperview()
        }else{
            proceedButton.isEnabled = false
            proceedButton.isEnabled = false
            proceedButton.addSubview(overlayForDisableButton)
            NSLayoutConstraint.activate([
                overlayForDisableButton.leadingAnchor.constraint(equalTo: proceedButton.leadingAnchor),
                overlayForDisableButton.topAnchor.constraint(equalTo: proceedButton.topAnchor),
                overlayForDisableButton.trailingAnchor.constraint(equalTo: proceedButton.trailingAnchor),
                overlayForDisableButton.bottomAnchor.constraint(equalTo: proceedButton.bottomAnchor)
            ])
        }
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField){
        checkInputs()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mobileNumberTextField{
            
            let length = Int(getMobileNoLengthEscapingSpecialChar(textField.text))
            
            if length == K.Misc.MobileNoLength {
                if range.length == 0 {
                    return false
                }
            }
            
            if length == 3 {
                let num = formatMobileNumberEscapingSpecialChar(textField.text)
                textField.text = "\(num) "
                
                if range.length > 0 {
                    textField.text = "\(((num as NSString?) ?? "").substring(to: 3))"
                }
            }
            
            else if(length == 6){
                let num = formatMobileNumberEscapingSpecialChar(textField.text)
                textField.text = "\((num as NSString).substring(to: 3)) \((num as NSString).substring(from: 3)) "
                
                if range.length > 0 {
                    textField.text = "\((num as NSString).substring(to: 3)) \((num as NSString).substring(from: 3))"
                }
            }
        }
        
        return true
    }
    
    deinit {
        trxResultCheckTimer?.invalidate()
        trxResultCheckTimer = nil
    }
    
}

