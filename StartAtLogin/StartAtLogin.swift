//
//  StartAtLogin.swift
//  StartAtLogin
//

import Cocoa
import ServiceManagement

public enum StartAtLogin {
    public static var enabled: Bool {
        get {
            if #available(macOS 13, *) {
                return StartAtLogin13.enabled || StartAtLogin10_14_6.enabled
            } else {
                return StartAtLogin10_14_6.enabled
            }
        }

        set {
            if #available(macOS 13, *) {
                // Migrate the user from the login helper to the main app
                StartAtLogin10_14_6.enabled = false

                StartAtLogin13.enabled = newValue
            } else {
                StartAtLogin10_14_6.enabled = newValue
            }
        }
    }
}

private enum StartAtLogin13 {
    @available(macOS 13, *)
    static var enabled: Bool {
        get {
            SMAppService.mainApp.status == .enabled
        }
        set {
            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("StartAtLogin: Failed setting the login item to \(newValue ? "enabled" : "disabled"): \(error)")
            }
        }
    }
}

private enum StartAtLogin10_14_6 {
    static var identifier: String = "\(Bundle.main.bundleIdentifier!)-StartAtLoginHelper"

    static var enabled: Bool {
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
                print("StartAtLogin: Failed setting the login item to \(newValue ? "enabled" : "disabled")")
            }
        }
    }
}
