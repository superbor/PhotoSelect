//
//  MyCollectionViewCell.m
//  PhotoSelect
//
//  Created by app-dev on 2018/1/16.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyCollectionViewCell

- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self setNeedsLayout];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 70, 70)];
      
      
   
      
        [self.contentView addSubview:_topImage];
        
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 70, 30)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blueColor];
        _botlabel.font = [UIFont systemFontOfSize:15];
        _botlabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_botlabel];
    }
    
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"layoutSubviewslayoutSubviewslayoutSubviewslayoutSubviews%@",self.urlStr);
      NSURL *url = [NSURL URLWithString:self.urlStr];
    [_topImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"errorr%@",error);
    }];
    
}

@end
