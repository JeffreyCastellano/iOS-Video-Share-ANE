//
//  FBMessenger.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@interface FBMessenger : NSObject{
    FREContext context;
}

-(void) sendFBMessenger:(NSString *)messageBody
attachmentsData:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;
@end