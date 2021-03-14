//
//  ToCViewController.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 14/2/21.
//

import UIKit

class ToCViewController: BaseViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImageFromBundle(ToCViewController.self, imageName: "backButton", for: .normal)
        
        button.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var fpLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setImageFromBundle(ToCViewController.self, imageName: "navLogoFP-en")
        
        return imageView
    }()
    
    private lazy var logoBackButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        stackView.addArrangedSubview(backButton)
        stackView.addArrangedSubview(fpLogoImageView)
        
        return stackView
    }()
    
    private lazy var tocTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .hexStringToUIColor(hex: "#636696")
        label.font = K.UI.appFont(ofSize: 20, style: .medium)
        label.textAlignment = .natural
        label.text = "Term & Conditions"
        
        return label
    }()
    
    private lazy var tocTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textAlignment = .natural
        textView.textColor = .hexStringToUIColor(hex: "#5F6AA0")
        textView.font = K.UI.appFont(ofSize: 10, style: .regular)
        textView.isEditable = false
        textView.contentOffset = .zero
        
        textView.text = """
        Here are a few examples: The Intellectual Property disclosure will inform users that the contents, logo and other visual media you created is your property and is protected by copyright laws. A Termination clause will inform that users’ accounts on your website and mobile app or users’ access to your website and mobile (if users can’t have an account with you) can be terminated in case of abuses or at your sole discretion. A Governing Law will inform users which laws govern the agreement. This should the country in which your company is headquartered or the country from which you operate your website and mobile app. A Links To Other Web Sites clause will inform users that you are not responsible for any third party websites that you link to. This kind of clause will generally inform users that they are responsible for reading and agreeing (or disagreeing) with the Terms and Conditions or Privacy Policies of these third parties. If your website or mobile app allows users to create content and make that content public to other users, a Content section will inform users that they own the rights to the content they have created. The “Content” clause usually mentions that users must give you (the website or mobile app developer) a license so that you can share this content on your website/mobile app and to make it available to other users. Because the content created by users is public to other users, a DMCA notice clause (or Copyright Infringement ) section is helpful to inform users and copyright authors that, if any content is found to be a copyright infringement, you will respond to any DMCA takedown notices received and you will take down the content. A Limit What Users Can Do clause can inform users that by agreeing to use your service, they’re also agreeing to not do certain things. This can be part of a very long and thorough list in your Terms and Conditions agreements so as to encompass the most amount of negative uses. Here’s how 500px lists its prohibited activities:
        """
        
        return textView
    }()
    
    private lazy var tocContainerView: UIView = {
        let uiview = UIView()
        uiview.translatesAutoresizingMaskIntoConstraints = false
        uiview.backgroundColor = .hexStringToUIColor(hex: "#EFF5F8")
        uiview.layer.cornerRadius = 8
        uiview.clipsToBounds = true
        
        uiview.addSubview(tocTextView)
        NSLayoutConstraint.activate([
            tocTextView.leadingAnchor.constraint(equalTo: uiview.leadingAnchor, constant: 22),
            tocTextView.topAnchor.constraint(equalTo: uiview.topAnchor, constant: 26),
            tocTextView.trailingAnchor.constraint(equalTo: uiview.trailingAnchor, constant: -22),
            tocTextView.bottomAnchor.constraint(equalTo: uiview.bottomAnchor, constant: -26)
        ])
        
        return uiview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(logoBackButtonStackView)
        NSLayoutConstraint.activate([
            logoBackButtonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoBackButtonStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            logoBackButtonStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(tocTitleLabel)
        NSLayoutConstraint.activate([
            tocTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tocTitleLabel.topAnchor.constraint(equalTo: logoBackButtonStackView.bottomAnchor, constant: 30),
            tocTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
        ])
        
        view.addSubview(tocContainerView)
        NSLayoutConstraint.activate([
            tocContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tocContainerView.topAnchor.constraint(equalTo: tocTitleLabel.bottomAnchor, constant: 16),
            tocContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tocContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func backTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
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
