//
//  Instagram.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "Instagram.h"

@implementation Instagram

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";


-(void) sendInstagram:(NSString *)attachmentsData
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
            
            NSURL *inputURL = [NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
            ^(NSURL *newURL, NSError *error) {
                if (error) {
                } else {
                    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
                    {
                        NSString *escapedString = [newURL.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                        
                        //NSString *escapedCaption = [@"" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                    
                        NSURL *instagramURL       = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@", escapedString]];
                    
                        [[UIApplication sharedApplication] openURL:instagramURL];
                    }
   
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
