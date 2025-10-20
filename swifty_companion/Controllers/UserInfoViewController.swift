//
//  UserInfoViewController.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 09.06.2023.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController, LoginViewControllerProtocol {
    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView()
        return view
    }()
    
    private var dataModel: UserInfoDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(swipeGesture)
        
        userInfoView.delegate = self
    }
    
    @objc private func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .ended {
            let translation = gesture.translation(in: view)
            if translation.y > 0 {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func passFetchedModel(_ model: UserInfoDTO) {
        userInfoView.dataModel = model
        dataModel = model
    }
}

extension UserInfoViewController: UserViewDelegate {
    func achievementButtonTapped() {
        let achievementsViewController = AchievementsViewController()
        achievementsViewController.dataModel = self.dataModel
        self.present(achievementsViewController, animated: true)
    }
}

extension UserInfoViewController {
    private func setupView() {
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: self.view.topAnchor),
            userInfoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            userInfoView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            userInfoView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
}
