//
//  RFProgressView.swift
//  RFSwiftRadialProgress
//
//  Created by Rich Fellure on 5/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

protocol RFProgressViewDelegate {
    func progressViewStartingValue(view: RFProgressView)-> CGFloat
    func progressViewTotalValue(view: RFProgressView)-> CGFloat
}

@IBDesignable class RFProgressView: UIView {


    @IBInspectable var circleWidth : CGFloat = 1.0
    @IBInspectable var circleColor : UIColor = UIColor.blackColor()
    @IBInspectable var continuous : Bool = false
    @IBInspectable var currentValue : CGFloat = 1.0
    @IBInspectable var totalValue : CGFloat = 1.0

    @IBInspectable var hidesInsetCircle: Bool = false
    @IBInspectable var insetCircleColor: UIColor = UIColor.blackColor()
    @IBInspectable var insetCircleWidth: CGFloat = 1.0

    @IBInspectable var titleLabelTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var titleLabelFontSize: CGFloat = 17.0
    @IBInspectable var titleLabelBackgroundColor: UIColor = UIColor.clearColor()
    @IBInspectable var titleLabelText: String = ""

    var mainLabel : UILabel!

    var delegate : RFProgressViewDelegate!
    private var filling : Bool!
    private var progressLayer : CAShapeLayer!
    private var percentComplete : CGFloat!
    private var isIB : Bool!

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        self.drawCircles()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.drawTitleLabel()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.isIB = true;
        self.drawTitleLabel()
    }

    func changeProgressToValue(value: CGFloat, andWithAnimationDuration duration: CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = Double(duration)
        let startingPercentage = self.percentComplete
        self.percentComplete = value/self.totalValue
        basicAnimation.toValue = NSNumber(double: Double(self.percentComplete))
        basicAnimation.fromValue = NSNumber(double: Double(startingPercentage))
        basicAnimation.fillMode = kCAFillModeBoth
        basicAnimation.removedOnCompletion = false
        progressLayer.addAnimation(basicAnimation, forKey: nil)
        self.mainLabel.text = "\(value)"
    }

    //Draws in the circles according to what is provided in IB
    private func drawCircles() {
        let startingAngle = CGFloat(M_PI * 1.5)
        let endAngle = startingAngle + CGFloat(CGFloat(M_PI * 2))

        self.currentValue = isIB == true ? self.currentValue : self.delegate.progressViewStartingValue(self)
        self.totalValue = isIB == true ? self.totalValue : self.delegate.progressViewTotalValue(self)

        let circlePath = UIBezierPath()
        let center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)
        circlePath.addArcWithCenter(center,
            radius: CGRectGetWidth(self.frame)/2 - self.circleWidth/2,
            startAngle: startingAngle,
            endAngle: endAngle,
            clockwise: true)

        self.progressLayer = CAShapeLayer()


        if hidesInsetCircle == false {
//            let insetCirclePath = UIBezierPath()
//            insetCirclePath.addArcWithCenter(center,
//                radius: CGRectGetWidth(self.frame) / 2 - self.circleWidth / 2 - self.insetCircleWidth / 2,
//                startAngle: startingAngle ,
//                endAngle: endAngle,
//                clockwise: true)
            let insetLayer = CAShapeLayer()
            self.addLayer(insetLayer, toPath: circlePath, withStrokeColor: self.insetCircleColor, lineWidth: self.insetCircleWidth, complete: self.totalValue)

        }

//        let complete = isIB ? self.currentValue : 

        self.addLayer(self.progressLayer, toPath: circlePath, withStrokeColor: self.circleColor, lineWidth: self.circleWidth, complete: self.currentValue)
    }

    private func addLayer(layer: CAShapeLayer, toPath path: UIBezierPath, withStrokeColor color: UIColor, lineWidth: CGFloat, complete: CGFloat) {
        layer.path = path.CGPath
        layer.strokeColor = self.circleColor.CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineWidth = self.circleWidth
        layer.strokeStart = 0.0
        layer.strokeEnd = complete/self.totalValue
        self.layer.addSublayer(progressLayer)
    }

    //Adds the MainLabel to the View
    private func drawTitleLabel() {
        let width = CGRectGetWidth(self.frame)/2
        let height = CGRectGetWidth(self.frame)/2
        mainLabel = UILabel(frame: CGRectMake(width/2, height/2, width, height))
        mainLabel.text = self.titleLabelText
        mainLabel.backgroundColor = self.titleLabelBackgroundColor
        mainLabel.textColor = self.titleLabelTextColor
        mainLabel.font = UIFont(name: "HelveticaNeue", size: self.titleLabelFontSize)
        mainLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(mainLabel)
    }

}








