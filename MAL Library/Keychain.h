//
//  Keychain.h
//  MAL Library
//
//  Created by 天々座理世 on 2017/03/27.
//  Copyright © 2017 Atelier Shiori. All rights reserved. Licensed under 3-clause BSD License
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject
+ (BOOL)checkaccount;
+ (NSString *)getusername;
+ (BOOL)storeaccount:(NSString *)uname password:(NSString *)password;
+ (BOOL)removeaccount;
+ (NSString *)getBase64;
@end
