//
//  PrefsViewController.swift
//  CompoundTransformer
//
//  Created by Chris Kassa on 8/11/17.
//  Copyright © 2017 Chris Kassa. All rights reserved.
//

import AppKit

class PrefsViewController: NSTabViewController {

    lazy var originalSizes = [String : NSSize]()

    // MARK: - NSTabViewDelegate

    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, willSelect: tabViewItem)

        _ = tabView.selectedTabViewItem
        let originalSize = self.originalSizes[tabViewItem!.label]
        if (originalSize == nil) {
            self.originalSizes[tabViewItem!.label] = (tabViewItem!.view?.frame.size)!
        }
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)

        let window = self.view.window
        if (window != nil) {
            window?.title = tabViewItem!.label
            let size = (self.originalSizes[tabViewItem!.label])!
            let contentFrame = (window?.frameRect(forContentRect: NSMakeRect(0.0, 0.0, size.width, size.height)))!
            var frame = (window?.frame)!
            frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
            frame.size.height = contentFrame.size.height;
            frame.size.width = contentFrame.size.width;
            window?.setFrame(frame, display: false, animate: true)
        }
    }

    public override func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let toolbarIdentifiers = super.toolbarAllowedItemIdentifiers(toolbar)
        return distributedItemIdentifiers(indentifiers: toolbarIdentifiers)
    }
    
    public override func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        let toolbarIdentifiers = super.toolbarDefaultItemIdentifiers(toolbar)
        return distributedItemIdentifiers(indentifiers: toolbarIdentifiers)
    }
    
    func distributedItemIdentifiers(indentifiers: [NSToolbarItem.Identifier]) -> [NSToolbarItem.Identifier] {
        var distributedIdentifiers = [NSToolbarItem.Identifier]()

        for identifier in indentifiers {
            distributedIdentifiers.append(NSToolbarItem.Identifier(rawValue: identifier.rawValue))
            distributedIdentifiers.append(NSToolbarItem.Identifier(rawValue: NSToolbarItem.Identifier.flexibleSpace.rawValue))
        }

        return [NSToolbarItem.Identifier(rawValue: NSToolbarItem.Identifier.flexibleSpace.rawValue)] + distributedIdentifiers
    }

}
