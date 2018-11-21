// Copyright DApps Platform Inc. All rights reserved.

import UIKit

class SignUpButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        self.layer.cornerRadius = 5.0
//        self.layer.borderColor = UIColor.red.cgColor
//        self.layer.borderWidth = 1.5
//        self.backgroundColor = UIColor.blue
//        self.tintColor = UIColor.white
        apply(size: ButtonSize.large, style: ButtonStyle.solid)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitle(NSLocalizedString("CONTINUE", comment: ""), for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        self.backgroundColor = Colors.darkBlue
    }
    func apply(size: ButtonSize, style: ButtonStyle) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            ])
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius
        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = style.borderWidth
        layer.masksToBounds = true
        titleLabel?.textColor = style.textColor
        titleLabel?.font = style.font
        setTitleColor(style.textColor, for: .normal)
        setTitleColor(style.textColorHighlighted, for: .highlighted)
        setBackgroundColor(style.backgroundColorHighlighted, forState: .highlighted)
        setBackgroundColor(style.backgroundColorHighlighted, forState: .selected)
        setBackgroundColor(style.backgroundColorDisabled, forState: .disabled)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
}
