//
//  FPAuthViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 11/2/21.
//

import UIKit

class FPAuthViewController: BaseViewController {
    
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
        label.text = pay_via_text[currentLanguage?.identifier ?? ""]
        
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
    
    private lazy var orLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#000000")
        label.font = K.UI.appFont(ofSize: 13, style: .regular)
        label.textAlignment = .natural
        label.text = or_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var qrButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImageFromBundle(FPAuthViewController.self, imageName: "qrButtonIcon", for: .normal)
        
        button.addTarget(self, action: #selector(qrTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var generateQRLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#2892D7")
        label.font = K.UI.appFont(ofSize: 14, style: .medium)
        label.textAlignment = .natural
        label.text = generate_qr_text[currentLanguage?.identifier ?? ""]
        
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.hexStringToUIColor(hex: "#2892D7"), for: .normal)
        button.titleLabel?.font = K.UI.appFont(ofSize: 12, style: .medium)
        button.setTitle(back_text[currentLanguage?.identifier ?? ""], for: .normal)
        
        button.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
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
        
        uiview.addSubview(mobileNumberTitleLabel)
        NSLayoutConstraint.activate([
            mobileNumberTitleLabel.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            mobileNumberTitleLabel.topAnchor.constraint(equalTo: horizontalBarBelowFPLogoStackView.bottomAnchor, constant: 23),
            mobileNumberTitleLabel.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
        ])
        
        uiview.addSubview(mobileNumberTextField)
        NSLayoutConstraint.activate([
            mobileNumberTextField.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            mobileNumberTextField.topAnchor.constraint(equalTo: mobileNumberTitleLabel.bottomAnchor, constant: 8),
            mobileNumberTextField.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
            mobileNumberTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        uiview.addSubview(passwordTitleLabel)
        NSLayoutConstraint.activate([
            passwordTitleLabel.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            passwordTitleLabel.topAnchor.constraint(equalTo: mobileNumberTextField.bottomAnchor, constant: 20),
            passwordTitleLabel.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
        ])
        
        uiview.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            passwordTextField.topAnchor.constraint(equalTo: passwordTitleLabel.bottomAnchor, constant: 8),
            passwordTextField.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        uiview.addSubview(tocStackView)
        NSLayoutConstraint.activate([
            tocStackView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            tocStackView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            tocStackView.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
        ])
        
        uiview.addSubview(proceedButton)
        NSLayoutConstraint.activate([
            proceedButton.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            proceedButton.topAnchor.constraint(equalTo: tocStackView.bottomAnchor, constant: 20),
            proceedButton.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -28),
            proceedButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        uiview.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: proceedButton.bottomAnchor, constant: 20)
        ])
        
        uiview.addSubview(qrButton)
        NSLayoutConstraint.activate([
            qrButton.centerXAnchor.constraint(equalTo: uiview.centerXAnchor),
            qrButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20)
        ])
        
        uiview.addSubview(generateQRLabel)
        NSLayoutConstraint.activate([
            generateQRLabel.leadingAnchor.constraint(greaterThanOrEqualTo: uiview.leadingAnchor, constant: 28),
            generateQRLabel.topAnchor.constraint(equalTo: qrButton.bottomAnchor, constant: 20),
            generateQRLabel.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            generateQRLabel.centerXAnchor.constraint(equalTo: uiview.centerXAnchor)
        ])
        
        uiview.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 28),
            backButton.topAnchor.constraint(equalTo: generateQRLabel.bottomAnchor, constant: 94),
            backButton.trailingAnchor.constraint(lessThanOrEqualTo: uiview.trailingAnchor, constant: -28),
            backButton.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -20)
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
        
    }
    
    @objc private func tocTapped(_ sender: UIButton){
        let vc = ToCViewController()
        self.navigationController?.show(vc, sender: self)
    }
    
    @objc private func proceedTapped(_ sender: UIButton){
        
        webserviceHandler.pay(mobileNumber: K.Misc.CountryCode + formatMobileNumberEscapingSpecialChar(mobileNumberTextField.text), password: passwordTextField.text(), orderId: dataHandler.orderId, token: dataHandler.initiationData?.token ?? "", shouldShowLoader: true) { (response) in
            
            if response.code == 200{
                
                let vc = FPTransactionSuccessViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true, completion: nil)
                
            }else{
                //self.showDialog(title: nil, message: response.errors?.joined(separator: "\n") ?? K.Messages.DefaultErrorMessage, onDefaultActionButtonTap: nil)
                let vc = FPTransactionFailureViewController()
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
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
    
    @objc private func backTapped(_ sender: UIButton){
        self.dismiss(animated: true, completion: {
            
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

