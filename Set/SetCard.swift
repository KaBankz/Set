//
//  SetCard.swift
//  Set
//
//  Created by KaBanks on 3/23/23.
//

import Foundation
import SwiftUI

struct SetCard: Identifiable {
    var id: Int

    var shape: Shapes
    var shade: Shades
    var color: Colors
    var count: Int

    var isSelected: Bool
    var isMatched: Bool
    var isMisMatched: Bool

    enum Shapes {
        case oval
        case squiggle
        case diamond

        static var all = [Shapes.oval, Shapes.squiggle, Shapes.diamond]
    }

    enum Shades {
        case outlined
        case striped
        case filled

        static var all = [Shades.outlined, Shades.striped, Shades.filled]
    }

    enum Colors {
        case red
        case green
        case purple

        static var all = [Colors.red, Colors.green, Colors.purple]
    }

    func getCardColor() -> Color {
        switch self.color {
            case .green:
                return Color.green
            case .purple:
                return Color.purple
            case .red:
                return Color.red
        }
    }

    init(shape: Shapes, shade: Shades, color: Colors, count: Int, id: Int) {
        self.id = id

        self.shape = shape
        self.shade = shade
        self.color = color
        self.count = count

        self.isSelected = false
        self.isMatched = false
        self.isMisMatched = false
    }
}
