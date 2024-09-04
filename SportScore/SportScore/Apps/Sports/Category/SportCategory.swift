//
//  SportCategory.swift
//  SportScore
//
//  Created by pc on 30/08/2024.
//

import Foundation

enum SportType: String, Codable, CaseIterable {
    
    case Motorsport = "Motorsport"
    case Soccer = "Soccer"
    case Darts = "Darts"
    case Fighting = "Fighting"
    case Baseball = "Baseball"
    case Basketball = "Basketball"
    case AmericanFootball = "American Football"
    case IceHockey = "Ice Hockey"
    case Golf = "Golf"
    case Rugby = "Rugby"
    case Tennis = "Tennis"
    case Cricket = "Cricket"
    case Cycling = "Cycling"
    case AustralianFootball = "Australian Football"
    case Esports = "ESports"
    case Volleyball = "Volleyball"
    case Netball = "Netball"
    case Handball = "Handball"
    case Snooker = "Snooker"
    case FieldHockey = "Field Hockey"
    case Athletics = "Athletics"
    case Badminton = "Badminton"
    case Climbing = "Climbing"
    case Equestrian = "Equestrian"
    case Gymnastics = "Gymnastics"
    case Shooting = "Shooting"
    case ExtremeSports = "Extreme Sports"
    case TableTennis = "Table Tennis"
    case MultiSports = "Multi Sports"
    case Watersports = "Watersports"
    case Weightlifting = "Weightlifting"
    case Skiing = "Skiing"
    case Skating = "Skating"
    case Wintersports = "Wintersports"
    case Lacrosse = "Lacrosse"
    case Gambling = "Gambling"
}

import CoreData
import SwiftUI

extension SportType{
    func getImageUrl(with selected: Bool = false) -> String {
        let baseURL = "https://www.thesportsdb.com/images/icons/sports/"
        var imageName = ""
        
        switch self {
        case .Motorsport:
            imageName = "motorsport"
        case .Soccer:
            imageName = "soccer"
        case .Darts:
            imageName = "darts"
        case .Fighting:
            imageName = "fighting"
        case .Baseball:
            imageName = "baseball"
        case .Basketball:
            imageName = "basketball"
        case .AmericanFootball:
            imageName = "americanfootball"
        case .IceHockey:
            imageName = "icehockey"
        case .Golf:
            imageName = "golf"
        case .Rugby:
            imageName = "rugby"
        case .Tennis:
            imageName = "tennis"
        case .Cricket:
            imageName = "cricket"
        case .Cycling:
            imageName = "cycling"
        case .AustralianFootball:
            imageName = "australianfootball"
        case .Esports:
            imageName = "esports"
        case .Volleyball:
            imageName = "volleyball"
        case .Netball:
            imageName = "netball"
        case .Handball:
            imageName = "handball"
        case .Snooker:
            imageName = "snooker"
        case .FieldHockey:
            imageName = "fieldhockey"
        case .Athletics:
            imageName = "athletics"
        case .Badminton:
            imageName = "badminton"
        case .Climbing:
            imageName = "climbing"
        case .Equestrian:
            imageName = "equestrian"
        case .Gymnastics:
            imageName = "gymnastics"
        case .Shooting:
            imageName = "shooting"
        case .ExtremeSports:
            imageName = "extremesports"
        case .TableTennis:
            imageName = "tabletennis"
        case .MultiSports:
            imageName = "multisports"
        case .Watersports:
            imageName = "watersports"
        case .Weightlifting:
            imageName = "weightlifting"
        case .Skiing:
            imageName = "skiing"
        case .Skating:
            imageName = "skating"
        case .Wintersports:
            imageName = "wintersports"
        case .Lacrosse:
            imageName = "lacrosse"
        case .Gambling:
            imageName = "gambling"
        }
        
        return baseURL + imageName + (selected ? "-hover" : "") + ".png"
    }
    
    func getEntities() -> [NSManagedObject.Type] {
        switch self {
        case .Motorsport:
            return [ScheduleCD.self]
        case .Soccer:
            return [ScheduleCD.self]
        case .Darts:
            return [ScheduleCD.self]
        case .Fighting:
            return [ScheduleCD.self]
        case .Baseball:
            return [ScheduleCD.self]
        case .Basketball:
            return [ScheduleCD.self]
        case .AmericanFootball:
            return [ScheduleCD.self]
        case .IceHockey:
            return [ScheduleCD.self]
        case .Golf:
            return [ScheduleCD.self]
        case .Rugby:
            return [ScheduleCD.self]
        case .Tennis:
            return [ScheduleCD.self]
        case .Cricket:
            return [ScheduleCD.self]
        case .Cycling:
            return [ScheduleCD.self]
        case .AustralianFootball:
            return [ScheduleCD.self]
        case .Esports:
            return [ScheduleCD.self]
        case .Volleyball:
            return [ScheduleCD.self]
        case .Netball:
            return [ScheduleCD.self]
        case .Handball:
            return [ScheduleCD.self]
        case .Snooker:
            return [ScheduleCD.self]
        case .FieldHockey:
            return [ScheduleCD.self]
        case .Athletics:
            return [ScheduleCD.self]
        case .Badminton:
            return [ScheduleCD.self]
        case .Climbing:
            return [ScheduleCD.self]
        case .Equestrian:
            return [ScheduleCD.self]
        case .Gymnastics:
            return [ScheduleCD.self]
        case .Shooting:
            return [ScheduleCD.self]
        case .ExtremeSports:
            return [ScheduleCD.self]
        case .TableTennis:
            return [ScheduleCD.self]
        case .MultiSports:
            return [ScheduleCD.self]
        case .Watersports:
            return [ScheduleCD.self]
        case .Weightlifting:
            return [ScheduleCD.self]
        case .Skiing:
            return [ScheduleCD.self]
        case .Skating:
            return [ScheduleCD.self]
        case .Wintersports:
            return [ScheduleCD.self]
        case .Lacrosse:
            return [ScheduleCD.self]
        case .Gambling:
            return [ScheduleCD.self]
        }
    }
}


extension SportType {
    func getFieldImage() -> Image {
        switch self {
        case .Soccer, .Motorsport, .Fighting, .Baseball, .Basketball, .AmericanFootball
            , .IceHockey, .Golf, .Rugby, .Tennis, .Cricket, .Cycling, .AustralianFootball
            , .Esports, .Volleyball, .Netball, .Handball, .Snooker, .FieldHockey, .Athletics
            , .Badminton, .Climbing, .Equestrian, .Gymnastics, .Shooting, .ExtremeSports
            , .TableTennis, .MultiSports, .Watersports, .Weightlifting, .Skiing, .Skating
            , .Wintersports, .Lacrosse, .Gambling:
            return Image("\(self.rawValue)_Field")
        default:
            return Image("Soccer_Field")
        }
    }
}
