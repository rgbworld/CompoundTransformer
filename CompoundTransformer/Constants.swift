//
//  Constants.swift
//  CompoundTransformer
//
//  Created by Chris Kassa on 7/6/17.
//  Copyright © 2017 Chris Kassa. All rights reserved.
//

import Foundation

struct Constants {

static var g_default_modifiers:NSMutableDictionary? = nil

    struct ModifiersRuleTarget {
      static let targetOneWindow: Int    = 0
      static let targetOneApp: Int       = 1
      static let targetAllApps: Int      = 2
      static let targetEnd: Int          = 3
    }

    public enum ModifiersRuleAction {
      static let actionNone: Int         = -3
      static let actionAll: Int          = -2
      static let actionAny: Int          = -1
      static let actionReduce: Int       = 0
      static let actionTransparent: Int  = 1
      static let actionThumbnail: Int    = 2
      static let actionDock: Int         = 3
      static let actionEnd: Int          = 4
    }

    public enum UserDefaultsKeys {
      static let minimizeModifiers              = "MinimizeModifiers"
    }

}
