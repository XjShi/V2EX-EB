//
//  UIImageView+Extension.m
//  V2EX-EB
//
//  Created by xjshi on 07/03/2017.
//  Copyright © 2017 sxj. All rights reserved.
//

#import "UIImageView+Extension.h"
#import "SDWebImageManager.h"
#import "UIImage+Extension.h"

@implementation UIImageView (Extension)

- (void)eb_setImageWithUrl:(NSString *)url size:(CGSize)size radius:(CGFloat)radius {
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    [sdManager downloadImageWithURL:[NSURL URLWithString:url]
                            options:SDWebImageRetryFailed
                           progress:NULL
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                              if (image) {
                                  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                      UIImage *result = [image imageToSize:size cornerRadius:radius];
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.image = result;
                                      });
                                  });
                              }
                          }];
}
@end
