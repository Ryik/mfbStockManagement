
//
//  coreCaptuvo.m
//  CaptuvoBasicSimples
//
//  Created by Gabriel Morin on 09/17/17
//  Copyright (c) 2015 Honeywell Inc. All rights reserved.
//

class coreCaptuvo : NSObject, CaptuvoEventsProtocol {
    static var sharedCaptuvocore: coreCaptuvo? = nil
    
    class func sharedCaptuvoCore() -> coreCaptuvo {
            return sharedCaptuvocore ?? coreCaptuvo()
    }
    
    override init() {
        super.init()
        
        Captuvo.sharedCaptuvoDevice().addDelegate(self)
        
    }
    
    func startHardware() {
        Captuvo.sharedCaptuvoDevice().startDecoderHardware()
        Captuvo.sharedCaptuvoDevice().startMSRHardware()
        Captuvo.sharedCaptuvoDevice().startPMHardware()
        print("StartHardware")
    }
    
    func stopHardware() {
        Captuvo.sharedCaptuvoDevice().stopDecoderHardware()
        Captuvo.sharedCaptuvoDevice().stopMSRHardware()
        Captuvo.sharedCaptuvoDevice().stopPMHardware()
        print("StopHardware")
    }
    
    // MARK: ----decoder data received-------
    func decoderDataReceived(_ data: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DECODER_DATA_RECEIVED_VC), object: data)
        print("data : ")
        print(data)
        
    }
    
    // MARK: ----msr data received-------
    func msrStringDataReceived(_ data: String, validData status: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MSR_DATA_RECEIVED_VC), object: data)
        print("data2 : ")
        print(data)
    }
    
    // MARK: ----pm data received-------
    func getCurrentBatteryStatus() {
        print("PM Ready >>>>>[[Captuvo sharedCaptuvoDevice] getBatteryStatus] ;")
        print("[[Captuvo sharedCaptuvoDevice] getBatteryStatus] ;")
        let bstatus = Captuvo.sharedCaptuvoDevice().getBatteryStatus()
        update(bstatus)
    }
    
    func pmBatteryStatusChange(_ newBatteryStatus: BatteryStatus) {
        update(newBatteryStatus)
    }
    
    func update(_ newBatteryStatus: BatteryStatus) {
        var status_str: String? = nil
        switch newBatteryStatus {
        case BatteryStatusPowerSourceConnected:
            status_str = "* Power Source connected *"
        case BatteryStatus4Of4Bars:
            status_str = "* 100% *"
        case BatteryStatus3Of4Bars:
            status_str = "* 75% *"
        case BatteryStatus2Of4Bars:
            status_str = "* 50% *"
        case BatteryStatus1Of4Bars:
            status_str = "* 25% *"
        case BatteryStatus0Of4Bars:
            status_str = "* <10% *"
        case BatteryStatusUndefined:
            status_str = "* Undefine *"
        default:
            break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PM_DATA_RECEIVED_VC), object: status_str)
    }
    
    func pmReady() {
        let delayInSeconds: Double = 2.0
        let popTime = DispatchTime.now() + Double(delayInSeconds * Double(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: popTime, execute: { //dans la version originale de la traduction du site, on divise pop time par DOUBLE(machin) à voir si c'est légitime
            self.getCurrentBatteryStatus()
        })
    }
    
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//    [self getCurrentBatteryStatus] ;
//    });
    
    func pmChargeStatus(_ chargeStatus: ChargeStatus) {
        var status_str: String? = nil
        //charging status response event method
        switch chargeStatus {
        case ChargeStatusNotCharging:
            break
        case ChargeStatusCharging:
            status_str = "* Battery is Charging *"
        case ChargeStatusChargeComplete:
            status_str = "* Battery charged completed *"
        case ChargeStatusUndefined:
            break
        default:
            break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PM_DATA_RECEIVED_VC), object: status_str)
    }
    
    func captuvoConnected() {
        startHardware()
    }
    
    func captuvoDisconnected() {
        stopHardware()
    }
}
