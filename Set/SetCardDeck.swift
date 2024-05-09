//
//  SetCardDeck.swift
//  Set
//
//  Created by KaBanks on 3/23/23.
//

import Foundation
import SwiftUI

struct SetCardDeck {
    private var deck = [SetCard]()

    func count() -> Int {
        self.deck.count
    }

    func isEmpty() -> Bool {
        self.deck.count == 0
    }

    mutating func dealCard() -> SetCard? {
        if self.isEmpty() {
            return nil
        } else {
            return self.deck.remove(at: 0)
        }
    }

    init() {
        var id = 1

        for color in SetCard.Colors.all {
            for shape in SetCard.Shapes.all {
                for shade in SetCard.Shades.all {
                    for count in 1...3 {
                        self.deck += [SetCard(
                                        shape: shape,
                                        shade: shade,
                                        color: color,
                                        count: count,
                                        id: id )]
                        id += 1
                    }
                }
            }
        }

        self.deck.shuffle()
        self.deck.shuffle()

    }
}
