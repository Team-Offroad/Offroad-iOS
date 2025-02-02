// The Swift Programming Language
// https://docs.swift.org/swift-book


public struct LogPrinter {
    
    public static func setLogManager() {
        let _ = LogPrinterManager.shared
    }
    
    public static func printLog(_ log: String) {
        LogPrinterManager.shared.printLog(log)
    }
    
}
