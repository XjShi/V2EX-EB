//
//  NodeCollectionSupplemntaryView.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "NodeCollectionSupplemntaryView.h"

@interface NodeCollectionSupplemntaryView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation NodeCollectionSupplemntaryView

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
