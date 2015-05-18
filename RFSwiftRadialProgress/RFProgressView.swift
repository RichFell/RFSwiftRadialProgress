//
//  RFProgressView.swift
//  RFSwiftRadialProgress
//
//  Created by Rich Fellure on 5/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

import UIKit

@IBDesignable class RFProgressView: UIView {

    @IBInspectable var percentComplete : CGFloat = 0.85
    @IBInspectable var circleWidth : CGFloat = 1.0
    @IBInspectable var circleColor : UIColor = UIColor.blackColor()

    @IBInspectable var hidesInsetCircle: Bool = false
    @IBInspectable var insetCircleColor: UIColor = UIColor.blackColor()
    @IBInspectable var insetCircleWidth: CGFloat = 1.0

    @IBInspectable var titleLabelTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var titleLabelFontSize: CGFloat = 17.0
    @IBInspectable var titleLabelBackgroundColor: UIColor = UIColor.clearColor()
    @IBInspectable var titleLabelText: String = ""

    var mainLabel : UILabel!


    private var progressLayer : CAShapeLayer!

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
        self.drawTitleLabel()
    }

    func changeProgressByNominator(numerator: CGFloat, byDenominator denominator: CGFloat, andWithAnimationDuration duration: CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = Double(duration)
        basicAnimation.toValue = NSNumber(double: Double(numerator/denominator))
        basicAnimation.fromValue = NSNumber(double: Double(self.percentComplete))
        basicAnimation.fillMode = kCAFillModeBoth
        basicAnimation.removedOnCompletion = false
        progressLayer.addAnimation(basicAnimation, forKey: nil)
        self.percentComplete = numerator/denominator
        self.mainLabel.text = "\(numerator)"
    }

    //Draws in the circles according to what is provided in IB
    private func drawCircles() {
        let startingAngle = CGFloat(M_PI * 1.5)
        let endAngle = startingAngle + CGFloat(CGFloat(M_PI * 2))

        let circlePath = UIBezierPath()
        let center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2)
        circlePath.addArcWithCenter(center,
            radius: CGRectGetWidth(self.frame)/2 - self.circleWidth/2,
            startAngle: startingAngle,
            endAngle: endAngle,
            clockwise: true)

        self.progressLayer = CAShapeLayer()
        self.progressLayer.path = circlePath.CGPath
        self.progressLayer.strokeColor = self.circleColor.CGColor
        self.progressLayer.fillColor = UIColor.clearColor().CGColor
        self.progressLayer.lineWidth = self.circleWidth
        self.progressLayer.strokeStart = 0.0
        self.progressLayer.strokeEnd = self.percentComplete > 1.0 ? self.percentComplete/100 : self.percentComplete
        self.layer.addSublayer(progressLayer)

        if hidesInsetCircle == false {
            let insetCirclePath = UIBezierPath()
            insetCirclePath.addArcWithCenter(center,
                radius: CGRectGetWidth(self.frame) / 2 - self.circleWidth / 2 - self.insetCircleWidth / 2,
                startAngle: startingAngle ,
                endAngle: endAngle,
                clockwise: true)
            insetCirclePath.lineWidth = self.insetCircleWidth
            self.insetCircleColor.setStroke()
            insetCirclePath.stroke()
        }
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








