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
    @IBOutlet weak var shareButton: NSButton!
    @IBOutlet weak var statusLabel: NSTextField!

    var connectionManager : ConnectionManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        connectionManager = ConnectionManager()
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

    @IBAction func onShareButtonClicked(sender: NSButton) {
        guard passPhraseTextField.stringValue != "" else {
            statusLabel.stringValue = "You need a passPhrase to continue"
            return
        }

        connectionManager?.startServices()
    }


    @IBAction func onStopButtonClicked(sender: NSButton) {
        guard (connectionManager != nil) else {
            return
        }

        connectionManager?.stopServices()

    }

}

