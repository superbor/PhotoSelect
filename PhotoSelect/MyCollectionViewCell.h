//
//  MyCollectionViewCell.h
//  PhotoSelect
//
//  Created by app-dev on 2018/1/16.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *topImage;

@property (strong, nonatomic) UILabel *botlabel;

@property (nonatomic, copy) NSString *urlStr;
@end
