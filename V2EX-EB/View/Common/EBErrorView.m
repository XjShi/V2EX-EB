//
//  EBNoMoreDataView.m
//  V2EX-EB
//
//  Created by xjshi on 19/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "EBErrorView.h"

static const CGFloat kLabelHeight = 60.f;

@interface EBErrorView ()

@property (nonatomic) UILabel *label;

@end

@implementation EBErrorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, (frame.size.height - kLabelHeight) / 2, kScreenWidth - 40, kLabelHeight)];
        _label.numberOfLines = 2;
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

@end
