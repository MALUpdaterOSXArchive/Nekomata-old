//
//  imagecachetransformer.h
//  MAL Library
//
//  Created by 桐間紗路 on 2017/05/18.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imagecachetransformer : NSValueTransformer
+ (Class)transformedValueClass;
- (id)transformedValue:(id)value;
@end
