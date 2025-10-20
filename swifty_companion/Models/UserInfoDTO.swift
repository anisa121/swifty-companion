//
//  UserInfoDTO.swift
//  swifty_companion
//
//  Created by Anisa Kapateva on 24.04.2024.
//

import Foundation
import UIKit

// CURSUS_IDS
// 21 (42cursus), 1 (42), 4 (piscine-c)
// 1 4 21
// status: finished, in_progress, searching_a_group

struct UserInfoDTO: Decodable {
    let login: String
    let displayname: String
    let correctionPoints: Int
    let email: String
    let cursus: [CursusUser]
    let projects: [ProjectUser]
    let image: ImageInfo
    let staff: Bool
    let achievements: [AchievementsStruct]
    
    struct AchievementsStruct: Decodable {
        let visible: Bool
        let image: String
        let name: String
        let description: String
        let tier: String
    }
    
    struct ImageInfo: Decodable {
        let link: String?
        let versions: ImgVersions
        struct ImgVersions: Decodable {
            let large: String?
            let medium: String?
            let small: String?
        }
    }
    
    struct ProjectUser: Decodable {
        let id: Int
        let final: Int?
        let validated: Bool?
        let cursusID: [Int]
        let status: StatusProject
        enum StatusProject: String, Decodable {
            case in_progress
            case finished
            case searching_a_group
            case waiting_for_correction
            case parent
            case creating_group
        }
        
        let project: ProjectInfo            //only for the name of the project
        struct ProjectInfo: Decodable {
            let name: String
        }
        
        enum CodingKeys: String, CodingKey {
            case final = "final_mark"
            case project
            case id
            case validated = "validated?"
            case status
            case cursusID = "cursus_ids"
        }
    }
    
    struct CursusUser: Decodable {
        let id: Int
        let level: Double
        let end_at: String?
        let cursus_id: Int
        
        let skills: [SkillInfo]
        struct SkillInfo: Decodable {
            let name: String
            let level: Double
        }
        
        let cursus: CursusInfo
        struct CursusInfo: Decodable {
            let name: String
        }
    }
    
    func retrievedImage() async -> UIImage? {
        guard let imageStr = image.versions.medium,
              let imageURL = URL(string: imageStr) else {
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            return UIImage(data: data)
        } catch let error{
            print(error)
            return nil
        }
    }
    
    func projectsSortedByCourse() -> [Int:[ProjectUser]] {
        var sortedProjects :[Int:[ProjectUser]] = [:]
        for project in projects {
            if sortedProjects[project.cursusID[0]] != nil {
                sortedProjects[project.cursusID[0]]?.append(project)
            } else {
                sortedProjects[project.cursusID[0]] = [project]
            }
        }
        return sortedProjects
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case displayname
        case login
        case correctionPoints = "correction_point"
        case cursus = "cursus_users"
        case projects = "projects_users"
        case image
        case staff = "staff?"
        case achievements
    }
}
