//
//  BunqView.swift
//  Bunq Demo App
//
//  Created by Emre on 14.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import UIKit

protocol BunqViewProtocol: AnyObject {
    func animationFinished()
}

final class BunqView: UIView {
    private var colorLayers: [CALayer] = []
    weak var delegate: BunqViewProtocol?
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           prepare()
       }
       
       required public init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           prepare()
       }
    
    private func prepare() {
        let colorArray = Colors.bunqGreens + Colors.bunqBlues + Colors.bunqRed
        for item in colorArray {
            let col = CALayer()
            col.backgroundColor = item.cgColor
            layer.addSublayer(col)
            colorLayers.append(col)
        }
    }
    
    override func layoutSubviews() {
        for (index,item) in colorLayers.enumerated() {
            let itemWidth = bounds.size.width / CGFloat(colorLayers.count)
            item.frame = CGRect(x: (itemWidth * CGFloat(index)), y: 0, width: itemWidth, height: self.frame.height)
        }
    }
    
    func animateView() {
        var delay = 0.0
        for _ in colorLayers {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if (self.layer.sublayers!.count > 1) {
                    self.layer.sublayers!.last!.removeFromSuperlayer()
                    self.colorLayers.removeLast()
                } else {
                    self.delegate?.animationFinished()
                }
            }
            delay += 0.15
        }
    }
}
