//
//  NSDate+Extend.m
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSDate+Extend.h"

@interface NSDate ()


/*
 *  清空时分秒，保留年月日
 */
@property (nonatomic,strong,readonly) NSDate *ymdDate;


@end




@implementation NSDate (Extend)





/*
 *  时间戳
 */
-(NSString *)timestamp{

    NSTimeInterval timeInterval = [self timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f",timeInterval];
    
    return [timeString copy];
}





/*
 *  时间成分
 */
-(NSDateComponents *)components{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //定义成分
    NSCalendarUnit unit=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond |NSCalendarUnitWeekday;

    return [calendar components:unit fromDate:self];
}





/*
 *  是否是今年
 */
-(BOOL)isThisYear{
    
    //取出给定时间的components
    NSDateComponents *dateComponents=self.components;
    
    //取出当前时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    //直接对比年成分是否一致即可
    BOOL res = dateComponents.year==nowComponents.year;
    
    return res;
}





/*
 *  是否是今天
 */
-(BOOL)isToday{

    //差值为0天
    return [self calWithValue:0];
}





/*
 *  是否是昨天
 */
-(BOOL)isYesToday{
    
    //差值为1天
    return [self calWithValue:1];
}


-(BOOL)calWithValue:(NSInteger)value{
    
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.ymdDate.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].ymdDate.components;
    
    //比较
    BOOL res=dateComponents.year==nowComponents.year && dateComponents.month==nowComponents.month && (dateComponents.day + value)==nowComponents.day;
    
    return res;
}

- (BOOL)isThisHour {
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    BOOL res = dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month && dateComponents.day == nowComponents.day && dateComponents.hour == nowComponents.hour;
    
    return res;
}

- (BOOL)isThisMonth {
    //得到给定时间的处理后的时间的components
    NSDateComponents *dateComponents=self.components;
    
    //得到当前时间的处理后的时间的components
    NSDateComponents *nowComponents=[NSDate date].components;
    
    BOOL res = dateComponents.year == nowComponents.year && dateComponents.month == nowComponents.month;
    
    return res;
}



/*
 *  清空时分秒，保留年月日
 */
-(NSDate *)ymdDate{
    
    //定义fmt
    NSDateFormatter *fmt=[[NSDateFormatter alloc] init];
    
    //设置格式:去除时分秒
    fmt.dateFormat=@"yyyy-MM-dd";
    
    //得到字符串格式的时间
    NSString *dateString=[fmt stringFromDate:self];
    
    //再转为date
    NSDate *date=[fmt dateFromString:dateString];
    
    return date;
}



/**
 *  两个时间比较
 *
 *  @param unit     成分单元
 *  @param fromDate 起点时间
 *  @param toDate   终点时间
 *
 *  @return 时间成分对象
 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    
    //创建日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //直接计算
    NSDateComponents *components = [calendar components:unit fromDate:fromDate toDate:toDate options:0];
    
    return components;
}


- (NSString *)description {
    
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:self.isThisYear? @"" : [NSString stringWithFormat:@"%ld年",(long)self.components.year]];
    [str appendString:(self.isYesToday || self.isToday)? @"" :[NSString stringWithFormat:@"%ld月%02ld日", (long)self.components.month, (long)self.components.day]];
    [str appendString:self.isYesToday? @"昨天": @""];
    [str appendFormat:@"%ld:%02ld", (long)self.components.hour, (long)self.components.minute];
    
    return str;
}

- (NSString *)intervalDescription {
    
    NSTimeInterval timeInterval = - [self timeIntervalSinceNow];
    
    if (timeInterval < 60) {
        return @"刚刚";
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%ld分钟前", (long)timeInterval/ 60];
    } else if (timeInterval < 3600 *24) {
        return [NSString stringWithFormat:@"%ld小时前", (long)timeInterval/ 3600];
    } else if (timeInterval < 3600 *24 *30.5) {
        return [NSString stringWithFormat:@"%ld天前", (long)timeInterval/ (3600 *24)];
    } else if (timeInterval < 3600 *24 *30.5 *12) {
        return [NSString stringWithFormat:@"%ld个月前", (long) (timeInterval/ (3600 *24 *30.5))];
    } else {
        return [NSString stringWithFormat:@"%ld年前", (long) (timeInterval/ (3600 *24 *30.5 *12))];
    }
}

+ (NSInteger)ageWithDateOfBirth:(NSDate *) birthDate;
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:birthDate toDate:[NSDate date] options:0];
    
    return components.year;
}





























@end