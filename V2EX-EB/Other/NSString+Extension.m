//
//  NSString+Extension.m
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font constrainSize:(CGSize)size {
    CGSize result = CGSizeZero;
    NSDictionary *attr = @{NSFontAttributeName: font};
    result = [self boundingRectWithSize:size
                              options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                           attributes:attr
                              context:nil].size;
    return result;
}

@end
