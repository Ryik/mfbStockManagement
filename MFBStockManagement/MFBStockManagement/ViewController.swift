//
//  ViewController.swift
//  MFBStockManagement
//
//  Created by Gabriel Morin on 19/10/2017.
//  Copyright © 2017 MFB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDecoderUI), name: NSNotification.Name(rawValue: DECODER_DATA_RECEIVED_VC), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDecoderUI(_ notification: Notification) {
        if notification.object != nil && (notification.object is String) {
            scanresult.text = notification.object
        }
    }

}

