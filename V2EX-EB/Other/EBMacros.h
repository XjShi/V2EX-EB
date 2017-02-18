//
//  EBMacros.h
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#ifndef EBMacros_h
#define EBMacros_h

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height

//System UI control
#define kStatusBarHeight        (20.f)
#define kNavigationBarHeight    (44.0f)

//Color
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBSCOLOR(sameValue)    [UIColor colorWithRed:(sameValue)/255.0 green:(sameValue)/255.0 blue:(sameValue)/255.0 alpha:1]
#define RGBASCOLOR(sameValue,a) [UIColor colorWithRed:(sameValue)/255.0 green:(sameValue)/255.0 blue:(sameValue)/255.0 alpha:(a)]
#define RGBVCOLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue \
& 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0] //RGBVCOLOR(0x3c3c3c)
#define RGBAVCOLOR(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue \
& 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)] //RGBVCOLOR(0x3c3c3c, 0.5)

#define kOrnamentColor  RGBCOLOR(230, 239, 248)
#define kLinkColor      [UIColor blueColor]

#endif /* EBMacros_h */
