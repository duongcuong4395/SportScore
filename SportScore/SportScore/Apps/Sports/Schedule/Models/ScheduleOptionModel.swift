//
//  ScheduleOptionModel.swift
//  SportScore
//
//  Created by pc on 15/08/2024.
//

import Foundation


extension ScheduleLeagueModel: ItemOptionsBuilder {
    func getNotify() -> Bool {
        return isNotify ?? false
    }
    
    func getFavorite() -> Bool {
        return isFavorite ?? false
    }
    
    
}
