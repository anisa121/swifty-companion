//
//  UserInfoView.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 09.06.2023.
//

import Foundation
import UIKit

/*
 mainStackView
 
 topStackView
 image + bioStackView
 bioStackView:
 login, displayName, mail, level
 
 bottomStackView
 buttonsStackView, listsTableView
 
 listsTableView - projects or skills
 */

protocol UserViewDelegate: AnyObject {
    func achievementButtonTapped()
}

class UserInfoView: UIView, UITableViewDelegate {
    weak var delegate: UserViewDelegate?
    private var currentSelectedCourse: Int = 0
    private var showingProjects: Bool = true
    private var filteredProjects: [Int: [UserInfoDTO.ProjectUser]] = [:]
    
    var dataModel: UserInfoDTO? {
        didSet {
            Task {
                await udpateUI()
            }
        }
    }
    
    private lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var userImageView: UIImageView = {
        let image = UIImage(named: "default.png")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        imageView.layer.shadowRadius = 5
        imageView.layer.shadowOpacity = 0.5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private lazy var achievementsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Check achievements", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        var configuration = UIButton.Configuration.plain()
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 13)
            return outgoing
        }
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        button.configuration = configuration
        return button
    }()
    
    private lazy var bioStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var listsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func udpateUI() async {
        guard let dataModel = dataModel else {
            return
        }
        loginLabel.text = dataModel.login
        displayNameLabel.text = dataModel.displayname
        var selectedCursus = dataModel.cursus.filter { cursus in
            cursus.end_at == nil
        }
        if selectedCursus.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let cursus = dataModel.cursus.max(by: { struct1, struct2 in
                if let date1 = dateFormatter.date(from: struct1.end_at!),
                   let date2 = dateFormatter.date(from: struct2.end_at!) {
                    return date1 < date2
                }
                return false
            }) {
                selectedCursus.append(cursus)
            }
        }
        levelLabel.text = String(selectedCursus[0].level)
        mailLabel.text = String(dataModel.email)
        if let retrieveImage = await dataModel.retrievedImage() {
            userImageView.image = retrieveImage
        }
        for (index, cursus) in dataModel.cursus.enumerated() {
            let button = UIButton()
            button.configuration = .tinted()
            button.tintColor = .systemBlue
            
            button.isHighlighted = true
            button.sizeToFit()
            button.tag = index
            
            button.setTitle(cursus.cursus.name, for: .normal)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            
//            var configuration = UIButton.Configuration.bordered()
//            configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//                var outgoing = incoming
//                outgoing.font = UIFont.systemFont(ofSize: 13)
//                outgoing.foregroundColor = .white
//                return outgoing
//            }
//            configuration.background.backgroundColor = .systemBlue
//            configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
//            button.configuration = configuration
            
            print("Button tag is: \(button.tag)")
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttonsStackView.addArrangedSubview(button)
        }
        if dataModel.staff == true || buttonsStackView.arrangedSubviews.count > 3 {
            buttonsStackView.axis = .vertical
            buttonsStackView.alignment = .leading
        }
        filteredProjects = dataModel.projectsSortedByCourse()
        listsTableView.reloadData()
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if currentSelectedCourse == sender.tag {
            showingProjects.toggle()
        } else {
            currentSelectedCourse = sender.tag
            showingProjects = true
        }
        listsTableView.reloadData()
    }
}

extension UserInfoView {
    private func setupView() {
        if let image = UIImage(named: "background.jpeg") {
            self.backgroundColor = UIColor(patternImage: image)
        } else {
            self.backgroundColor = .white
        }
        self.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(topStackView)
        mainStackView.addArrangedSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor)
        ])
        
        topStackView.addArrangedSubview(userImageView)
        bioStackView.addArrangedSubview(loginLabel)
        bioStackView.addArrangedSubview(displayNameLabel)
        bioStackView.addArrangedSubview(levelLabel)
        bioStackView.addArrangedSubview((mailLabel))
        bioStackView.addArrangedSubview(achievementsButton)
        achievementsButton.addTarget(self, action: #selector(achievementsCheckButtonTapped(_:)), for: .touchUpInside)
        topStackView.addArrangedSubview(bioStackView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 180),
            userImageView.widthAnchor.constraint(equalToConstant: 180)
        ])
        
        bottomStackView.addArrangedSubview(buttonsStackView)
        bottomStackView.addArrangedSubview(listsTableView)

        listsTableView.dataSource = self
        listsTableView.delegate = self
        listsTableView.register(ProjectCell.self, forCellReuseIdentifier: "projectCell")
        listsTableView.register(SkillCell.self, forCellReuseIdentifier: "skillCell")
        listsTableView.separatorStyle = .none
    }
    
    @objc func achievementsCheckButtonTapped(_ sender: UIButton) {
        delegate?.achievementButtonTapped()
    }
}

extension UserInfoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showingProjects == true {
//            for pr in filteredProjects[dataModel!.cursus[currentSelectedCourse].cursus_id] ?? [] {
//                print(pr.cursusID)
//            }
            return filteredProjects[dataModel!.cursus[currentSelectedCourse].cursus_id]?.count ?? 0
        } else {
            return dataModel?.cursus[currentSelectedCourse].skills.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dm = dataModel else {
            return UITableViewCell()
        }
        if showingProjects {
            let cell = listsTableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectCell
            if let projects = filteredProjects[dm.cursus[currentSelectedCourse].cursus_id] {
                let currentProject = projects[indexPath.row]
                cell.configure(name: currentProject.project.name, grade: currentProject.final, status: currentProject.status, isValidated: currentProject.validated)
                cell.selectionStyle = .none
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            let cell = listsTableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillCell
            let currentSkill = dm.cursus[currentSelectedCourse].skills[indexPath.row]
            cell.configure(nameOfSkill: currentSkill.name, levelOfSkill: currentSkill.level)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
