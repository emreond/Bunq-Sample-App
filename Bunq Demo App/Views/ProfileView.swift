//
//  ProfileView.swift
//  Bunq Demo App
//
//  Created by Emre on 7.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import Foundation
import UIKit

class ProfileView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var accountBalanceLbl: UILabel!
    @IBOutlet weak var ibanLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dailyLimitLbl: UILabel!
    @IBOutlet weak var reqMoneyBtn: UIButton!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.translatesAutoresizingMaskIntoConstraints = false
        //layer.applySketchShadow(color: UIColor(red:0.56, green:0.56, blue:0.56, alpha:1), alpha: 0.2, x: 0, y: 0, blur: 10, spread: 0)
        
        // first: load the view hierarchy to get proper outlets
        let name = String(describing: type(of: self))
        let nib = UINib(nibName: name, bundle: .main)
        nib.instantiate(withOwner: self, options: nil)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = Colors.bunqGreens[0]
        addSubview(contentView)
        contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        accountView.layer.cornerRadius = 6.0
        reqMoneyBtn.layer.cornerRadius = 6.0
    }

}
