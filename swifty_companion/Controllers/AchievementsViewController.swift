//
//  AchievementsViewController.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 25.10.2024.
//

import Foundation
import UIKit

class AchievementsViewController: UIViewController {
    let achievementsView = AchievementsView()
    var dataModel: UserInfoDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.view.addSubview(achievementsView)
        achievementsView.dataModel = self.dataModel
        achievementsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            achievementsView.topAnchor.constraint(equalTo: self.view.topAnchor),
            achievementsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            achievementsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            achievementsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}

//extension AchievementsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 300, height: 100)
//    }
//}
