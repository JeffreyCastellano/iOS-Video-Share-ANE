//
//  FBMessenger.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "FBMessenger.h"

@implementation FBMessenger

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";


-(void) sendFBMessenger:(NSString *)messageBody
attachmentsData:(NSString *)attachmentsData
{
    
    //Add attachments (if any)
    if (attachmentsData) {
        
        
        NSArray *attachmentProperties;
        NSString *fileName;
        
        NSArray *attachments = [attachmentsData componentsSeparatedByString:attachmentsSeparator];
        
        
        for (NSString *attachmentEntry in attachments) {
            
            attachmentProperties = [attachmentEntry componentsSeparatedByString:attachmentPropertySeparator];
            fileName = [[[attachmentProperties objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0];
            
            NSString *filePath = attachmentProperties[0];
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
            
            if (fileData) {
                [FBSDKMessengerSharer shareVideo:fileData withOptions:nil];
            }
            
            [fileData release];
            
        }
    }
    
    
    
}

-(void) setContext:(FREContext)ctx{
    context = ctx;
}

@end