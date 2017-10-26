//
//  ViewController.swift
//  SwiftSample
//
//  Created by zhou shadow on 5/6/15.
//  Copyright (c) 2015 Honeywell Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CaptuvoEventsProtocol{
    
    @IBOutlet weak var barcodelbl:UILabel!
    @IBOutlet weak var msrlbl:UILabel!
    @IBOutlet weak var versionlbl:UILabel!
    @IBOutlet weak var batterlbl:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Captuvo.sharedCaptuvoDevice().addDelegate(self)
        Captuvo.sharedCaptuvoDevice().startDecoderHardware()
        
        Captuvo.sharedCaptuvoDevice().startMSRHardware()
        Captuvo.sharedCaptuvoDevice().setMSRTrackSelection(TrackSelectionRequire1and2)
        
        Captuvo.sharedCaptuvoDevice().startPMHardware()
        
        
        let infoDictionary = Bundle.main.infoDictionary
        
        //let infoDictionary: AnyObject? =  ["CFBundleShortVersionString"]
        
        let minorVersion : AnyObject? = infoDictionary! ["CFBundleVersion"] as AnyObject
        
        let appversion = minorVersion as! String
        
        barcodelbl.text = "Barcode information"
        msrlbl.text = "MSR Information"
        versionlbl.text = "App version: \(appversion) \nSDK Version: \(Captuvo.sharedCaptuvoDevice().getSDKshortVersion())"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decoderDataReceived(_ data: String!) {
        
        barcodelbl.text = data
        
    }
    
    func msrStringDataReceived(_ data: String!, validData status: Bool) {
        msrlbl.text = data
    }
    
    func pmReady(){
        
        batterlbl.text = "Battery is Ready"
    }
    
    func msrReady() {
        msrlbl.text = "MSR is Ready"
    }
    
    func decoderReady() {
        barcodelbl.text = "Scanner is Ready"
    }
    
    func responseBatteryDetailInformation(batteryInfo:cupertinoBatteryDetailInfo)
    {
        batterlbl.text="Battery: \(batteryInfo.percentage) %";
    }
    
    func captuvoConnected(){
        
        Captuvo.sharedCaptuvoDevice().startDecoderHardware()
        Captuvo.sharedCaptuvoDevice().startMSRHardware()
        Captuvo.sharedCaptuvoDevice().startPMHardware()
        
    }
    
    func captuvoDisconnected()
    {
        Captuvo.sharedCaptuvoDevice().stopDecoderHardware()
        Captuvo.sharedCaptuvoDevice().stopMSRHardware();
        Captuvo.sharedCaptuvoDevice().stopPMHardware()
    }
    
    
}

