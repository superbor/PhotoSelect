//
//  ViewController.h
//  PhotoSelect
//
//  Created by app-dev on 2018/1/16.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *faview;

@property (nonatomic, strong)  UIImageView *picImgView;
@property (assign, nonatomic) CGPoint beginpoint;
@end

