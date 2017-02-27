//
//  LogoutView.h
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Handler)(void);

@interface LogoutView : UIView

- (instancetype)initWithFrame:(CGRect)frame handler:(Handler)handler;

@end
