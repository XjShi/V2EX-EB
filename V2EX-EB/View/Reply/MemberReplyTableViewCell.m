//
//  MemberReplyTableViewCell.m
//  V2EX-EB
//
//  Created by xjshi on 27/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "MemberReplyTableViewCell.h"

@implementation MemberReplyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReply:(MemberReply *)reply {
    _reply = reply;
    self.replyTitleLabel.text = [NSString stringWithFormat:@"%@  %@  %@", reply.time, reply.replyDescription, reply.topicTitle];
    self.replyContentLabel.text = reply.content;
}

@end
