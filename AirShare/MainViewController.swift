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

    var filePathURL : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()

        connectionManager = ConnectionManager()
    }

    @IBAction func onAddFileButtonClicked(_ sender: NSButton) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true

        panel.begin { (result) in
            if result == NSFileHandlingPanelOKButton {
                let url = panel.urls[0]
                self.filePathURL = url
                print(self.filePathURL)
            }
        }

    }

    @IBAction func onShareButtonClicked(_ sender: NSButton) {
        guard passPhraseTextField.stringValue != "" else {
            statusLabel.stringValue = "You need a passPhrase to continue"
            return
        }

        connectionManager?.startServices()

        let location = filePathURL
        let fileContent = NSData(contentsOf: location!)
        ConnectionManager.send
    }


    @IBAction func onStopButtonClicked(_ sender: NSButton) {
        guard (connectionManager != nil) else {
            return
        }

        connectionManager?.stopServices()

    }

}

