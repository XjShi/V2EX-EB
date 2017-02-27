//
//  MemberReplyTableViewCell.h
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberReply.h"

@interface MemberReplyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *replyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyContentLabel;

@property (nonatomic, strong) MemberReply *reply;

@end
