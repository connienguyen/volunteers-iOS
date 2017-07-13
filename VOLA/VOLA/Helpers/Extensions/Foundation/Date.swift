import Foundation

extension Date {

    /// Retrieves the month.
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// Retrieves the day.
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// Retrieves the day of the week.
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    /// Retrieves the year
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// Retrieves the week
    var week: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// Retrieves the hour
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// Retrieves the minutes
    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }

    /// Retrieves the start day of the current month
    var startOfCurrentMonth: Date {
        return Date.from(year: year, month: month, day: 1)
    }

    /// Retrieves the end day of the current month
    var endOfCurrentMonth: Date {
        return (Date.from(year: year, month: month, day: 1) + 1.month - 1.minute)
    }

    /// Retrieves the start of the day (using startOfDayForDate)
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /// Retrieves the end of the day (23:59:59)
    var endOfDay: Date {
        return startOfDay + 1.day - 1.second
    }

    /// Retrieves the start of the week
    var startOfWeek: Date {
        return (self - weekday.day).startOfDay
    }

    /// Retrieves the end of the week
    var endOfWeek: Date {
        return startOfWeek + 7.day - 1.minute
    }

    /// Checks if it is yesterday
    var isYesterday: Bool {
        return sameDayAs(Date() - 1.day)
    }

    /// Checks if it is this minute
    var isThisMinute: Bool {
        return sameMinuteAs(Date())
    }

    /// Checks if it is this hour
    var isThisHour: Bool {
        return sameHourAs(Date())
    }

    /// Checks if it is today
    var isToday: Bool {
        return sameDayAs(Date())
    }

    /// Checks if it is tomorrow
    var isTomorrow: Bool {
        return sameDayAs(Date() + 1.day)
    }

    /// Check if date is in the future.
    var isFuture: Bool {
        return self > Date()
    }

    /// Check if date is in past.
    var isPast: Bool {
        return self < Date()
    }

    /// Checks if it is this week
    var isThisWeek: Bool {
        return sameWeekAs(Date())
    }

    /// Checks if it is this month
    var isThisMonth: Bool {
        return sameMonthAs(Date())
    }

    /// Checks if it is this year
    var isThisYear: Bool {
        return sameYearAs(Date())
    }

    /**
     Returns a new customized date.
     By default, the hour will be set to 00:00.

     - parameter year: The year.
     - parameter month: The month.
     - parameter day: The day.
     - parameter hour: The hour (defaults 0).
     - parameter minute: The minute (defaults 0).

     - returns: The desired `Date`
     */

    static func from(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        c.hour = hour
        c.minute = minute

        return Calendar.current.date(from: c)!
    }

    /**
     Returns a string according in the format given by argument.

     - parameter format: The string format (default dd-MMMM-yyyy HH:mm)

     - returns: The date formated
     */

    func formatWith(format: String = "dd-MMMM-yyyy HH:mm", local: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale =  local
        return formatter.string(from: self)
    }

    /// Checks if happens months before the date given as argument.
    func happensMonthsBefore(_ date: Date) -> Bool {
        return (year < date.year) || (year == date.year && month < date.month)
    }

    /// Checks if happens months after the date given as argument.
    func happensMonthsAfter(_ date: Date) -> Bool {
        return (year > date.year) || (year == date.year && month > date.month)
    }

    /// Checks if  if both dates represents the same day (day, month and year).
    func sameDayAs(_ dateTwo: Date) -> Bool {
        return year == dateTwo.year && month == dateTwo.month && day == dateTwo.day
    }

    /// Checks if both dates belong in the same week. Also takes into account year transition
    func sameWeekAs(_ dateTwo: Date) -> Bool {
        return (year == dateTwo.year && week == dateTwo.week) || startOfWeek.sameDayAs(dateTwo.startOfWeek)
    }

    /// Checks if both dates dates belong to the same month and year
    func sameMonthAs(_ dateTwo: Date) -> Bool {
        return (year == dateTwo.year && month == dateTwo.month)
    }

    /// Checks if both dates dates belong to the same year
    func sameYearAs(_ dateTwo: Date) -> Bool {
        return year == dateTwo.year
    }

    /// Checks if both dates dates have the same clock time
    func sameClockTimeAs(_ dateTwo: Date) -> Bool {
        return hour == dateTwo.hour && minutes == dateTwo.minutes
    }

    /// Checks if both dates occur at the same hour on the the same day
    func sameHourAs(_ dateTwo: Date) -> Bool {
        return sameDayAs(dateTwo) && hour == dateTwo.hour
    }

    /// Checks if both dates occur at the same minute on the same day
    func sameMinuteAs(_ dateTwo: Date) -> Bool {
        return sameDayAs(dateTwo) && minutes == dateTwo.minutes
    }
}

func -(lhs: Date, rhs: Date) -> DateRange {
    return DateRange(startDate: rhs, endDate: lhs)
}

struct DateRange {
    let startDate: Date
    let endDate: Date

    var timeInterval: TimeInterval {
        return startDate.timeIntervalSince(endDate)
    }

    var seconds: Int {
        return Calendar.current.dateComponents([.second], from: startDate, to: endDate).second!
    }
    
    var minutes: Int {
        return Calendar.current.dateComponents([.minute], from: startDate, to: endDate).minute!
    }
    
    var hours: Int {
        return Calendar.current.dateComponents([.hour], from: startDate, to: endDate).hour!
    }
    
    var days: Int {
        return Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
    }
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
