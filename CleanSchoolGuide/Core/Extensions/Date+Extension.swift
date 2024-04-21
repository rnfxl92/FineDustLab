//
//  Date+Extension.swift
//  FineDustLab
//
//  Created by 박성민 on 3/30/24.
//

import Foundation

extension DateFormatter {
    @discardableResult
    public func withDateFormat(_ format: String) -> Self {
        self.dateFormat = format
        return self
    }

    @discardableResult
    public func withTimeZone(_ identifier: String) -> Self {
        self.timeZone = .init(identifier: identifier)
        return self
    }

    @discardableResult
    public func withLocale(_ identifier: String) -> Self {
        self.locale = .init(identifier: identifier)
        return self
    }
}

extension Date {
    // swiftlint:disable identifier_name
    public enum Format: Equatable {
        case server
        case yyyyMMdd
        case ddHH
        case yyMMdd
        case yyMMddahmm
        case yyyyMMddHHmm
        case ahmm
        case yyMMddE
        case yyyyMMdd2
        case MMdd
        case Mdahmm
        case MMddahmm
        case yyyyMM
        case Md
        case E
        case custom(String)

        var value: String? {
            switch self {
            case .server: return nil
            case .yyyyMMdd: return "yyyyMMdd"
            case .ddHH: return "dd:HH"
            case .yyMMdd: return "yy.MM.dd"
            case .yyMMddahmm: return "yy.MM.dd a h:mm"
            case .yyyyMMddHHmm: return "yyyyMMddHHmm"
            case .ahmm: return "a h:mm"
            case .yyMMddE: return "yy.MM.dd(E)"
            case .yyyyMMdd2: return "yyyy.MM.dd"
            case .MMdd: return "MM.dd"
            case .Mdahmm: return "M.d a h:mm"
            case .MMddahmm: return "MM.dd a h:mm"
            case .yyyyMM: return "yyyy.MM"
            case .Md: return "M월 d일"
            case .E: return "E"
            case .custom(let format): return format
            }
        }
    }
    // swiftlint:enable identifier_name
    public func toString(dateFormat format: Format) -> String {
        guard let formatValue = format.value else {
            return ISO8601DateFormatter().string(from: self)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatValue
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        return dateFormatter.string(from: self)
    }
    
    // 2000.01.01 00:00:00
    public static var defaultValue: Date {
        Date(timeIntervalSince1970: 946684800)
    }
    
    public static func + (_ lhs: Date, _ rhs: DateComponents) -> Date? {
        Calendar.current.date(byAdding: rhs, to: lhs)
    }
    
    public static func - (lhs: Date, rhs: Date) -> TimeInterval {
        lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

    // DateComponents + Dates
    public static func + (_ lhs: DateComponents, _ rhs: Date) -> Date? {
        rhs + lhs
    }

    // Date - DateComponents
    public static func - (_ lhs: Date, _ rhs: DateComponents) -> Date? {
        lhs + (-rhs)
    }
}

// MARK: - Comparable
public extension Date {
    var isToday: Bool {
        isSameDay(from: Date())
    }
    
    var isError: Bool {
        timeIntervalSince1970 == 0
    }
    
    func distance(
        from date: Date,
        component: Calendar.Component,
        calendar: Calendar = .current
    ) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func isInADay(from date: Date) -> Bool {
        distance(from: date, component: .day) == 0
    }
    
    func isSameDay(from date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func startOfMonth(using calendar: Calendar = .current) -> Date? {
        calendar.dateComponents([.calendar, .year, .month], from: self).date
    }
    
    func startOfNextMonth(
        using calendar: Calendar = .current
    ) -> Date? {
        guard let startDay = startOfMonth(using: calendar) else { return nil }
        return calendar.date(byAdding: .month, value: 1, to: startDay)
    }
    
    func weekdayValue(using calendar: Calendar = .current) -> Int {
        calendar.component(.weekday, from: self)
    }
    
    func weekday() -> WeekDay? {
        WeekDay(rawValue: weekdayValue())
    }
    
    enum WeekDay: Int, CaseIterable {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        public var localizedString: String {
            switch self {
            case .sunday: return "일"
            case .monday: return "월"
            case .tuesday: return "화"
            case .wednesday: return "수"
            case .thursday: return "목"
            case .friday: return "금"
            case .saturday: return "토"
            }
        }
    }
}

extension Date {
    public func getYearsAgo(targetAge: Int, month: Int, day: Int) -> Int? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)

        var dateComponents = DateComponents()
        dateComponents.year = year

        guard let date = calendar.date(from: dateComponents) else {
            return nil
        }

        let currentMonth = calendar.component(.month, from: Date())
        let currentDay = calendar.component(.day, from: Date())

        if let yearsAgo = calendar.date(byAdding: .year, value: -targetAge, to: date) {
            var year = calendar.component(.year, from: yearsAgo)
            if (month, day) > (currentMonth, currentDay) {
                year -= 1
            }
            return year
        } else {
            return nil
        }
    }

    public func getYearsAgoFirstDate(targetYear: Int) -> Date? {
        let calendar = Calendar.current
        if let dateYearsAgo = Calendar.current.date(byAdding: .year, value: -targetYear, to: self) {
            var components = calendar.dateComponents([.year], from: dateYearsAgo)
            components.month = 1
            components.day = 1
            return calendar.date(from: components) ?? "18740101".toDate(format: .yyyyMMdd)
        } else {
            return "18740101".toDate(format: .yyyyMMdd)
        }
    }
    
    static func getWeekdaysAndNextMonday() -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 날짜를 기준으로 이번 주 월요일을 찾습니다.
        guard let sundayThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return dates
        }
        
        // 이번 주 월요일부터 금요일까지의 날짜를 계산하여 배열에 추가합니다.
        for dayOffset in 0..<6 {
            if let weekday = calendar.date(byAdding: .day, value: dayOffset, to: sundayThisWeek) {
                dates.append(weekday)
            }
        }
        
        // 다음 주 월요일의 날짜를 계산하여 배열에 추가합니다.
        if let nextMonday = calendar.date(byAdding: .day, value: 8, to: sundayThisWeek) {
            dates.append(nextMonday)
        }
        
        return dates
    }
    
    static func isInTheSameWeek(as compareDate: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 날짜와 비교할 날짜의 '년도'와 '주' 값을 가져옵니다.
        let currentWeek = calendar.component(.weekOfYear, from: now)
        let currentYear = calendar.component(.yearForWeekOfYear, from: now)
        
        let compareWeek = calendar.component(.weekOfYear, from: compareDate)
        let compareYear = calendar.component(.yearForWeekOfYear, from: compareDate)
        
        // 년도와 주가 모두 일치하는지 확인합니다.
        return currentYear == compareYear && currentWeek == compareWeek
    }
    
    static func isWeekend(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7
    }
}

extension Date {
    public var yearMonthDayHourMinute: Date? {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self))
    }
}

prefix func - (components: DateComponents) -> DateComponents {
  var result = DateComponents()
  if components.nanosecond != nil { result.nanosecond = -(components.nanosecond ?? 0) }
  if components.second != nil { result.second = -(components.second ?? 0) }
  if components.minute != nil { result.minute = -(components.minute ?? 0) }
  if components.hour != nil { result.hour = -(components.hour ?? 0) }
  if components.day != nil { result.day = -(components.day ?? 0) }
  if components.weekOfYear != nil { result.weekOfYear = -(components.weekOfYear ?? 0) }
  if components.month != nil { result.month = -(components.month ?? 0) }
  if components.year != nil { result.year = -(components.year ?? 0) }
  return result
}

prefix func + (components: DateComponents) -> DateComponents {
  var result = DateComponents()
  if components.nanosecond != nil { result.nanosecond = (components.nanosecond ?? 0) }
  if components.second != nil { result.second = (components.second ?? 0) }
  if components.minute != nil { result.minute = (components.minute ?? 0) }
  if components.hour != nil { result.hour = (components.hour ?? 0) }
  if components.day != nil { result.day = (components.day ?? 0) }
  if components.weekOfYear != nil { result.weekOfYear = (components.weekOfYear ?? 0) }
  if components.month != nil { result.month = (components.month ?? 0) }
  if components.year != nil { result.year = (components.year ?? 0) }
  return result
}
