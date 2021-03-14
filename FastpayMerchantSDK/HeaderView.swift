//
//  HeaderView.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 12/2/21.
//

import UIKit

class HeaderView: UIView {
    
    private lazy var merchantLogoImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.setImageFromBundle(FPAuthViewController.self, imageName: "dummyLogo")
        imageView.setImageFromURl(imageUrl: FPDataHandler.shared.initiationData?.storeLogo ?? "", cacheEnabled: true)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var merchantLogoContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .white
        uiview.clipsToBounds = true
        uiview.layer.cornerRadius = 5
        
        uiview.addSubview(merchantLogoImageView)
        NSLayoutConstraint.activate([
            merchantLogoImageView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 10),
            merchantLogoImageView.topAnchor.constraint(equalTo: uiview.topAnchor, constant: 10),
            merchantLogoImageView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -10),
            merchantLogoImageView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -10)
        ])
        
        return uiview
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#43466E")
        label.font = K.UI.appFont(ofSize: 24, style: .regular)
        label.textAlignment = .natural
        label.text = "\(FPDataHandler.shared.amount!) \(FPDataHandler.shared.selectedCurrency.code())"
        
        return label
    }()
    
    private lazy var merchantNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#43466E")
        label.font = K.UI.appFont(ofSize: 16, style: .regular)
        label.textAlignment = .natural
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.text = FPDataHandler.shared.initiationData?.storeName
        
        return label
    }()
    
    private lazy var orderIdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#43466E")
        label.font = K.UI.appFont(ofSize: 12, style: .regular)
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.text = "\(order_id_text[FPLanguageHandler.shared.currentLanguage.identifier] ?? "") \(FPDataHandler.shared.orderId!)"
        
        return label
    }()
    
    private lazy var nameOrderIdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 6
        
        stackView.addArrangedSubview(merchantNameLabel)
        stackView.addArrangedSubview(orderIdLabel)
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        
        self.backgroundColor = .hexStringToUIColor(hex: "#ECF2F5")
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(merchantLogoContainerView)
        NSLayoutConstraint.activate([
            merchantLogoContainerView.widthAnchor.constraint(equalToConstant: 128),
            merchantLogoContainerView.heightAnchor.constraint(equalToConstant: 58),
            merchantLogoContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56),
            merchantLogoContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 56)
        ])
        
        self.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            amountLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20),
            amountLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            amountLabel.topAnchor.constraint(equalTo: merchantLogoContainerView.bottomAnchor, constant: 25),
            amountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30)
        ])
        
        self.addSubview(nameOrderIdStackView)
        NSLayoutConstraint.activate([
            nameOrderIdStackView.leadingAnchor.constraint(equalTo: merchantLogoContainerView.trailingAnchor, constant: 15),
            nameOrderIdStackView.centerYAnchor.constraint(equalTo: merchantLogoContainerView.centerYAnchor),
            nameOrderIdStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
    }
    
    func markAmountPaid(){
        
        let attributeAmountString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(FPDataHandler.shared.amount!) \(FPDataHandler.shared.selectedCurrency.code())")
        attributeAmountString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeAmountString.length))
        attributeAmountString.addAttributes([NSAttributedString.Key.strikethroughColor : UIColor.hexStringToUIColor(hex: "#000000")], range: NSMakeRange(0, attributeAmountString.length))
        amountLabel.attributedText = attributeAmountString
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rect = CGRect.init(x: amountLabel.bounds.origin.x - 17.5, y: amountLabel.bounds.origin.y - 3.5, width: amountLabel.bounds.size.width + 35, height: amountLabel.bounds.size.height + 7)
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 18)
        layer.path = path.cgPath;
        layer.strokeColor = UIColor.hexStringToUIColor(hex: "#2892D7").cgColor
        layer.lineDashPattern = [7,7];
        layer.backgroundColor = UIColor.clear.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        amountLabel.layer.addSublayer(layer);
    }
    
}
