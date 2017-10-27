//
//  ModifiersRuleItem.swift
//  CompoundTransformer
//
//  Created by Chris Kassa on 9/21/17.
//  Copyright © 2017 Chris Kassa. All rights reserved.
//

import AppKit
import Foundation

let minimize_actions:[String] = ["Reduce to Title Bar", "Make Transparent", "Reduce to Thumbnail", "Minimize to Dock"]
let minimize_targets:[String] = ["One Window", "One App", "All Apps"]

class ModifiersRuleTransformer: ValueTransformer {

    // Alternative to Objective-C class method 'load', which is not permitted by Swift
    class func register() {
        ValueTransformer.setValueTransformer(ModifiersRuleTransformer(), forName: NSValueTransformerName(rawValue: "ModifiersRuleTransformer"))
    }

    override class func transformedValueClass() -> AnyClass {
        return type(of: NSMutableArray.self) as! AnyClass
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let array:NSArray = value as? NSArray else {
            return nil
        }
        
        let results = NSMutableArray()

        for item in array {
            if item is NSDictionary {
                let transformed = ModifiersRuleItem(withDict: item as! NSDictionary)
                results.add(transformed)
            }
        }
        return results
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let array:NSArray = value as? NSArray else {
            return nil
        }
        
        let results = NSMutableArray()

        for item in array {
            if item is ModifiersRuleItem {
                let transformed = (item as! ModifiersRuleItem).encodeAsDictionary()
                results.add(transformed)
            }
        }
        return results
    }
}

// MARK: - Class ModifiersRuleItem (KVO)

class ModifiersRuleItem: NSObject {
    private var kvoContext: Int = 1
    @objc dynamic var m_targetAction: Int = 0
    @objc dynamic var m_modifiers: Int = 0

    func update_modifiers(mask:Int, enabled:Bool) -> () {
        let newModifiers = ((modifiers & ~mask) | ((enabled) ? mask:0))
        modifiers = newModifiers
    }

    @objc dynamic var modifiers: Int {
        set(newModifiers) {
            m_modifiers = newModifiers
        }
        get {
            return m_modifiers
        }
    }

    @objc dynamic var enabled: NSNumber {
        set(newEnabled) {
            update_modifiers(mask:1, enabled:newEnabled.boolValue)
        }
        get {
            let x = (m_modifiers & 1)
            return (x != 0) as NSNumber
        }
    }

    @objc dynamic var command: NSNumber {
        set(newCommand) {
            update_modifiers(mask:Int(NSEvent.ModifierFlags.command.rawValue), enabled:newCommand.boolValue)
        }
        get {
            let x = (m_modifiers & Int(NSEvent.ModifierFlags.command.rawValue))
            return (x != 0) as NSNumber
        }
    }

    @objc dynamic var option: NSNumber {
        set(newOption) {
            update_modifiers(mask:Int(NSEvent.ModifierFlags.option.rawValue), enabled:newOption.boolValue)
        }
        get {
            let x = (m_modifiers & Int(NSEvent.ModifierFlags.option.rawValue))
            return (x != 0) as NSNumber
        }
    }

    @objc dynamic var control: NSNumber {
        set(newControl) {
            update_modifiers(mask:Int(NSEvent.ModifierFlags.control.rawValue), enabled:newControl.boolValue)
        }
        get {
            let x = (m_modifiers & Int(NSEvent.ModifierFlags.control.rawValue))
            return (x != 0) as NSNumber
        }
    }

    @objc dynamic var targetTitle: NSString {
        get {
            if (ModifiersRuleItem.ATP_TARGET(atp: m_targetAction) < Constants.ModifiersRuleTarget.targetEnd) {
                let text = NSLocalizedString(minimize_targets[ModifiersRuleItem.ATP_TARGET(atp:m_targetAction)], comment: "Minimize target title, fetched from the table")
                return text as NSString
            }
            return "No Target"
        }
    }

    @objc dynamic var actionTitle: NSString {
        get {
            if (ModifiersRuleItem.ATP_ACTION(atp: m_targetAction) < Constants.ModifiersRuleAction.actionEnd) {
                let text = NSLocalizedString(minimize_actions[ModifiersRuleItem.ATP_ACTION(atp:m_targetAction)], comment: "Minimize action title, fetched from the table")
                return text as NSString
            }
            return "No Action"
        }
    }

    // MARK: -

    init(withDict: NSDictionary) {
        super.init()
        m_targetAction = withDict.object(forKey: "ActionTarget") as! Int
        m_modifiers = withDict.object(forKey: "Modifiers") as! Int
    }

    init(withAction action: Int, forTarget target: Int) {
        super.init()
        m_targetAction = ModifiersRuleItem.ATP_MAP(a:action, t:target)
        m_modifiers = Constants.g_default_modifiers?.object(forKey: m_targetAction) as! Int
    }

    func encodeAsDictionary() -> NSDictionary {
        return ["ActionTarget": m_targetAction, "Modifiers": m_modifiers]
    }

    func target() -> Int {
        return ModifiersRuleItem.ATP_TARGET(atp: m_targetAction)
    }

    func action() -> Int {
        return ModifiersRuleItem.ATP_ACTION(atp: m_targetAction)
    }

    // MARK: - Class functions

    class func ATP_MAP(a:Int, t:Int) -> Int {
        return (((a)<<8)|(t))
    }

    class func ATP_TARGET(atp:Int) -> Int {
        return ((atp)&0xff)
    }

    class func ATP_ACTION(atp:Int) -> Int {
        return ((atp>>8)&0xff)
    }

    class func registerDefaultModifiers(modifiers:UInt, forAction action:Int, andTarget target:Int) ->() {
        if (Constants.g_default_modifiers == nil) {
            Constants.g_default_modifiers = NSMutableDictionary()
        }
        
        Constants.g_default_modifiers?.setObject(modifiers, forKey: ATP_MAP(a:action, t:target) as NSCopying)
    }

    class func defaultsContainRule(forAction action: Int, andTarget target: Int) -> Bool {
        guard let minimizeModifiers:NSArray = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.minimizeModifiers) as? NSArray else {
            return false
        }

        for modifiers in minimizeModifiers {
            let mdf:NSDictionary = modifiers as! NSDictionary
            let at:Int = mdf.object(forKey: "ActionTarget") as! Int
            
            if (at == ATP_MAP(a: action, t: target)) {
                return true
            }
        }
        return false
    }

    class func findMatchingRuleItemForModifierFlags(flags: UInt) -> ModifiersRuleItem? {
        var ruleItem: ModifiersRuleItem! = nil
        let possibleFlags: UInt = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.option.rawValue | NSEvent.ModifierFlags.control.rawValue | 1
        var currentFlags = flags
        currentFlags &= possibleFlags
        currentFlags |= 1
        
        guard let minimizeModifiers:NSArray = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.minimizeModifiers) as? NSArray else {
            return nil
        }

        for modifiers in minimizeModifiers {
            let mdf:NSDictionary = modifiers as! NSDictionary
            let m:UInt = mdf.object(forKey: "Modifiers") as! UInt

            if ((m&possibleFlags) == currentFlags) {
                ruleItem = ModifiersRuleItem.init(withDict: mdf)
                return ruleItem
            }
        }
        return nil
    }

}
