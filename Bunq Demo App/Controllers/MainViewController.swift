//
//  MainViewController.swift
//  Bunq Demo App
//
//  Created by Emre on 1.03.2020.
//  Copyright © 2020 Emre. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    private let profileView = ProfileView()
    private var viewModel: MainViewModel
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavBarTitleImage()
        setupUI()
        setTexts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = Colors.bunqGreens[0]
        view.addSubview(profileView)
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupNavBarTitleImage() {
        let logoImage = UIImage(named: "somelogo")?.withRenderingMode(.alwaysTemplate)
        let titleImageView = UIImageView(image: logoImage)
        titleImageView.tintColor = UIColor.black
        titleImageView.frame = CGRect(x: 0, y: 0, width: 82, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setTexts() {
        profileView.nameLabel.text = viewModel.alias
        profileView.dailyLimitLbl.text = viewModel.dailyLimit
        profileView.accountBalanceLbl.text = viewModel.accountBalance
        profileView.descriptionLbl.text = viewModel.description
        profileView.ibanLbl.text = viewModel.iban
    }
    
}
