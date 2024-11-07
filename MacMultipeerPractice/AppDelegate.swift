//
//  AppDelegate.swift
//  MacMultipeerPractice
//
//  Created by Jin Lee on 11/7/24.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusBar()
    }

    func setupStatusBar() {
        // 상태바 아이콘 설정
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "choi"
            button.action = #selector(togglePopover)
        }
        
        // 팝오버 설정
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 200, height: 100)
        popover?.behavior = .transient
        popover?.animates = true
        popover?.contentViewController = NSHostingController(rootView: MainView())
    }
    
    @objc func togglePopover() {
        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                if let button = statusItem?.button {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .maxY)
                }
            }
        }
    }
}
