//
//  ViewController.swift
//  Bunq Demo App
//
//  Created by Emre on 1.12.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit
import PromiseKit
class SplashViewController: UIViewController, SplashViewProtocol, BunqViewProtocol {
    
    private var viewModel: SplashViewModel!

    private let bunqView = BunqView()
    
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
        prepareUI()
        if let unwrappedViewModel = SplashViewModel(del: self) {
            self.viewModel = unwrappedViewModel
        } else { fatalError("there is a problem with creating viewModel") }

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
        bunqView.animateView()
    }
    
    func animationFinished() {
        guard let keyWindow = UIApplication.shared.keyWindow, let unwrappedUserModel = self.viewModel.getUserModel(), let unwrappedAccount = self.viewModel.getBankAccount() else { return }
        let mainViewModel = MainViewModel(userModel: unwrappedUserModel,account: unwrappedAccount)
        let navController = UINavigationController(rootViewController: MainViewController(viewModel: mainViewModel))
        navController.isNavigationBarHidden = true
        navController.navigationBar.isTranslucent = false
        keyWindow.rootViewController = navController
    }
    
    private func prepareUI() {
        //Background
        bunqView.translatesAutoresizingMaskIntoConstraints = false
        bunqView.delegate = self
        view.addSubview(bunqView)
        bunqView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bunqView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bunqView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bunqView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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

