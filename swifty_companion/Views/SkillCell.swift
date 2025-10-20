//
//  SkillCell.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 23.10.2024.
//

import Foundation
import UIKit

class SkillCell: UITableViewCell {
    
    var skillNameLabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var skillLevelLabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    var skillStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSkillCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    func setupSkillCell() {
        self.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(skillStackView)
        skillStackView.addArrangedSubview(skillNameLabel)
        skillStackView.addArrangedSubview(skillLevelLabel)
        NSLayoutConstraint.activate([
            skillStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            skillStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            skillStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            skillStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)])
    }
    
    func configure(nameOfSkill name: String, levelOfSkill level: Double) {
        self.skillNameLabel.text = name
        self.skillLevelLabel.text = String(format: "%.2f", level)
    }
}
