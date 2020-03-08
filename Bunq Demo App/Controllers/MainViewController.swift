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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavBarTitleImage()
        view.backgroundColor = Colors.bunqGreens[0]
        view.addSubview(profileView)
        profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
