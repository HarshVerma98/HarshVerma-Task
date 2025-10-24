//
//  UIView+Extension.swift
//  HarshVerma-Task
//
//  Created by Harsh Verma on 24/10/25.
//

import UIKit

extension UIView {
    func addRoundedTopBorderToView(cornerRadius: CGFloat,
                                   color: UIColor = .gray,
                                   width: CGFloat = 2) {
        
        layer.sublayers?.filter { $0.name == "perfectTopBorder" }.forEach { $0.removeFromSuperlayer() }
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true

        let path = UIBezierPath()

        let innerRadius = max(cornerRadius - width/2, 0)

        let leftCenter = CGPoint(x: cornerRadius, y: cornerRadius)
        let rightCenter = CGPoint(x: bounds.width - cornerRadius, y: cornerRadius)

        let startPoint = CGPoint(x: 0, y: cornerRadius)
        path.move(to: startPoint)

        path.addArc(
            withCenter: leftCenter,
            radius: innerRadius,
            startAngle: .pi,
            endAngle: .pi * 1.5,
            clockwise: true
        )

        // Top edge
        path.addLine(to: CGPoint(x: bounds.width - cornerRadius, y: width/2))

        // Right rounded corner
        path.addArc(
            withCenter: rightCenter,
            radius: innerRadius,
            startAngle: .pi * 1.5,
            endAngle: 0,
            clockwise: true
        )

        // Create and configure the border layer
        let borderLayer = CAShapeLayer()
        borderLayer.name = "perfectTopBorder"
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = color.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = width

        borderLayer.lineCap = .round
        borderLayer.lineJoin = .round
        borderLayer.allowsEdgeAntialiasing = true
        borderLayer.rasterizationScale = traitCollection.displayScale
        borderLayer.shouldRasterize = true

        borderLayer.frame = bounds
        borderLayer.contentsScale = traitCollection.displayScale

        borderLayer.frame = CGRect(
            x: round(bounds.origin.x * traitCollection.displayScale) / traitCollection.displayScale,
            y: round(bounds.origin.y * traitCollection.displayScale) / traitCollection.displayScale,
            width: round(bounds.width * traitCollection.displayScale) / traitCollection.displayScale,
            height: round(bounds.height * traitCollection.displayScale) / traitCollection.displayScale
        )

        layer.insertSublayer(borderLayer, at: 0)
    }

}

