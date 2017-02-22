//
//  MQAnimation.h
//  miaoqu_hl
//
//  Created by apple on 16/1/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQAnimation : NSObject <NSCopying>

@property (copy, nonatomic) NSArray<id> *animationFrames;

@property (assign, nonatomic) CGFloat during;

@property (assign, nonatomic) NSInteger repeatCount;

@property (assign, nonatomic, readonly) CGFloat frameDuring;

/**
 *  动画执行方向 0:顺序 1:倒叙
 */
@property (assign, nonatomic) NSInteger animationDirection;

@property (assign, nonatomic) NSInteger currentFrame;

- (id)nextFrame;

@end
