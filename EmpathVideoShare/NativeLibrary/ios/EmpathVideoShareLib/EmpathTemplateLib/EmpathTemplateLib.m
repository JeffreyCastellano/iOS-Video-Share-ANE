//
//  EmpathTemplateLib.m
//  EmpathTemplateLib.m
//

#import "FlashRuntimeExtensions.h"
#import <Foundation/Foundation.h>

#import "SMSMessage.h"
#import "Mail.h"
#import "Facebook.h"
#import "FBMessenger.h"
#import "CameraRoll.h"
#import "Instagram.h"


SMSMessage *messageComposerHelper;
Mail *mailComposerHelper;
FBMessenger *messengerComposeHelper;
Facebook *facebookComposeHelper;
CameraRoll *saveCameraRollHelper;
Instagram *instagramComposeHelper;

FREContext g_ctx;



//------------------------------------
//
// Auxiliary functions
//
//------------------------------------
void sendMessage( const NSString * const messageType, const NSString * const message )
{
    assert( messageType );
    
    if ( NULL != message )
    {
        FREDispatchStatusEventAsync( g_ctx, ( uint8_t * ) [ messageType UTF8String ], ( uint8_t * ) [ message UTF8String ] );
    }
    else
    {
        FREDispatchStatusEventAsync( g_ctx, ( uint8_t * ) [ @"STATUS_EVENT" UTF8String ], ( uint8_t * ) [ messageType UTF8String ] );
    }
}


NSString * getNSStringFromCString( FREObject arg )
{
    NSString * resultString = NULL;
    
    uint32_t strLength = 0;
    const uint8_t * argCString = NULL;
    FREResult argumentResult = FREGetObjectAsUTF8( arg, &strLength, &argCString );
    
    if ( ( FRE_OK == argumentResult ) && ( 0 < strLength ) && ( NULL != argCString ) )
    {
        resultString = [ NSString stringWithUTF8String:(const char *) argCString ];
    }
    
    return resultString;
}


FREObject getFREObjectFromNSString( NSString * value )
{
    FREObject stringAS = NULL;
    if ( NULL != value )
    {
        FRENewObjectFromUTF8( ( uint32_t ) [ value length ], ( const uint8_t * ) [ value UTF8String ], &stringAS );
    }
    
    return stringAS;
}


//------------------------------------
// ActionScript API
//------------------------------------


FREObject composeSMS( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    //To Recipients
    uint32_t toRecipientsLength;
    const uint8_t *toRecipientsCString;
    //Message Body
    uint32_t messageBodyLength;
    const uint8_t *messageBodyCString;
    
    NSMutableString *attachmentsString = nil;
    NSString *toRecipientsString = nil;
    NSString *messageBodyString = nil;
    
    //Create NSStrings from CStrings
    
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &messageBodyLength, &messageBodyCString)) {
        messageBodyString = [NSString stringWithUTF8String:(char*)messageBodyCString];
    }
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[1], &toRecipientsLength, &toRecipientsCString)) {
        toRecipientsString = [NSString stringWithUTF8String:(char*)toRecipientsCString];
    }
    uint32_t attachmentsArrayLength = 0;
    //argv[5] is a an array of strings
    if (argc >= 3 && (FRE_OK != FREGetArrayLength(argv[2], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No attachment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[2], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (messageComposerHelper) {
    }else {
        messageComposerHelper = [[SMSMessage alloc] init];
    }
    
    [messageComposerHelper setContext:ctx];
    [messageComposerHelper sendSMS:messageBodyString
                      toRecipients:toRecipientsString
                   attachmentsData:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;
}


FREObject composeMail( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    //Subject
    uint32_t subjectLength;
    const uint8_t *subjectCString;
    //To Recipients
    uint32_t toRecipientsLength;
    const uint8_t *toRecipientsCString;
    //Message Body
    uint32_t messageBodyLength;
    const uint8_t *messageBodyCString;
    
    NSMutableString *attachmentsString = nil;
    NSString *subjectString = nil;
    NSString *toRecipientsString = nil;
    NSString *messageBodyString = nil;
    
    //Create NSStrings from CStrings
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &subjectLength, &subjectCString)) {
        subjectString = [NSString stringWithUTF8String:(char*)subjectCString];
    }
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[1], &messageBodyLength, &messageBodyCString)) {
        messageBodyString = [NSString stringWithUTF8String:(char*)messageBodyCString];
    }
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[2], &toRecipientsLength, &toRecipientsCString)) {
        toRecipientsString = [NSString stringWithUTF8String:(char*)toRecipientsCString];
    }
    
    uint32_t attachmentsArrayLength = 0;
    //argv[5] is a an array of strings
    if (argc >= 4 && (FRE_OK != FREGetArrayLength(argv[3], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No attachment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[3], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (mailComposerHelper) {
    }else {
        mailComposerHelper = [[Mail alloc] init];
    }
    
    [mailComposerHelper setContext:ctx];
    [mailComposerHelper sendMailWithSubject:subjectString
                               toRecipients:toRecipientsString
                                messageBody:messageBodyString
                            attachmentsData:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;
}


FREObject composeMessenger( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    //Message Body
    uint32_t messageBodyLength;
    const uint8_t *messageBodyCString;
    
    NSMutableString *attachmentsString = nil;
    NSString *messageBodyString = nil;
    
    //Create NSStrings from CStrings
    
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &messageBodyLength, &messageBodyCString)) {
        messageBodyString = [NSString stringWithUTF8String:(char*)messageBodyCString];
    }
    uint32_t attachmentsArrayLength = 0;
    //argv[5] is a an array of strings
    if (argc >= 2 && (FRE_OK != FREGetArrayLength(argv[1], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
    }
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[1], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (messengerComposeHelper) {
    }else {
        messengerComposeHelper = [[FBMessenger alloc] init];
    }
    
    [messengerComposeHelper setContext:ctx];
    [messengerComposeHelper sendFBMessenger:messageBodyString
                   attachmentsData:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;
}


FREObject composeFacebook( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    //Message Body
    uint32_t messageBodyLength;
    const uint8_t *messageBodyCString;
    
    NSMutableString *attachmentsString = nil;
    NSString *messageBodyString = nil;
    
    //Create NSStrings from CStrings
    
    
    if (FRE_OK == FREGetObjectAsUTF8(argv[0], &messageBodyLength, &messageBodyCString)) {
        messageBodyString = [NSString stringWithUTF8String:(char*)messageBodyCString];
    }
    
    uint32_t attachmentsArrayLength = 0;
    //argv[5] is a an array of strings
    if (argc >= 2 && (FRE_OK != FREGetArrayLength(argv[1], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No attachment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[1], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (facebookComposeHelper) {
    }else {
        facebookComposeHelper = [[Facebook alloc] init];
    }
    
    [facebookComposeHelper setContext:ctx];
    [facebookComposeHelper sendFacebook:messageBodyString
                   attachmentsData:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;

}

FREObject saveVideoToCameraRoll( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    
    NSMutableString *attachmentsString = nil;
    
    uint32_t attachmentsArrayLength = 0;
    //argv[0] is a an array of strings
    if (argc >= 1 && (FRE_OK != FREGetArrayLength(argv[0], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No attachment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[0], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (saveCameraRollHelper) {
    }else {
        saveCameraRollHelper = [[CameraRoll alloc] init];
    }
    
    [saveCameraRollHelper setContext:ctx];
    [saveCameraRollHelper sendCameraRoll:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;
    
}


FREObject sendInstagram( FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    static NSString *attachmentsSeparator = @"----";
    
    
    NSMutableString *attachmentsString = nil;
    
    uint32_t attachmentsArrayLength = 0;
    //argv[0] is a an array of strings
    if (argc >= 1 && (FRE_OK != FREGetArrayLength(argv[0], &attachmentsArrayLength))) {
        //No valid array of attachments provided.
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"No attachment"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    
    
    if (attachmentsArrayLength >= 1) {
        
        attachmentsString = [[NSMutableString alloc ] init];
        uint32_t attachmentEntryLength;
        const uint8_t *attachmentEntryCString;
        
        for (int i = 0; i < attachmentsArrayLength; i++) {
            
            FREObject arrayElement;
            FREGetArrayElementAt(argv[0], i, &arrayElement);
            FREGetObjectAsUTF8(arrayElement, &attachmentEntryLength, &attachmentEntryCString);
            
            [attachmentsString appendString:[NSString stringWithUTF8String:(char*)attachmentEntryCString]];
            
            if (i<(attachmentsArrayLength-1))
                [attachmentsString appendString:attachmentsSeparator];
        }
    }
    
    if (instagramComposeHelper) {
    }else {
        instagramComposeHelper = [[Instagram alloc] init];
    }
    
    [instagramComposeHelper setContext:ctx];
    [instagramComposeHelper sendInstagram:attachmentsString];
    
    if (attachmentsString != nil)
        [attachmentsString release];
    
    return NULL;
    
}




//------------------------------------
//
// Context initialization and finalization
//
//------------------------------------
void EmpathVideoShareExtensionContextInitializer( void * extData,
                                        const uint8_t* ctxType,
                                        FREContext ctx,
                                        uint32_t* numFunctionsToSet,
                                        const FRENamedFunction** functionsToSet )
{
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "composeMessenger",  NULL, &composeMessenger },
        { (const uint8_t*) "composeFacebook",  NULL, &composeFacebook },
        { (const uint8_t*) "saveVideoToCameraRoll",  NULL, &saveVideoToCameraRoll},
        { (const uint8_t*) "sendInstagram",  NULL, &sendInstagram},
        { (const uint8_t*) "composeSMS",  NULL, &composeSMS},
        { (const uint8_t*) "composeMail", NULL, &composeMail}
    };
    
    *numFunctionsToSet =
    sizeof( extensionFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = extensionFunctions;
    
    g_ctx = ctx;
}


void EmpathVideoShareExtensionContextFinalizer( FREContext ctx )
{
    return;
}


//------------------------------------
//
// Extension initialization and finalization
//
//------------------------------------
void EmpathVideoShareExtensionInitializer( void** extDataToSet,
                                FREContextInitializer* ctxInitializerToSet,
                                FREContextFinalizer* ctxFinalizerToSet )
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &EmpathVideoShareExtensionContextInitializer;
    *ctxFinalizerToSet = &EmpathVideoShareExtensionContextFinalizer;
}


void EmpathVideoShareExtensionFinalizer( void* extData )
{
    //    [ cameraDelegate release ];
    return;
}