import Foundation

/// Logging Wrapper.
class Logger {
    /// Logs Info messages
    class func Info(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.Write("INFO", msg: message, function: function, path: path, line: line)
    }

    /// Logs Warning messages
    class func Warn(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.Write("WARN", msg: message, function: function, path: path, line: line)
    }

    /// Logs Error messages
    class func Error(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.Write("ERRO", msg: message, function: function, path: path, line: line)
    }

    class private func Write(_ prefix: String, msg: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        #if DEBUG

        var file = NSURL(fileURLWithPath: path).lastPathComponent!.description
        file = file.substring(to: file.characters.index(of: ".")!)
        let location = [file, function, line.description].joined(separator: "::")
        
        print("[\(prefix.uppercased())] - \(location) \t\(msg)")

        #endif
    }
}
