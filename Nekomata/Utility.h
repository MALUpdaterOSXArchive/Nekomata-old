//
//  Utility.h
//  MAL Updater OS X
//
//  Created by Tail Red on 1/31/15.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AFOAuth2Manager.h"

@interface Utility : NSObject
+(void)showsheetmessage:(NSString *)message
           explaination:(NSString *)explaination
                 window:(NSWindow *)w;
+(NSString *)urlEncodeString:(NSString *)string;
+(NSString *)retrieveApplicationSupportDirectory:(NSString*)append;
+(NSString *)getToken;
+(id)saveJSON:(id) object withFilename:(NSString*) filename appendpath:(NSString*)appendpath replace:(bool)replace;
+(id)loadJSON:(NSString *)filename appendpath:(NSString*)appendpath;
+(bool)deleteFile:(NSString *)filename appendpath:(NSString*)appendpath;
+(bool)checkifFileExists:(NSString *)filename appendPath:(NSString *) appendpath;
+(NSString *)appendstringwithArray:(NSArray *) a;
+(void)performTokenRefresh:(id)target forSelector:(NSString *)selector withObject:(id)object;
+(NSImage *)loadImage:(NSString *)filename withAppendPath:(NSString *)append fromURL:(NSURL *)url;
+(NSImage *)retrieveimageandsave:(NSString *) filename withAppendPath:(NSString *)append fromURL:(NSURL *)url;
@end
