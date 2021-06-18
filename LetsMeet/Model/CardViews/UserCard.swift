//
//  UserCard.swift
//  LetsMeet
//
//  Created by John Hur on 2021/06/15.
//

import Foundation
import Shuffle_iOS

class UserCard: SwipeCard {
    
    func configure(withModel model: UserCardModel) {
        content = UserCardContentView(withImage: model.image)
        footer = UserCardFooterView(withTitle: "\(model.name), \(model.age)", subTitle: model.occupation )
    }
}
