//
//  AchievementCollectionViewCell.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 28.10.2024.
//

import UIKit
import Foundation

private enum TierColours {
    case gold
    case silver
    case bronze
    
    var color: UIColor {
        switch self {
        case .gold:
            return UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
        case .silver:
            return UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
        case .bronze:
            return UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        }
    }
}

class AchievementCollectionViewCell: UICollectionViewCell {
    
    var nameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var tierButton: UIButton = {
        let button = UIButton()
        button.setTitle("tier", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        button.setTitleColor(.white, for: .disabled)
        button.clipsToBounds = true
        var configuration = UIButton.Configuration.plain()
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.italicSystemFont(ofSize: 10)
            return outgoing
        }
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        button.configuration = configuration
        button.isHidden = true
        return button
    }()
    
    var spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented - collectionviewcell")
    }
    
    func setupCell() {
        contentView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(tierButton)
        mainStackView.addArrangedSubview(spacerView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
    }
    
    func customizeTierButton(tier: String) {
        // if-else and not enum in the dataModel, because wasn't sure about possible cases of responce
        if tier.contains("easy") {
            tierButton.isHidden = false
            spacerView.isHidden = true
            tierButton.setTitle("bronze", for: .normal)
            tierButton.backgroundColor = TierColours.bronze.color
        } else if tier.contains("medium") {
            tierButton.isHidden = false
            spacerView.isHidden = true
            tierButton.setTitle("silver", for: .normal)
            tierButton.backgroundColor = TierColours.silver.color
        } else if tier.contains("hard") {
            tierButton.isHidden = false
            spacerView.isHidden = true
            tierButton.setTitle("gold", for: .normal)
            tierButton.backgroundColor = TierColours.gold.color
        }
    }
    
    func configure(name: String, description: String, image: String, tier: String) {
        nameLabel.text = name
        descriptionLabel.text = description
        customizeTierButton(tier: tier)
//        imageLoader.loadImage(from: image) {  [weak self] image in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.imageView.image = image
//                print("MI TUT")
//            }
//        }
        
    }
}
