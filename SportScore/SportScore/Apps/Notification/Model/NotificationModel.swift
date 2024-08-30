//
//  NotificationModel.swift
//  SportScore
//
//  Created by pc on 13/08/2024.
//

import Foundation


struct NotificationModel {
    var id: String
    var title: String
    var body: String
    var subTitle: String?
    var timeInterval: Double?
    var datecomponents: DateComponents?
    var moreData: [AnyHashable: Any]
    var repeats: Bool
    
    //var model
    
    enum ScheduleType {
        case time, calendar
    }
    
    var scheduleType: ScheduleType
    
    internal init(id: String, title: String, body: String
         , timeInterval: Double
         , repeats: Bool
         , moreData: [AnyHashable: Any]) {
        self.id = id
        self.title = title
        self.body = body
        self .scheduleType = .time
        self.timeInterval = timeInterval
        self.datecomponents = nil
        self.repeats = repeats
        self.moreData = moreData
    }
    
    init(id: String, title: String, body: String
         , datecomponents: DateComponents
         , repeats: Bool
         , moreData: [AnyHashable: Any]) {
        self.id = id
        self.title = title
        self.body = body
        self.timeInterval = nil
        self .scheduleType = .calendar
        self.datecomponents = datecomponents
        self.repeats = repeats
        self.moreData = moreData
    }
}
