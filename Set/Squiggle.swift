//
//  Squiggle.swift
//  Set
//
//  Created by KaBanks on 4/22/23.
//

import SwiftUI

struct Squiggle : Shape {

    private struct SquiggleRatios {
        static let widthPercentage: CGFloat = 0.15
        static let offsetPercentage: CGFloat = 0.20
        static let controlHorizontalOffsetPercentage: CGFloat = 0.10
        static let verticalControlPercentage: CGFloat = 0.40
    }

    func path(in rect: CGRect) -> Path {
        let topLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * SquiggleRatios.widthPercentage / 2.0),
            y: rect.height * SquiggleRatios.offsetPercentage
        )

        let bottomLeft = CGPoint(
            x: rect.width / 2.0 - (rect.width * SquiggleRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * SquiggleRatios.offsetPercentage)
        )

        let controlLeftOne = CGPoint(
            x: (topLeft.x) + (rect.width * SquiggleRatios.controlHorizontalOffsetPercentage),
            y: rect.height * (SquiggleRatios.verticalControlPercentage)
        )

        let controlLeftTwo = CGPoint(
            x: (topLeft.x) - (rect.width * SquiggleRatios.controlHorizontalOffsetPercentage),
            y: rect.height - (rect.height * SquiggleRatios.verticalControlPercentage)
        )

        let topRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * SquiggleRatios.widthPercentage / 2.0),
            y: rect.height * SquiggleRatios.offsetPercentage
        )

        let bottomRight = CGPoint(
            x: rect.width / 2.0 + (rect.width * SquiggleRatios.widthPercentage / 2.0),
            y: rect.height - (rect.height * SquiggleRatios.offsetPercentage)
        )

        let controlRightOne = CGPoint(
            x: controlLeftTwo.x + (rect.width * SquiggleRatios.widthPercentage),
            y: controlLeftTwo.y
        )

        let controlRightTwo = CGPoint(
            x: controlLeftOne.x + (rect.width * SquiggleRatios.widthPercentage),
            y: controlLeftOne.y
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

        var squiggle = Path()

        squiggle.move(to: bottomLeft)
        squiggle.addCurve(to: topLeft,
                          control1: controlLeftOne,
                          control2: controlLeftTwo)

        squiggle.addArc(
            center: topCenter,
            radius: arcRadius,
            startAngle: Angle.radians(Double.pi),
            endAngle: Angle.radians(0.0),
            clockwise: false
        )

        squiggle.move(to: topRight)
        squiggle.addCurve(
            to: bottomRight,
            control1: controlRightOne,
            control2: controlRightTwo
        )

        squiggle.addArc(
            center: bottomCenter,
            radius: arcRadius,
            startAngle: Angle.radians(0.0),
            endAngle: Angle.radians(Double.pi),
            clockwise: false
        )

        return squiggle
    }
}
