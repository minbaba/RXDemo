//
//  MQAnimation.m
//  miaoqu_hl
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MQAnimation.h"
#import <UIKit/UIKit.h>

@implementation MQAnimation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _repeatCount = -1;
        _during = 0;
        _currentFrame = 0;
        _animationDirection = 0;
    }
    return self;
}

- (void)setDuring:(CGFloat)during {
    
    _during = during;
    if (_animationFrames && _animationFrames.count) {
        _frameDuring = during /_animationFrames.count;
    }
}

- (void)setAnimationFrames:(NSArray<id> *)animationImages {
    
    _animationFrames = [animationImages copy];
    if (!_during) {
        self.during = animationImages.count / 30.0f;
    }
//    _currentFrame = _animationFrames.count -1;
}

- (id)nextFrame {
    
    return _animationFrames[[self nextFrameIndex]];
}

- (NSInteger)nextFrameIndex {
    
    _currentFrame += _animationDirection? -1: 1;
    
    if (_currentFrame >= _animationFrames.count) {
        _currentFrame = 0;
        _repeatCount --;
    }
    
    if (_currentFrame < 0) {
        _currentFrame = _animationFrames.count -1;
        _repeatCount --;
    }
    
    return _currentFrame;
}

- (id)copyWithZone:(NSZone *)zone {
    MQAnimation *ani = [MQAnimation new];
    ani.animationFrames = self.animationFrames;
    ani.during = self.during;
    ani.repeatCount = self.repeatCount;
    ani.animationDirection = self.animationDirection;
    ani.currentFrame = self.currentFrame;
    
    return ani;
}

//- (id)copy {
//    return [self cow]
//}


@end
