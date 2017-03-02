//
//  Utility.h
//  MAL Updater OS X
//
//  Created by Tail Red on 1/31/15.
//
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "AFOAuthCredential.h"

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
+(NSString *)appendstringwithArray:(NSArray *) a;
@end
