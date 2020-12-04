//
//  ValuePropCourseCardView.swift
//  edX
//
//  Created by Salman on 18/11/2020.
//  Copyright © 2020 edX. All rights reserved.
//

import UIKit

class ValuePropCourseCardView: UIView {

    private let messageContainer = UIView()
    private let iconContainer = UIView()
    
    private lazy var messageLabel: UILabel = {
        let message = UILabel()
        message.numberOfLines = 0
        message.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: NSLayoutConstraint.Axis.horizontal)
        message.adjustsFontSizeToFitWidth = true
        let messageStyle = OEXTextStyle(weight: .normal, size: .base, color : OEXStyles.shared().neutralBlackT())
        message.attributedText = messageStyle.attributedString(withText: Strings.UpgradeCourseValueProp.viewMessage)
        return message
    }()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        let buttonTextStyle = OEXTextStyle(weight: .semiBold, size: .small, color : OEXStyles.shared().neutralWhiteT())
        button.setAttributedTitle(buttonTextStyle.attributedString(withText: Strings.UpgradeCourseValueProp.learnMoreButtonTitle), for: .normal)
        button.backgroundColor = OEXStyles.shared().primaryBaseColor()
        return button
    }()
    private let trophyImage = UIImageView()
    private let trophyImageSize:CGFloat = 50
    var tapAction : ((ValuePropCourseCardView) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(iconContainer)
        addSubview(messageContainer)
        messageContainer.addSubview(messageLabel)
        messageContainer.addSubview(learnMoreButton)
        iconContainer.addSubview(trophyImage)
        
        learnMoreButton.oex_addAction({[weak self] action in
                if let weakSelf = self {
                    weakSelf.tapAction?(weakSelf)
                }
            }, for: .touchUpInside)
        
        trophyImage.image = Icon.Trophy.imageWithFontSize(size: trophyImageSize)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        iconContainer.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(StandardHorizontalMargin * 2 + 10)
        }
        
        messageContainer.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer.snp.trailing)
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.height.equalTo(self)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(messageContainer).offset(StandardVerticalMargin)
            make.top.equalTo(messageContainer).offset(StandardVerticalMargin)
            make.trailing.equalTo(messageContainer).inset(StandardVerticalMargin)
        }
        
        learnMoreButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom)
            make.bottom.bottomMargin.equalTo(-StandardVerticalMargin)
            make.trailing.equalTo(messageContainer).inset(StandardVerticalMargin)
            make.height.equalTo(StandardHorizontalMargin * 2)
            make.width.equalTo(StandardHorizontalMargin * 6 + 10)
        }
        
        trophyImage.snp.makeConstraints { make in
            make.leading.equalTo(iconContainer).offset(StandardVerticalMargin)
            make.top.equalTo(iconContainer).offset(StandardVerticalMargin * 2)
            make.height.equalTo(StandardHorizontalMargin * 2)
            make.width.equalTo(StandardHorizontalMargin * 2)
        }
    }
}