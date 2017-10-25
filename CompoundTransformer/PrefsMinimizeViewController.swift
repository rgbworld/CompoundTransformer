//
//  PrefsMinimizeViewController.swift
//  CompoundTransformer
//
//  Created by Chris Kassa on 8/11/17.
//  Copyright © 2017 Chris Kassa. All rights reserved.
//

import Cocoa

class PrefsMinimizeViewController: NSViewController {

    // Actions tab
    @IBOutlet weak var arrayController: NSArrayController!
    @IBOutlet weak var actionsTableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ModifiersRuleItem.registerDefaultModifiers(modifiers: UInt(1), forAction: Constants.ModifiersRuleAction.actionReduce, andTarget: Constants.ModifiersRuleTarget.targetOneWindow)
        ModifiersRuleItem.registerDefaultModifiers(modifiers: (UInt(1) | NSEvent.ModifierFlags.control.rawValue), forAction: Constants.ModifiersRuleAction.actionReduce, andTarget: Constants.ModifiersRuleTarget.targetOneApp)

        UserDefaults.standard.register(defaults: [Constants.UserDefaultsKeys.minimizeModifiers : [
            ModifiersRuleItem(withAction: Constants.ModifiersRuleAction.actionReduce, forTarget: Constants.ModifiersRuleTarget.targetOneWindow).encodeAsDictionary(),
            ModifiersRuleItem(withAction: Constants.ModifiersRuleAction.actionReduce, forTarget: Constants.ModifiersRuleTarget.targetOneApp).encodeAsDictionary()
        ]])

    }

}
