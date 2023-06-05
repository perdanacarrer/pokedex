//
//  UIView+Ext.swift
//  pokedex
//
//  Created by oscar perdana on 03/06/23.
//

import Foundation
import UIKit

public typealias Closure = () -> ()

class ClosureSleeve {
    let closure: Closure
    init(_ closure: @escaping Closure) {
        self.closure = closure
    }
    @objc func invoke () {
        closure()
    }
}

extension UIView {
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping Closure) {
        let sleeve = ClosureSleeve(closure)
        let gesture = UITapGestureRecognizer(target: sleeve, action: #selector(ClosureSleeve.invoke))
        gesture.numberOfTapsRequired = 1
        addGestureRecognizer(gesture)
        isUserInteractionEnabled = true
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func blink() {
         self.alpha = 0.0;
         UIView.animate(withDuration: 0.5, //Time duration you want,
             delay: 0.0,
             options: [.curveEaseInOut, .autoreverse, .repeat],
             animations: { [weak self] in self?.alpha = 1.0 },
             completion: { [weak self] _ in self?.alpha = 0.0 })
     }

    func stopBlink() {
         layer.removeAllAnimations()
         alpha = 1
     }
    
    public func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// this is section to curve border on 4 corner of view
extension UIView {
    private struct Properties {

        static var _radius: CGFloat = 0.0
        static var _color: UIColor = .red
        static var _strokeWidth: CGFloat = 1.0
        static var _length: CGFloat = 20.0

    }

    private var radius: CGFloat {
        get {
            return Properties._radius
        }
        set {
            Properties._radius = newValue
        }
    }

    private var color: UIColor {
        get {
            return Properties._color
        }
        set {
            Properties._color = newValue
        }
    }

    private var strokeWidth: CGFloat {
        get {
            return Properties._strokeWidth
        }
        set {
            Properties._strokeWidth = newValue
        }
    }

    private var length: CGFloat {
        get {
            return Properties._length
        }
        set {
            Properties._length = newValue
        }
    }

    public func drawCorners(radius: CGFloat? = nil, color: UIColor? = nil, strokeWidth: CGFloat? = nil, length: CGFloat? = nil) {
        if let radius = radius {
            self.radius = radius
        }
        if let color = color {
            self.color = color
        }
        if let strokeWidth = strokeWidth {
            self.strokeWidth = strokeWidth
        }
        if let length = length {
            self.length = length
        }
        createTopLeft()
        createTopRight()
        createBottomLeft()
        createBottomRight()
    }

    private func createTopLeft() {
        let topLeft = UIBezierPath()
        topLeft.move(to: CGPoint(x: strokeWidth/2, y: radius+length))
        topLeft.addLine(to: CGPoint(x: strokeWidth/2, y: radius))
        topLeft.addQuadCurve(to: CGPoint(x: radius, y: strokeWidth/2), controlPoint: CGPoint(x: strokeWidth/2, y: strokeWidth/2))
        topLeft.addLine(to: CGPoint(x: radius+length, y: strokeWidth/2))
        setupShapeLayer(with: topLeft)
    }

    private func createTopRight() {
        let topRight = UIBezierPath()
        topRight.move(to: CGPoint(x: bounds.width-radius-length, y: strokeWidth/2))
        topRight.addLine(to: CGPoint(x: bounds.width-radius, y: strokeWidth/2))
        topRight.addQuadCurve(to: CGPoint(x: bounds.width-strokeWidth/2, y: radius), controlPoint: CGPoint(x: bounds.width-strokeWidth/2, y: strokeWidth/2))
        topRight.addLine(to: CGPoint(x: bounds.width-strokeWidth/2, y: radius+length))
        setupShapeLayer(with: topRight)
    }

    private func createBottomRight() {
        let bottomRight = UIBezierPath()
        bottomRight.move(to: CGPoint(x: bounds.width-strokeWidth/2, y: frame.height-radius-length))
        bottomRight.addLine(to: CGPoint(x: bounds.width-strokeWidth/2, y: frame.height-radius))
        bottomRight.addQuadCurve(to: CGPoint(x: bounds.width-radius, y: frame.height-strokeWidth/2), controlPoint: CGPoint(x: frame.width-strokeWidth/2, y: bounds.height-strokeWidth/2))
        bottomRight.addLine(to: CGPoint(x: bounds.width-radius-length, y: frame.height-strokeWidth/2))
        setupShapeLayer(with: bottomRight)
    }

    private func createBottomLeft() {
        let bottomLeft = UIBezierPath()
        bottomLeft.move(to: CGPoint(x: radius+length, y: bounds.height-strokeWidth/2))
        bottomLeft.addLine(to: CGPoint(x: radius, y: bounds.height-strokeWidth/2))
        bottomLeft.addQuadCurve(to: CGPoint(x: strokeWidth/2, y: bounds.height-radius), controlPoint: CGPoint(x: strokeWidth/2, y: frame.height-strokeWidth/2))
        bottomLeft.addLine(to: CGPoint(x: strokeWidth/2, y: bounds.height-radius-length))
        setupShapeLayer(with: bottomLeft)
    }

    private func setupShapeLayer(with path: UIBezierPath) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = strokeWidth
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }

}

