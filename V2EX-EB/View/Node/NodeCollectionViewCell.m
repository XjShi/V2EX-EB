//
//  NodeCollectionViewCell.m
//  V2EX-EB
//
//  Created by xjshi on 10/02/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "NodeCollectionViewCell.h"

@interface NodeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nodename;

@end

@implementation NodeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setNodeInfo:(NSDictionary *)info {
    self.nodename.text = info[@"name"];
}

@end
