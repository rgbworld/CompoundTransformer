//
//  AppDelegate.swift
//  CompoundTransformer
//
//  Created by Chris Kassa on 6/18/17.
//  Copyright © 2017 Chris Kassa. All rights reserved.
//

import Cocoa
import AppKit
import Foundation
import CoreFoundation
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {

    static let sharedInstance: AppDelegate = AppDelegate()
    var prefsWindowController: NSWindowController?
    
    // MARK: - NSApplication

    func applicationWillFinishLaunching(_ aNotification: Notification) {

    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Manually load transformers because 'load' is not permitted by Swift
        ModifiersRuleTransformer.register()

        // Initialize window controllers
        let storyboard = NSStoryboard.init(name: NSStoryboard.Name(rawValue: "Prefs"), bundle: nil)
        guard let controller = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "PrefsStoryboard")) as? NSWindowController else {
           fatalError("Error getting prefs window controller")
        }
        self.prefsWindowController = controller
        prefsWindowController?.window?.makeKeyAndOrderFront(nil) // or use `.showWindow(self)`
    }

    @IBAction func showPreferences(sender: AnyObject) {
        prefsWindowController?.window?.makeKeyAndOrderFront(nil)
    }

    func applicationDidBecomeActive(_ aNotification: Notification) {
    }

    func applicationDidResignActive(_ aNotification: Notification) {
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return .terminateNow
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

}
