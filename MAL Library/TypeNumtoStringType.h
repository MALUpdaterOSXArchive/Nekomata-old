//
//  TypeNumtoStringType.h
//  MAL Library
//
//  Created by 天々座理世 on 2017/03/27.
//  Copyright © 2017 Atelier Shiori. All rights reserved. Licensed under 3-clause BSD License
//

#import <Foundation/Foundation.h>

@interface TypeNumtoStringType : NSValueTransformer
+ (Class)transformedValueClass;
- (id)transformedValue:(id)value;
@end
