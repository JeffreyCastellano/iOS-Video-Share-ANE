//
//  Mail.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/8/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "Mail.h"

@implementation Mail

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";
//Event name
static  NSString *event_name = @"MAIL_COMPOSER_EVENT";


-(void) sendMailWithSubject:(NSString *)subject
               toRecipients:(NSString *)toRecipients
                messageBody:(NSString *)messageBody
            attachmentsData:(NSString *)attachmentsData
{
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[@"WILL_SHOW_MAIL_COMPOSER" UTF8String]);
    
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
    
    if (subject != nil)
        [mailComposer setSubject: subject];
    
    if (messageBody != nil)
        [mailComposer setMessageBody:messageBody isHTML:YES];
    
    if (toRecipients != nil && [toRecipients rangeOfString:@"@"].location != NSNotFound)
        [mailComposer setToRecipients:[toRecipients componentsSeparatedByString:@","]];
    
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

                    [mailComposer addAttachmentData: fileData mimeType:fileMimeType fileName:fileAttachName];
                }
                
                [fileData release];
                
            //}
        }
    }
    
    
    //show mail composer
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:mailComposer animated:YES completion:nil];
    
    [mailComposer release];
    
}

// Dismisses the email composition interface when users tap Cancel or Send.
-(void) mailComposeController: (MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error:(NSError*)error
{
    NSString *event_info = @"";
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            event_info = @"MAIL_CANCELED";
            break;
        case MFMailComposeResultSaved:
            event_info = @"MAIL_SAVED";
            break;
        case MFMailComposeResultSent:
            event_info = @"MAIL_SENT";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Message Sent!" message:@"Your email was sent!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            break;
        case MFMailComposeResultFailed:
            event_info = @"MAIL_FAILED";
            break;
        default:
            event_info = @"MAIL_UNKNOWN";
            break;
    }
    
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[event_info UTF8String]);
    FREDispatchStatusEventAsync(context, (uint8_t*)[event_name UTF8String], (uint8_t*)[@"WILL_HIDE_MAIL_COMPOSER" UTF8String]);
    
    context = nil;
    
    //hide mail composer
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)setContext:(FREContext)ctx {
    context = ctx;
}

@end
