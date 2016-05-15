//
//  Message.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/8/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "FlashRuntimeExtensions.h"

@interface SMSMessage : NSObject<MFMessageComposeViewControllerDelegate> {
    FREContext context;
}

-(void) sendSMS:(NSString *)messageBody
        toRecipients:(NSString *)toRecipients
    attachmentsData:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;

@end
