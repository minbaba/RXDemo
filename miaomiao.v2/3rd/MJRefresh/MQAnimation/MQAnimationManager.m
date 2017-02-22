//
//  MQAnimationManager.m
//  miaoqu_hl
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MQAnimationManager.h"


@interface MQAnimationManager () {

    NSTimer *animationTimer;
    
    mqAnimationSchedule timeSchedule;
    
    NSArray *originArr;
    
    BOOL willStop;
}

@end

@implementation MQAnimationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        willStop = NO;
    }
    return self;
}


- (void)startAnimationSchedule:(mqAnimationSchedule)schedule {
    
    timeSchedule = schedule;
    
    if (!_animations && !_animations.count) {
        return;
    }
    _currentAnimation = [_animations firstObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            animationTimer = [[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:_currentAnimation.frameDuring target:self selector:@selector(timeSchedule) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        }
        @catch (NSException *exception) { }
    });
}

- (void)pasuseAnimation {
    animationTimer.fireDate = [NSDate distantFuture];
}


- (void)stopAnimation {
    
    [_animations removeAllObjects];
    for (MQAnimation *ani in originArr) {
        [_animations addObject:[ani copy]];
    }
    animationTimer.fireDate = [NSDate distantFuture];
    [animationTimer invalidate];
    animationTimer = nil;
    
    // 调用回调
    _animationFinished();
}

- (void)performLastCycle {
    
    _currentAnimation.repeatCount = 1;
    willStop = YES;
}


- (void)setAnimations:(NSMutableArray<MQAnimation *> *)animations {
    _animations = [animations mutableCopy];
    
    NSMutableArray *marr = [NSMutableArray array];
    for (MQAnimation *ani in animations) {
        [marr addObject:[ani copy]];
    }
    originArr = [marr copy];
}

- (void)timeSchedule {
    
    [_currentAnimation nextFrame];
    timeSchedule(_currentAnimation);
    if (!_currentAnimation.repeatCount) {
        if (_currentAnimation == [_animations lastObject]) {
            
            [self stopAnimation];
        } else {
            
            if (willStop) {
                
                [self stopAnimation];
                willStop = NO;
                return;
            }
            
            _currentAnimation = _animations[[_animations indexOfObject:_currentAnimation] +1];
            animationTimer.fireDate = [NSDate distantFuture];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                animationTimer = [[NSTimer alloc] initWithFireDate:[NSDate distantPast] interval:_currentAnimation.frameDuring target:self selector:@selector(timeSchedule) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
                [[NSRunLoop currentRunLoop] run];
            });
        }
    }
    
}

+ (instancetype)refreshAnimation {
    
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 1; i <= 90; i++) {
        [mArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"刷新_加载_%03d", i]]];
    }
    MQAnimation *loadingAnimation = [MQAnimation new];
    loadingAnimation.animationFrames = mArr;
    loadingAnimation.during = 3;
    
    MQAnimationManager *animationManager = [MQAnimationManager new];
    animationManager.animations = [@[loadingAnimation] mutableCopy];
    
    return animationManager;
}

@end
