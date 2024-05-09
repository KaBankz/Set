//
//  Oval.swift
//  Set
//
//  Created by KaBanks on 4/22/23.
//

import SwiftUI

struct Oval: Shape {

    private struct OvalRatios {
        static let widthPercentage: CGFloat = 0.15
        static let offsetPercentage: CGFloat = 0.20
    }

    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * OvalRatios.widthPercentage / 2.0),
            y: rect.height * OvalRatios.offsetPercentage
        )

        let bottomLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * OvalRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * OvalRatios.offsetPercentage)
        )

        let topRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * OvalRatios.widthPercentage / 2.0),
            y: rect.height * OvalRatios.offsetPercentage
        )

        let bottomRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * OvalRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * OvalRatios.offsetPercentage)
        )

        let topCenter = CGPoint(
            x: (topLeft.x + topRight.x) / 2.0,
            y: topLeft.y
        )

        let bottomCenter = CGPoint(
            x: (bottomLeft.x + bottomRight.x) / 2.0,
            y: bottomLeft.y
        )

        let arcRadius = CGFloat(
            (topRight.x - topLeft.x) / 2.0
        )

        var oval = Path()

        oval.move(to: topLeft)

        oval.addArc(
            center: topCenter,
            radius: arcRadius,
            startAngle: Angle.radians(Double.pi),
            endAngle: Angle.radians(0.0),
            clockwise: false
        )

        oval.addLine(to: bottomRight)

        oval.addArc(
            center: bottomCenter,
            radius: arcRadius,
            startAngle: Angle.radians(0.0),
            endAngle: Angle.radians(Double.pi),
            clockwise: false
        )

        oval.addLine(to: topLeft)

        return oval
    }
}
