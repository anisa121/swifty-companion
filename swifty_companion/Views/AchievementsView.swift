//
//  AchievementsView.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 25.10.2024.
//

import UIKit
import Foundation

class AchievementsView: UIView, UICollectionViewDelegate {
    var dataModel: UserInfoDTO? {
        didSet {
            updateUI()
        }
    }
        
    var achievementCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateUI() {
        achievementCollectionView.reloadData()
    }
}

extension AchievementsView {
    func setupSubViews() {
        achievementCollectionView.delegate = self
        achievementCollectionView.dataSource = self
        achievementCollectionView.register(AchievementCollectionViewCell.self, forCellWithReuseIdentifier: "achievementCell")
        self.addSubview(achievementCollectionView)
        NSLayoutConstraint.activate([
            achievementCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            achievementCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            achievementCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            achievementCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        achievementCollectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension AchievementsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dm = dataModel else {
            return 0
        }
        return dm.achievements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = achievementCollectionView.dequeueReusableCell(withReuseIdentifier: "achievementCell", for: indexPath) as? AchievementCollectionViewCell, let dm = dataModel else {
            return UICollectionViewCell()
        }
        let currentAchiv = dm.achievements[indexPath.row]
        cell.configure(name: currentAchiv.name, description: currentAchiv.description, image: currentAchiv.image, tier: currentAchiv.tier)
        return cell
    }
}

extension AchievementsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 16
        let edgeInsets: CGFloat = 5 * 2
        let width = (collectionView.bounds.width - totalSpacing - edgeInsets) / 2
        let height: CGFloat = 100

        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
