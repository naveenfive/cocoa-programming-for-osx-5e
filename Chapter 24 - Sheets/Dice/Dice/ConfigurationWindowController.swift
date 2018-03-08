//
//  PreferenceWindowController.swift
//  Dice
//
//  Created by Nate Chandler on 10/15/14.
//  Copyright (c) 2014 Big Nerd Ranch. All rights reserved.
//

import Cocoa

struct DieConfiguration {
    let color: NSColor
    let rolls: Int
}

class ConfigurationWindowController: NSWindowController {

    var configuration: DieConfiguration {
        set {
            color = newValue.color
            rolls = newValue.rolls
        }
        get {
            return DieConfiguration(color: color, rolls: rolls)
        }
    }
    
    @objc private dynamic var color: NSColor = NSColor.white
    @objc private dynamic var rolls: Int = 10
    
    override var windowNibName: NSNib.Name? {
        get {
            return NSNib.Name(rawValue: "ConfigurationWindowController")
        }
    }
    
    @IBAction func okayButtonClicked(button: NSButton) {
        dismissWithModalResponse(response: NSApplication.ModalResponse.OK)
    }
    
    @IBAction func cancelButtonClicked(button: NSButton) {
        dismissWithModalResponse(response: NSApplication.ModalResponse.cancel)
    }
    
    func dismissWithModalResponse(response: NSApplication.ModalResponse) {
        window!.sheetParent!.endSheet(window!, returnCode: response)
    }
    
}
