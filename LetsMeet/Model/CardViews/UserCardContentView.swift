//
//  UserCardContentView.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/16.
//

import UIKit

class UserCardContentView: UIView {
    
    private let backgroundView: UIView = {
        let background = UIView()
        background.clipsToBounds = true
        background.layer.cornerRadius = 10
        return background
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let gradientLayer : CAGradientLayer = {
        // 그림자 넣는 함수
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.01).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor]
        // 그라디언트 시작 포인트
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        // 그라디언트 끝 포인트
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        return gradientLayer
    }()
    
    init(withImage image: UIImage? ) {
        super.init(frame: .zero)
        imageView.image = image
        initializer()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func initializer() {
        addSubview(backgroundView)
        // anchorToSuperview 는 메인 카드뷰
        backgroundView.anchorToSuperview()
        backgroundView.addSubview(imageView)
        imageView.anchorToSuperview()
        applyShadow(radius: 8, opacity: 0.2, offset: CGSize(width: 0, height: 2))
        backgroundView.layer.insertSublayer(gradientLayer, above: imageView.layer)
    }
    
    // 뷰를 그리는 함수
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let heightFactor: CGFloat = 0.35
        gradientLayer.frame = CGRect(x: 0, y: (1 - heightFactor * bounds.height), width: bounds.width, height: heightFactor * bounds.height)
        
    }
    
}

