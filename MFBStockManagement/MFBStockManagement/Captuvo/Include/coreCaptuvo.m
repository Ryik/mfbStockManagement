//
//  coreCaptuvo.m
//  CaptuvoBasicSimples
//
//  Created by zhou shadow on 4/20/15.
//  Copyright (c) 2015 Honeywell Inc. All rights reserved.
//

#import "coreCaptuvo.h"

@implementation coreCaptuvo
static coreCaptuvo *sharedCaptuvocore = nil;

+(coreCaptuvo*)sharedCaptuvoCore{
    if (nil!= sharedCaptuvocore) {
        return sharedCaptuvocore;
    }
    sharedCaptuvocore = [[coreCaptuvo alloc] init];
    return sharedCaptuvocore;
}

- (id)init
{
    self = [super init] ;
    if (self!=nil) {
        [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self] ;
    }
    return  self ;
}

- (void)startHardware{    
    [[Captuvo sharedCaptuvoDevice] startDecoderHardware] ;
    [[Captuvo sharedCaptuvoDevice] startMSRHardware] ;
    [[Captuvo sharedCaptuvoDevice] startPMHardware] ;
    printf("\n startHardware \n");
}

- (void)stopHardware{
    [[Captuvo sharedCaptuvoDevice] stopDecoderHardware] ;
    [[Captuvo sharedCaptuvoDevice] stopMSRHardware] ;
    [[Captuvo sharedCaptuvoDevice] stopPMHardware] ;
}


#pragma mark ----decoder data received-------
-(void)decoderDataReceived:(NSString*)data
{    
    [[NSNotificationCenter defaultCenter] postNotificationName:DECODER_DATA_RECEIVED_VC object:data];
}

#pragma mark ----msr data received-------
- (void) msrStringDataReceived:(NSString *)data validData:(BOOL)status
{
   [[NSNotificationCenter defaultCenter] postNotificationName:MSR_DATA_RECEIVED_VC object:data] ;
}

#pragma mark ----pm data received-------

- (void)getCurrentBatteryStatus
{
    NSLog(@"PM Ready >>>>>[[Captuvo sharedCaptuvoDevice] getBatteryStatus] ;") ;
    
    NSLog(@"[[Captuvo sharedCaptuvoDevice] getBatteryStatus] ;") ;
    BatteryStatus bstatus =  [[Captuvo sharedCaptuvoDevice] getBatteryStatus] ;
    
    [self updateBatteryStatus:bstatus];
}

-(void)pmBatteryStatusChange:(BatteryStatus)newBatteryStatus
{
    
    [self updateBatteryStatus:newBatteryStatus];
}

-(void)updateBatteryStatus:(BatteryStatus)newBatteryStatus
{
    NSString *status_str = nil;
    
    switch (newBatteryStatus) {
        case BatteryStatusPowerSourceConnected:
            status_str = @"* Power Source connected *" ;
            break;
            
        case BatteryStatus4Of4Bars:
            
            status_str = @"* 100% *" ;
            
            break ;
            
        case BatteryStatus3Of4Bars:
            
            status_str = @"* 75% *" ;
            
            break ;
            
        case BatteryStatus2Of4Bars:
            
            status_str = @"* 50% *" ;
            
            break ;
            
        case BatteryStatus1Of4Bars:
            
            status_str = @"* 25% *" ;
            
            break ;
            
        case BatteryStatus0Of4Bars:
            
            status_str = @"* <10% *" ;
            
            break ;
            
        case BatteryStatusUndefined:
            
            status_str = @"* Undefine *" ;
            
            break ;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PM_DATA_RECEIVED_VC object:status_str] ;
}

- (void)pmReady{
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self getCurrentBatteryStatus] ;
    });
}

-(void)pmChargeStatus:(ChargeStatus)chargeStatus
{
    NSString *status_str = nil;
    
    //charging status response event method
    switch (chargeStatus) {
            
        case ChargeStatusNotCharging:
            
            
            break;
        case ChargeStatusCharging:
            
            status_str = @"* Battery is Charging *" ;
            
            break ;
            
        case ChargeStatusChargeComplete:
            
            status_str = @"* Battery charged completed *" ;
            
            break ;
            
        case ChargeStatusUndefined:
            
            break ;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PM_DATA_RECEIVED_VC object:status_str] ;
}

- (void)captuvoConnected{
    [self startHardware] ;
}

- (void)captuvoDisconnected
{
    [self stopHardware] ;
}

@end
