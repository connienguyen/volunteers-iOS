import Foundation

extension Int {

    /// - returns: (self, .day)
    var day: (Int, Calendar.Component) {
        return (self, .day)
    }

    /// - returns: (7 * self, .day)
    var week: (Int, Calendar.Component) {
        return (self * 7, .day)
    }

    /// - returns: (self, .month)
    var month: (Int, Calendar.Component) {
        return (self, .month)
    }

    /// - returns: (self, .year)
    var year: (Int, Calendar.Component) {
        return (self, .year)
    }

    /// - returns: (self, .minute)
    var minute: (Int, Calendar.Component) {
        return (self, .minute)
    }

    /// - returns: (self, .second)
    var second: (Int, Calendar.Component) {
        return (self, .second)
    }

    /// - returns: (self, .hour)
    var hour: (Int, Calendar.Component) {
        return (self, .hour)
    }
}

/**
 Adds calendar units to a Date instance

 - parameter date: The date.
 - parameter tuple: The value, time unit tuple

 - returns: `Date`: the date added with the time unit given by argument.
 */

func + (date: Date, tuple: (value: Int, unit: Calendar.Component)) -> Date {
    var components = DateComponents()
    components.setValue(tuple.value, for: tuple.unit)

    return Calendar.current.date(byAdding: components, to: date)!
}

/**
 Adds calendar units to a Date instance

 - parameter date: The date.
 - parameter tuple: The value, time unit tuple

 - returns: `Date`: the date subtracted with the time unit given by argument.
 */

func - (date: Date, tuple: (value: Int, unit: Calendar.Component)) -> Date {
    return date + (-tuple.value, tuple.unit)
}

/// sugar-syntax for +
func += (date: inout Date, tuple: (value: Int, unit: Calendar.Component)) {
    date = date + tuple
}

/// sugar-syntax for -
func -= (date: inout Date, tuple: (value: Int, unit: Calendar.Component)) {
    date = date - tuple
}
