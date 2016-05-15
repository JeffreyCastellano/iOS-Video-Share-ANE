//
//  Facebook.m
//  EmpathSocialLib
//
//  Created by Jeffrey Castellano on 5/10/16.
//  Copyright © 2016 Empath. All rights reserved.
//

#import "Facebook.h"

@implementation Facebook

static NSString *attachmentPropertySeparator = @"|";
static NSString *attachmentsSeparator = @"----";


-(void) sendFacebook:(NSString *)messageBody
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

            NSURL *inputURL = [NSURL URLWithString:[filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
            ^(NSURL *newURL, NSError *error) {
                if (error) {
                } else {
                    
                    FBSDKShareDialog *shareDialog = [[FBSDKShareDialog alloc] init];
                    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
                    video.videoURL = newURL;
                    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
                    content.video = video;
                    shareDialog.shareContent = content;
                    shareDialog.fromViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
                    [shareDialog show];
                    
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

- (void)saveToCameraRoll:(NSURL *)srcURL
{
    NSLog(@"srcURL: %@", srcURL);
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteVideoCompletionBlock videoWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            NSLog( @"Wrote image with metadata to Photo Library %@", newURL.absoluteString);
            //url_new  = newURL;
        }
    };
    
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:srcURL])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:srcURL
                                    completionBlock:videoWriteCompletionBlock];
    }
}


-(void) setContext:(FREContext)ctx{
    context = ctx;
}

@end