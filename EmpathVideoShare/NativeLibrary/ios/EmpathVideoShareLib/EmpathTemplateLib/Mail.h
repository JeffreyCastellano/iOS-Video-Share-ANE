//
//  Mail.h
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/8/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FlashRuntimeExtensions.h"


@interface Mail : NSObject<MFMailComposeViewControllerDelegate> {
    FREContext context;
}

-(void) sendMailWithSubject:(NSString *)subject
               toRecipients:(NSString *)toRecipients
                messageBody:(NSString *)messageBody
            attachmentsData:(NSString *)attachmentsData;

-(void)setContext:(FREContext)ctx;

@end
