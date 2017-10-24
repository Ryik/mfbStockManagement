//
//  coreCaptuvo.h
//  CaptuvoBasicSimples
//
//  Created by zhou shadow on 4/20/15.
//  Copyright (c) 2015 Honeywell Inc. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "Captuvo.h"
#import "ConstDefine.h"
@interface coreCaptuvo : NSObject<CaptuvoEventsProtocol>
+(coreCaptuvo*)sharedCaptuvoCore ;
- (void)startHardware;
- (void)stopHardware;
@end
