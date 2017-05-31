import Foundation

/// Logging Wrapper.
class Logger {
    /// Logs Info messages
    static func info(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.write("INFO", msg: message, function: function, path: path, line: line)
    }

    /// Logs Warning messages
    static func warn(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.write("WARN", msg: message, function: function, path: path, line: line)
    }

    /// Logs Error messages
    static func error(_ message: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        Logger.write("ERRO", msg: message, function: function, path: path, line: line)
    }

    static private func write(_ prefix: String, msg: CustomStringConvertible, function: String = #function, path: String = #file, line: Int = #line) {
        #if DEBUG

        var file = NSURL(fileURLWithPath: path).lastPathComponent!.description
        file = file.substring(to: file.characters.index(of: ".")!)
        let location = [file, function, line.description].joined(separator: "::")
        
        print("[\(prefix.uppercased())] - \(location) \t\(msg)")

        #endif
    }
}
