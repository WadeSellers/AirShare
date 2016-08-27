//
//  MainViewController.swift
//  AirShare
//
//  Created by Wade Sellers on 8/26/16.
//  Copyright © 2016 InsertCoinProductions. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var passPhraseTextField: NSTextField!
    @IBOutlet weak var addFileButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var receiveButton: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!

    var outgoingConnectionManager : OutgoingConnectionManager?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onAddFileButtonClicked(sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true

        panel.beginWithCompletionHandler { (result) in
            if result == NSFileHandlingPanelOKButton {
                let url = panel.URLs[0]
                print(url)
            }
        }
    }

    @IBAction func onSendButtonClicked(sender: NSButton) {
        guard passPhraseTextField.stringValue != "" else {
            statusLabel.stringValue = "You need a passPhrase to continue"
            return
        }

        outgoingConnectionManager = OutgoingConnectionManager(passPhrase: passPhraseTextField.stringValue)
    }


    @IBAction func onStopButtonClicked(sender: NSButton) {
        guard (outgoingConnectionManager != nil) else {
            return
        }

        outgoingConnectionManager?.stopAdvertising()
    }
}

