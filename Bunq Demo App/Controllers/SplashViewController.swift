//
//  ViewController.swift
//  Bunq Demo App
//
//  Created by Emre on 1.12.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import PromiseKit
class SplashViewController: UIViewController, SplashViewProtocol {
    
    private var viewModel: SplashViewModel!
    private let horizontalStackView: UIStackView = {
        let s = UIStackView()
        s.distribution = .fillEqually
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private let progressBar: LinearProgressView = {
        let p = LinearProgressView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.barColor = UIColor.white
        p.trackColor = Colors.goodBlue
        p.minimumValue = 0.0
        p.maximumValue = 100.0
        return p
    }()
    private let loadingText: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Printing some money just for you..."
        l.textColor = UIColor.white
        l.font = UIFont.boldSystemFont(ofSize: 20)
        return l
    }()
    
    private let logoImage: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.contentMode = .scaleAspectFit
        l.image = UIImage(named: "somelogo")
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let unwrappedViewModel = SplashViewModel(del: self) {
            self.viewModel = unwrappedViewModel
        } else { fatalError("there is a problem with creating viewModel") }
        prepareUI()
        viewModel.callService { (result) in
            switch result {
            case .success(let userModel):
                print(userModel)
                self.doAnimation()
            case .error(let error):
                print(error)
            }
        }
    }
    
    private func doAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.progressBar.alpha = 0.0
            self.loadingText.alpha = 0.0
            self.logoImage.alpha = 0.0
        }
        var delay = 0.0
        for i in (1..<horizontalStackView.arrangedSubviews.count).reversed() {
            UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.init(), animations: { [unowned self] in
                self.horizontalStackView.arrangedSubviews[i].isHidden = true
                self.horizontalStackView.arrangedSubviews[i].alpha = 0
                self.horizontalStackView.layoutIfNeeded()
                }, completion: { _ in
                    if (i == 1) {
                        //TODO: Make this a class
                        guard let keyWindow = UIApplication.shared.keyWindow else { return }
                        let navController = UINavigationController(rootViewController: MainViewController())
                        navController.isNavigationBarHidden = true
                        navController.navigationBar.isTranslucent = false
                        navController.navigationBar.backgroundColor = Colors.goodBlue
                        keyWindow.rootViewController = navController
                    }
            })
            delay += 0.15
        }
    }
    
    private func prepareUI() {
        //Background
        let bunqRainbowColors = Colors.bunqGreens + Colors.bunqBlues + Colors.bunqRed
        for color in bunqRainbowColors {
            let v = UIView()
            v.backgroundColor = color
            v.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.addArrangedSubview(v)
        }
        view.addSubview(horizontalStackView)
        horizontalStackView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //Logo
        view.addSubview(logoImage)
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -200).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 40).isActive = true
        logoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true

        //Progress Bar
        view.addSubview(progressBar)
        progressBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 15).isActive = true
        progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 100).isActive = true
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        progressBar.alpha = 0.0
        
        view.addSubview(loadingText)
        loadingText.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 10).isActive = true
        loadingText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingText.alpha = 0.0
        
        UIView.animate(withDuration: 1) {
            self.progressBar.alpha = 1.0
            self.loadingText.alpha = 1.0
        }
    }
    
    func updateProgress(with val: Float) {
        progressBar.setProgress(val, animated: true)
    }
    
    deinit {
        print("Splash Deinited")
    }
    
}

