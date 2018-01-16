//
//  DirectionPanGestureRecognizer.m
//  bizvideo
//
//  Created by app-dev on 2018/1/15.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "DirectionPanGestureRecognizer.h"

int const static kDirectionPanThreshold = 5;

@implementation DirectionPanGestureRecognizer

@synthesize direction = _direction;

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _endtouch=NO;
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    
       CGPoint prevPoint2 = [[touches anyObject] previousLocationInView:self.view.superview];
    _Yinfa=prevPoint2.y;
 
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (!_drag) {
        if (abs(_moveX) > kDirectionPanThreshold) {
            if (_direction == DirectionPangestureRecognizerVertical) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }else if (abs(_moveY) > kDirectionPanThreshold) {
            if (_direction == DirectionPanGestureRecognizerHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
            }else {
                _drag = YES;
            }
        }
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    _endtouch=YES  ;
   
    [super touchesEnded:touches withEvent:event];
    
 
}

- (void)reset {
    [super reset];
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
}
-(void)MYOntouch:(dtouch)ontouch{
    self.ontouch = ontouch;
}



@end
