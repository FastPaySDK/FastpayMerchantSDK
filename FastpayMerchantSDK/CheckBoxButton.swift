//
//  CheckBoxButton.swift
//  FastpaySDK
//
//  Created by Anamul Habib on 12/2/21.
//

import UIKit

class CheckBoxButton: UIButton {

    var isChecked: Bool = false{
        didSet{
            if isChecked{
                self.backgroundColor = .hexStringToUIColor(hex: "#2892D7")
                self.setImage(UIImage.init(named: "tick"), for: .normal)
                self.layer.borderWidth = 0
            }else{
                self.backgroundColor = .hexStringToUIColor(hex: "#FFFFFF")
                self.setImage(nil, for: .normal)
                self.layer.borderWidth = 1
            }
            onStateChange?(isChecked)
        }
    }
    
    var onStateChange: ((Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView(){
        self.contentMode = .scaleAspectFit
        self.backgroundColor = .hexStringToUIColor(hex: "#FFFFFF")
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.hexStringToUIColor(hex: "#C4C4C4").cgColor
        
        self.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    }
    
    
    @objc private func tapped(_ sender: CheckBoxButton){
        isChecked = !isChecked
    }

}
