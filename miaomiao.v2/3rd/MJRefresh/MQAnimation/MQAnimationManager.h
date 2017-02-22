//
//  MQAnimationManager.h
//  miaoqu_hl
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQAnimation.h"

typedef void(^mqAnimationSchedule)(MQAnimation *);

typedef void(^mqAnimationFinished)();

@interface MQAnimationManager : NSObject

@property (copy, nonatomic) NSMutableArray<MQAnimation *> *animations;

@property (weak, nonatomic) MQAnimation *currentAnimation;

@property (copy, nonatomic) mqAnimationFinished animationFinished;


- (void)startAnimationSchedule:(mqAnimationSchedule)schedule;

- (void)pasuseAnimation;

- (void)stopAnimation;

- (void)performLastCycle;

+ (instancetype)refreshAnimation;


@end
