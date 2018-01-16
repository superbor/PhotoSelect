//
//  ViewController.m
//  PhotoSelect
//
//  Created by app-dev on 2018/1/16.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "DirectionPanGestureRecognizer.h"
#import <pop/POPBasicAnimation.h>
#import "UIImageView+WebCache.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>{
    
    CGFloat topHeight;
    BOOL isbottom;
}
@property (nonatomic, strong) NSArray *sourceArr;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ViewController

- (void)viewDidLoad {
    isbottom=true;
    [super viewDidLoad];
        self.dataList = [NSMutableArray array];
       [self loadPicturesUrlDataFromPlistFile];
    topHeight=400;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _faview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1200)];
    _picImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, topHeight)];
    [_picImgView setImage:[UIImage imageNamed:@"mn"]];
    
    [self.view addSubview:_faview];
    [_faview addSubview:_picImgView];
    
    
   
    
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
  //  layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 70);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topHeight, ScreenWidth, ScreenHeight-topHeight) collectionViewLayout:layout];
    [_faview addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
      [_collectionView reloadData];
    
    //添加滑动选择手势
    DirectionPanGestureRecognizer *pan = [[DirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [pan setDelegate:self];
    [self.view addGestureRecognizer:pan];
}
//////////////////////  加载数据
- (void)loadPicturesUrlDataFromPlistFile{
    
    int BGPageCount =100;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pic_url.plist" ofType:nil];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    
       NSLog(@" self.dataList self.dataList self.dataList self.dataList self.dataList%@\n", dataArr[0]);
    NSMutableArray *copyArr = [dataArr mutableCopy];
    for (NSInteger i = 0; i < BGPageCount; i++) {
        [copyArr addObjectsFromArray:dataArr];
    }
    dataArr = [copyArr copy];
    
    NSMutableArray *spaceArr = [NSMutableArray array];
    NSMutableArray *internalArr = nil;
    for (int i = 0; i < dataArr.count; i++) {
        if (i % BGPageCount == 0) {
            internalArr = [NSMutableArray array];
            [spaceArr addObject:internalArr];
        }
        [internalArr addObject:dataArr[i]];
    }
    self.sourceArr = dataArr;
    self.dataArr = spaceArr;
    
      self.dataList = self.dataArr[0];
    NSLog(@" self.dataList self.dataList self.dataList self.dataList self.dataList%lu\n", (unsigned long)self.dataList.count);
}
////////////////// 使用手势代理
- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    
    DirectionPanGestureRecognizer *dpan=(DirectionPanGestureRecognizer *) pan;
    CGPoint translatedPoint = [pan translationInView:self.faview];
    
    CGFloat y = self.faview.center.y + translatedPoint.y;
    CGFloat Py=    self.faview.frame.origin.y;
    
    NSLog(@"_beginpoint_beginpoint_beginpoint%f",_beginpoint.y);
    if (dpan.Yinfa<topHeight) {
        
        if (y>self.faview.frame.size.height/2) {
            return;
        }
        if (y<self.faview.frame.size.height/2-300) {
            return;
        }

          self.faview.center = CGPointMake(self.faview.center.x, y);
        
        [pan setTranslation:CGPointMake(0, 0) inView:self.faview];
        
          CGFloat  fawidth=self.collectionView.frame.size.width;
          CGFloat faheight=self.collectionView.frame.size.height;
          CGFloat fax=self.collectionView.frame.origin.x;
          CGFloat fay=self.collectionView.frame.origin.y;
        self.collectionView.frame=  CGRectMake(fax, fay, fawidth, faheight-translatedPoint.y);
        if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
            if(_beginpoint.y<0){
                if(isbottom){
                    POPBasicAnimation *anim = [POPBasicAnimation animation];
                    
                    //kPOPViewAlpha
                    anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
                    
                    CGFloat ff=self.faview.center.y;
                    anim.fromValue =    [NSNumber numberWithFloat:ff];
                    anim.toValue = [NSNumber numberWithFloat:(self.faview.frame.size.height/2)-300];
                    [ self.faview pop_addAnimation:anim forKey:@"fade"];
                    
                    POPBasicAnimation *fanim = [POPBasicAnimation animation];
                    
                    //kPOPViewAlpha
                    fanim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
                    
                    
                    fanim.fromValue = [NSValue valueWithCGRect:CGRectMake(fax, fay, fawidth, faheight)];
                    fanim.toValue = [NSValue valueWithCGRect:CGRectMake(fax, fay, fawidth, ScreenHeight-100)];
                    [ self.collectionView pop_addAnimation:fanim forKey:@"fade2"];
                }
                NSLog(@"上滑");
                isbottom=false;
                
            }else{
                  NSLog(@"下滑");
                     if(!isbottom){
                POPBasicAnimation *anim = [POPBasicAnimation animation];
                
                //kPOPViewAlpha
                anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
                
                CGFloat ff=self.faview.center.y;
                anim.fromValue =    [NSNumber numberWithFloat:ff];
                anim.toValue = [NSNumber numberWithFloat:(self.faview.frame.size.height/2)];
                [ self.faview pop_addAnimation:anim forKey:@"fade"];
                
                POPBasicAnimation *fanim = [POPBasicAnimation animation];
                
                //kPOPViewAlpha
                fanim.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
                
                
                fanim.fromValue = [NSValue valueWithCGRect:CGRectMake(fax, fay, fawidth, faheight)];
                fanim.toValue = [NSValue valueWithCGRect:CGRectMake(fax, fay, fawidth, ScreenHeight-topHeight)];
                [ self.collectionView pop_addAnimation:fanim forKey:@"fade2"];
                     }
                isbottom=true;
                
//                POPBasicAnimation *anim = [POPBasicAnimation animation];
//
//                //kPOPViewAlpha
//                anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
//
//                CGFloat ff=self.faview.center.y;
//                anim.fromValue =    [NSNumber numberWithFloat:ff];
//                anim.toValue = [NSNumber numberWithFloat:(self.faview.frame.size.height/2)];
//                [ self.faview pop_addAnimation:anim forKey:@"fade"];
                
//                POPSpringAnimation *anim = [POPSpringAnimation animation];
//                anim.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
//
//                CGFloat ff=self.faview.center.y;
//                anim.fromValue =    [NSNumber numberWithFloat:ff];
//                anim.toValue = [NSNumber numberWithFloat:(self.view.frame.size.height/2)];
//                [ self.faview pop_addAnimation:anim forKey:@"fade"];
//
//
                
            }
            
            
            
            
        }else{
            _beginpoint =translatedPoint;
        }
        
        
    }else{
        
        
        
        
    }
  
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
/////////////////////////////////    collectionView代理方法
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    cell.botlabel.text = [NSString stringWithFormat:@"{%ld,%ld}",(long)indexPath.section,(long)indexPath.row];
      cell.urlStr = self.dataList[indexPath.row];
       NSURL *url = [NSURL URLWithString:  cell.urlStr];
    [cell.topImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"errorr%@",error);
    }];
       NSLog(@" cell.urlStr cell.urlStr%@", cell.urlStr);
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 130);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//    headerView.backgroundColor =[UIColor grayColor];
//    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
//    label.text = @"这是collectionView的头部";
//    label.font = [UIFont systemFontOfSize:20];
//    [headerView addSubview:label];
//    return headerView;
//}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *msg = cell.botlabel.text;
    
    cell.urlStr = self.dataList[indexPath.row];
    [cell setNeedsLayout];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
