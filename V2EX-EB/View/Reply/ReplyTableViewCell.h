//
//  ReplyTableViewCell.h
//  V2EX-EB
//
//  Created by xjshi on 16/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

@class Reply;
@interface ReplyTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TTTAttributedLabelDelegate> tttDelegate;
@property (nonatomic, strong) Reply *reply;
- (void)setFloor:(NSInteger)floor;

@end
