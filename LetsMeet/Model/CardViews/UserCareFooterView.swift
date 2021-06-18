//
//  UserCareFooterView.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/18.
//

import UIKit

// Extension에 추가된 NSAttributedString 쓸 예정
class UserCardFooterView: UIView {
    
    private var label = UILabel()
    private var gradientLayer: CAGradientLayer?
    
    init(withTitle title: String?, subTitle: String?) {
        super.init(frame: .zero)
        backgroundColor = .clear
        // 카드의 왼쪽 상단 = [Min X, Min Y], 왼쪽 하단 = [Min X, Max Y], 오른쪽 상단 = [Max X, Min Y]
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 10
        clipsToBounds = true
        isOpaque = false
        initialize(title: title, subtitle: subTitle)
        
    }
    
    required init?(coder: NSCoder) {
        return nil
        
    }
    
    private func initialize(title: String?, subtitle: String?) {
        let attributedText = NSMutableAttributedString(string: (title ?? "") + "\n", attributes: NSAttributedString.Key.titleAttributes)
        
        // 조건문을 만들어서 SubTitle이 없다면 보여주지 않음
        if let subtitle = subtitle, subtitle != "" {
            attributedText.append(NSMutableAttributedString(string: subtitle, attributes: NSAttributedString.Key.subtitleAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            // 아래는 Title과 Subtitle간의 간격
            paragraphStyle.lineSpacing = 4
            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
             label.attributedText = attributedText
            addSubview(label)
            
        }
    }
    
    override func layoutSubviews() {
        let padding: CGFloat = 20
        
        label.frame = CGRect(x: padding, y: bounds.height - label.intrinsicContentSize.height - padding, width: bounds.width, height: label.intrinsicContentSize.height)
    }
    
    
}
