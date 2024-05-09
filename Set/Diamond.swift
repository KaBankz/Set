//
//  Diamond.swift
//  Set
//
//  Created by KaBanks on 4/22/23.
//

import SwiftUI

struct Diamond: Shape {

    private struct DiamondRatios {
        static let widthPercentage: CGFloat = 0.15
        static let offsetPercentage: CGFloat = 0.20
    }

    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * DiamondRatios.widthPercentage / 2.0),
            y: rect.height * DiamondRatios.offsetPercentage
        )

        let bottomLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * DiamondRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * DiamondRatios.offsetPercentage)
        )

        let topRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * DiamondRatios.widthPercentage / 2.0),
            y: rect.height * DiamondRatios.offsetPercentage
        )

        let bottomRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * DiamondRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * DiamondRatios.offsetPercentage)
        )

        let rightCenter = CGPoint(
            x: topRight.x,
            y: rect.height / 2.0
        )

        let leftCenter = CGPoint(
            x: topLeft.x,
            y: rect.height / 2.0
        )

        let topCenter = CGPoint(
            x: (topLeft.x + topRight.x) / 2.0,
            y: topLeft.y
        )

        let bottomCenter = CGPoint(
            x: (bottomLeft.x + bottomRight.x) / 2.0,
            y: bottomLeft.y
        )

        var diamond = Path()

        diamond.move(to: topCenter)

        diamond.addLine(to: rightCenter)
        diamond.addLine(to: bottomCenter)

        diamond.addLine(to: leftCenter)
        diamond.addLine(to: topCenter)

        // This line is to keep the top pointy
        diamond.addLine(to: rightCenter)

        return diamond
    }
}
