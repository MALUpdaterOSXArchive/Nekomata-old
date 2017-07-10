//
//  siteimage.m
//  MAL Library
//
//  Created by 桐間紗路 on 2017/06/20.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "siteimage.h"

@implementation siteimage
+ (Class)transformedValueClass {
    return [NSImage class];
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    if ([value respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)]) {
        NSString *sitename = value;
        return [NSImage imageNamed:sitename];
    }
    return nil;
}
@end
