//
//  myCustomSlider.swift
//  PitchPerfect
//
//  Created by 진형탁 on 2017. 1. 12..
//  Copyright © 2017년 Boostcamp. All rights reserved.
//  I quoted this code on http://www.codeauthority.com/Blog/Entry/swift-ios-slider-control

import UIKit

public class myCustomSlider: UISlider {
    
    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: ()->String = { "" }
    
    required public init(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)!
        self.addTarget(self, action: Selector(("onValueChanged:")), for: .valueChanged)
        
    }
    func setup(){
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRectMake(labelXPos,self.frame.origin.y, 200, 25)
        label.text = self.value.description
        self.superview!.addSubview(label)
        
    }
    func updateLabel(){
        label.text = labelText()
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRectMake(labelXPos - label.frame.width/2,self.frame.origin.y, 200, 25)
        label.textAlignment = NSTextAlignment.center
        self.superview!.addSubview(label)
    }
    
    public override func layoutSubviews() {
        labelText = { self.timeFormat(time: self.value) }
        setup()
        updateLabel()
        super.layoutSubviews()
        super.layoutSubviews()
    }
    
    func onValueChanged(sender: myCustomSlider){
        updateLabel()
    }
    
    // CGRectMake to CGRect (Swift2 -> Swift3)
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    // set time formatting
    func timeFormat(time: Float) -> String {
        let minutes = Int(time) / 60
        let seconds = time - Float(minutes) * 60
        let secondsFraction = seconds - Float(Int(seconds))
        return String(format:"%02i:%02i.%01i", minutes, Int(seconds), Int(secondsFraction * 10.0))
    }
}
