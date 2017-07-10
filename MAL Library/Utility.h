//
//  Utility.h
//  MAL Updater OS X
//
//  Created by Tail Red on 1/31/15.
//  Copyright © 2017 Atelier Shiori. All rights reserved. Licensed under 3-clause BSD License
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@class AFHTTPSessionManager;
@class AFHTTPRequestSerializer;
@class AFJSONRequestSerializer;
@class AFJSONResponseSerializer;
@class AFHTTPResponseSerializer;
@class AppDelegate;
@interface Utility : NSObject
+ (void)showsheetmessage:(NSString *)message
           explaination:(NSString *)explaination
                 window:(NSWindow *)w;
+ (NSString *)urlEncodeString:(NSString *)string;
+ (NSString *)retrieveApplicationSupportDirectory:(NSString*)append;
+ (id)saveJSON:(id) object withFilename:(NSString*) filename appendpath:(NSString*)appendpath replace:(bool)replace;
+ (id)loadJSON:(NSString *)filename appendpath:(NSString*)appendpath;
+ (bool)deleteFile:(NSString *)filename appendpath:(NSString*)appendpath;
+ (bool)checkifFileExists:(NSString *)filename appendPath:(NSString *) appendpath;
+ (NSString *)appendstringwithArray:(NSArray *) a;
+ (NSImage *)loadImage:(NSString *)filename withAppendPath:(NSString *)append fromURL:(NSURL *)url;
+ (NSImage *)retrieveimageandsave:(NSString *) filename withAppendPath:(NSString *)append fromURL:(NSURL *)url;
+ (NSString *)statusFromDateRange:(NSString *)start toDate:(NSString *)end;
+ (void)donateCheck:(AppDelegate*)delegate;
+ (void)checkandclearimagecache;
+ (void)setCacheClearDate;
+ (void)clearImageCache;
+ (NSDate *)stringDatetoDate:(NSString *)stringdate;
+ (NSString *)stringDatetoLocalizedDateString:(NSString *)stringdate;
+ (AFHTTPSessionManager*)manager;
+ (AFJSONRequestSerializer *)jsonrequestserializer;
+ (AFHTTPRequestSerializer *)httprequestserializer;
+ (AFJSONResponseSerializer *) jsonresponseserializer;
+ (AFHTTPResponseSerializer *) httpresponseserializer;
@end
