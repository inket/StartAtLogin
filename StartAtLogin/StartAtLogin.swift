//
//  StartAtLogin.swift
//  StartAtLogin
//

import Cocoa
import ServiceManagement

public struct StartAtLogin {
    public static var identifier: String = "\(Bundle.main.bundleIdentifier!)-StartAtLoginHelper"
    public static var enabled: Bool {
        get {
            let jobs = (SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as! [[String : AnyObject]])
            let job = jobs.first { $0["Label"] as! String == identifier }

            if let onDemand = job?["OnDemand"] as? Bool {
                return onDemand
            }

            return false
        }
        set {
            if (!SMLoginItemSetEnabled(identifier as CFString, newValue)) {
                NSLog("StartAtLogin: Failed setting the login item to \(newValue ? "enabled" : "disabled")");
            }
        }
    }
}
