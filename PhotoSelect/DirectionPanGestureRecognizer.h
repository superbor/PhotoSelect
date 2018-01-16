//
//  DirectionPanGestureRecognizer.h
//  bizvideo
//
//  Created by app-dev on 2018/1/15.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef enum {
    DirectionPangestureRecognizerVertical,
    DirectionPanGestureRecognizerHorizontal
} DirectionPangestureRecognizerDirection;

typedef void(^SetInfoBlock)(NSString *info);
typedef void (^dtouch)(NSSet<UITouch *> *touches ,UIEvent *event);
@interface DirectionPanGestureRecognizer : UIPanGestureRecognizer {
    
        BOOL _drag;
        int _moveX;
        int _moveY;
        CGFloat Yinfa;
        DirectionPangestureRecognizerDirection _direction;
    
}
@property (nonatomic, assign) DirectionPangestureRecognizerDirection direction;
@property (nonatomic, assign) CGFloat Yinfa;
@property (nonatomic, assign) Boolean endtouch;


@property(nonatomic,copy) __block dtouch ontouch;

-(void)MYOntouch:(dtouch)ontouch;
///////


@end
