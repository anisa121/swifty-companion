//
//  ProjectCell.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 23.10.2024.
//

import Foundation
import UIKit

class ProjectCell: UITableViewCell {
    var namelabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        return label
    }()
    
    var statusLabel: UILabel = {
        var label = UILabel()
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.textAlignment = .left
        label.backgroundColor = .white
        label.clipsToBounds = true
        label.textColor = .black
        return label
    }()
    
    var finalMarkLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .right
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.isHidden = false
        return label
    }()
    
    var gradeStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    var projectStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupProjectCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    func setupProjectCell() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.cornerRadius = 6
        contentView.layer.masksToBounds = true
        self.backgroundColor = .clear
        
        contentView.addSubview(projectStackView)
        gradeStackView.addArrangedSubview(statusLabel)
        gradeStackView.addArrangedSubview(finalMarkLabel)
        projectStackView.addArrangedSubview(namelabel)
        projectStackView.addArrangedSubview(gradeStackView)
                
        NSLayoutConstraint.activate([
            projectStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            projectStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            projectStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            projectStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    func configure(name nameProject: String, grade finalMark: Int?, status statusProject: UserInfoDTO.ProjectUser.StatusProject, isValidated validated: Bool?) {
        self.namelabel.text = nameProject
        finalMarkLabel.isHidden = false
        if let mark = finalMark {
            self.finalMarkLabel.text = String(mark)
        } else {
            self.finalMarkLabel.isHidden = true
        }
        self.statusLabel.text = String(describing: statusProject)
        if let isValidated = validated {
            self.finalMarkLabel.backgroundColor = isValidated ? .green : UIColor(red: 1.0, green: 0.7, blue: 0.7, alpha: 1.0)
        }
    }
}
