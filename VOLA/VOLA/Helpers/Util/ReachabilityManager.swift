import Foundation
import ReachabilitySwift

protocol ReachabilityListener: class {
    func onNetworkStatusDidChange(status: Reachability.NetworkStatus)
}

extension Reachability.NetworkStatus {
    var isReachable: Bool {
        return isReachableViaWifi || isReachableViaWWAN
    }

    var isReachableViaWifi: Bool {
        return self == .reachableViaWiFi
    }

    var isReachableViaWWAN: Bool {
        return self == .reachableViaWWAN
    }
}

class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()
    private override init() {
        super.init()
    }

    var isReachable: Bool {
        return isReachableViaWifi || isReachableViaWWAN
    }

    var isReachableViaWifi: Bool {
        return reachabilityStatus == .reachableViaWiFi
    }

    var isReachableViaWWAN: Bool {
        return reachabilityStatus == .reachableViaWWAN
    }

    private var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    private let reachability = Reachability()!
    private var subscribers = [ReachabilityListener]()

    func reachabilityChanged(notification: Notification) {

        let reachability = notification.object as! Reachability
        reachabilityStatus = reachability.currentReachabilityStatus

        switch reachabilityStatus {
        case .notReachable:
            Logger.info("Network became unreachable")
        case .reachableViaWiFi:
            Logger.info("Network reachable through WiFi")
        case .reachableViaWWAN:
            Logger.info("Network reachable through Cellular Data")
        }

        // notify interested parties
        subscribers.forEach { subscriber in
            DispatchQueue.main.async {
                subscriber.onNetworkStatusDidChange(status: reachability.currentReachabilityStatus)
            }
        }
    }

    func startMonitoring() {
        addNotificationObserver(ReachabilityChangedNotification, selector: #selector(self.reachabilityChanged), reachability)

        do {
            try reachability.startNotifier()
        } catch {
            Logger.error("Failed to start reachability notifier")
        }
    }

    func stopMonitoring() {
        reachability.stopNotifier()
        removeNotificationObserver(ReachabilityChangedNotification, reachability)
    }

    /// Adds a new subscriber to a network status change
    ///
    /// - parameter `NetworkStatusListener`: a new subscriber
    func subscribe(_ subscriber: ReachabilityListener) {
        subscribers.append(subscriber)

        // notify the new subscriber regarding the current value
        DispatchQueue.main.async {
            subscriber.onNetworkStatusDidChange(status: self.reachabilityStatus)
        }
    }

    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    func unsubscribe(_ subscriber: ReachabilityListener) {
        subscribers = subscribers.filter { $0 !== subscriber }
    }
}
