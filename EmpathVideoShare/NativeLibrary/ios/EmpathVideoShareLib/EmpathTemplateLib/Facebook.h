//
//  Facebook.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface Facebook : NSObject{
    FREContext context;
}
-(void) sendFacebook:(NSString *)messageBody
        attachmentsData:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;

-(void)saveToCameraRoll:(NSURL *)srcURL;

@end