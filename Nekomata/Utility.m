//
//  Utility.m
//  MAL Updater OS X
//
//  Created by Tail Red on 1/31/15.
//
//

#import "Utility.h"
#import "EasyNSURLConnection.h"

@implementation Utility
+(void)showsheetmessage:(NSString *)message
            explaination:(NSString *)explaination
                 window:(NSWindow *)w {
    // Set Up Prompt Message Window
    NSAlert * alert = [[NSAlert alloc] init];
    [alert addButtonWithTitle:@"OK"];
    [alert setMessageText:message];
    [alert setInformativeText:explaination];
    // Set Message type to Warning
    [alert setAlertStyle:NSInformationalAlertStyle];
    // Show as Sheet on Preference Window
    [alert beginSheetModalForWindow:w
                      modalDelegate:self
                     didEndSelector:nil
                        contextInfo:NULL];
}
+(NSString *)urlEncodeString:(NSString *)string{
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                  NULL,
                                                                                                  (CFStringRef)string,
                                                                                                  NULL,
                                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                  kCFStringEncodingUTF8 ));
}
+(NSString *)retrieveApplicationSupportDirectory:(NSString*)append{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError * error;
    NSString * bundlename = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    append = [NSString stringWithFormat:@"bundlename/%@", bundlename];
    NSURL * path = [filemanager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:true error:&error];
    NSString * dir = [NSString stringWithFormat:@"%@/%@",[path path],append];
    if (![filemanager fileExistsAtPath:dir isDirectory:nil]){
        NSError * ferror;
        bool success = [filemanager createDirectoryAtPath:dir withIntermediateDirectories:true attributes:nil error:&ferror];
        if (success && ferror == nil){
            return dir;
        }
        return @"";
    }
    return dir;
}

@end
