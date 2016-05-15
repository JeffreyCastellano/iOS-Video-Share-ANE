//
//  CameraRoll.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "CameraRoll.h"

@implementation CameraRoll

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";


-(void) sendCameraRoll:(NSString *)attachmentsData
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
            
            NSURL *inputURL = [NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
            ^(NSURL *newURL, NSError *error) {
                if (error) {
                } else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Video Saved!" message:@"Your video was successfully saved!"
                                                                   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [alert release];
                }
            };
            
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:inputURL])
            {
                [library writeVideoAtPathToSavedPhotosAlbum:inputURL
                                            completionBlock:videoWriteCompletionBlock];
            }
        }
    }
}

-(void) setContext:(FREContext)ctx{
    context = ctx;
}

@end
