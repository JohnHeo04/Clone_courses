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
        content = SampleCardContentView(withImage: model.image)
        footer = SampleCardFotterView(withTiltle: "\(model.name), \(model.age)", subtitle: model.occupation)
    }
}
