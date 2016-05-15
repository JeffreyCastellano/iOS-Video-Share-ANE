//
//  Message.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/8/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "SMSMessage.h"

@implementation SMSMessage

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";
//Event name
static  NSString *event_name = @"MESSAGE_COMPOSER_EVENT";


-(void) sendSMS:(NSString *)messageBody
                toRecipients:(NSString *)toRecipients
            attachmentsData:(NSString *)attachmentsData
{
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[@"WILL_SHOW_MESSAGE_COMPOSER" UTF8String]);
    
    
    MFMessageComposeViewController* messageComposer = [[MFMessageComposeViewController alloc] init];
    messageComposer.messageComposeDelegate = self;
    
    if (messageBody != nil){
        messageComposer.body = messageBody;
    }
    
    if (toRecipients != nil && [toRecipients rangeOfString:@"@"].location != NSNotFound){
        messageComposer.recipients = [toRecipients componentsSeparatedByString:@","];
    }
    
    //Add attachments (if any)
    if (attachmentsData) {
        
        
        NSArray *attachmentProperties;
        NSString *fileName;
        NSString *fileExtension;
        NSString *fileSearchSource;
        NSString *fileMimeType;
        NSString *fileAttachName;
        
        NSArray *attachments = [attachmentsData componentsSeparatedByString:attachmentsSeparator];
        
        //NSString nameofFile = attachments[0].toString()
        // int myLength = [attachments count];
        ///NSString* myNewString = [NSString stringWithFormat:@"%i", myLength];
        
        for (NSString *attachmentEntry in attachments) {
            
            attachmentProperties = [attachmentEntry componentsSeparatedByString:attachmentPropertySeparator];
            fileName = [[[attachmentProperties objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:0];
            fileExtension = [[[attachmentProperties objectAtIndex:0] componentsSeparatedByString:@"."] objectAtIndex:1];
            fileSearchSource = [(NSString *)[attachmentProperties objectAtIndex:1] lowercaseString];//bundle or documents
            fileMimeType = [attachmentProperties objectAtIndex:2];//mime type of file
            fileAttachName = [attachmentProperties objectAtIndex:3];//how to name the file
            
            NSString *filePath = attachmentProperties[0];
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
            
            
            if (fileData) {
                
                [messageComposer addAttachmentData:fileData typeIdentifier:@"public.video" filename:fileAttachName];

            }
            
            [fileData release];
            
            //}
        }
    }
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:messageComposer animated:YES completion:nil];
    
    [messageComposer release];
    
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"Message was cancelled");
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];             break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed");
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];             break;
        case MessageComposeResultSent:
            NSLog(@"Message was sent");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:@"Your message was sent!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];             break;
        default:             
            break;     
    }
}



-(void)setContext:(FREContext)ctx {
    context = ctx;
}

@end
