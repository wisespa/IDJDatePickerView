//
//  DJDatePickerView.m
//
//  Created by Lihaifeng on 11-11-22, QQ:61673110.
//  Copyright (c) 2011年 www.idianjing.com. All rights reserved.
//

#import "IDJDatePickerViewSimple.h"
#import "IDJCalendarUtil.h"

@interface IDJDatePickerViewSimple (Private)
- (void)changeDays;
@end

@implementation IDJDatePickerViewSimple

#pragma mark -init method-
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        year = DEFAULT_YEAR;
        month = 1;
        day = 1;
        picker=[[IDJPickerView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) dataLoop:YES];
        picker.delegate=self;
        [self addSubview:picker];
        
        //程序启动后，我们需要让三个滚轮显示为当前的日期
        [picker selectCell: month - 1 inScroll:1];
        [picker selectCell: day - 1 inScroll:2];
    }
    return self;
}

- (void)showYear: (BOOL) isShowYear {
    if (showYear == isShowYear) {
        return;
    }
    showYear = isShowYear;
    [picker reloadScroll:0];

    if(showYear) {
        [picker selectCell: DEFAULT_YEAR - MIN_YEAR inScroll:0];
    } 
}

#pragma mark -The function callback of IDJPickerView-
//指定每一列的滚轮上的Cell的个数
- (NSUInteger)numberOfCellsInScroll:(NSUInteger)scroll {
    int result = 0;
    switch (scroll) {
        case 0:
            if(showYear) {
                result = MAX_YEAR - MIN_YEAR + 1;
            } else {
                result = 5;
            }
            break;
        case 1:
            result = 12;//month
            break;
        case 2:
            if(month == 1 || month == 3 || month == 5 || month == 7
               || month == 8 || month == 10 || month == 12) {
                result = 31;
            } else if (month == 2) {
                result = 29;
            } else {
                result = 30;
            }
            break;
        default:
            break;
    }
    
    return  result;
}

//指定每一列滚轮所占整体宽度的比例，以:分隔
- (NSString *)scrollWidthProportion {
    return @"1:1:1";
}

//指定有多少个Cell显示在可视区域
- (NSUInteger)numberOfCellsInVisible {
    return 3;
}

//为指定滚轮上的指定位置的Cell设置内容
- (void)viewForCell:(NSUInteger)cell inScroll:(NSUInteger)scroll reusingCell:(UITableViewCell *)tc {
    tc.textLabel.textAlignment=UITextAlignmentCenter;
    tc.selectionStyle=UITableViewCellSelectionStyleNone;
    [tc.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    switch (scroll) {
        case 0:{
            if (showYear) {
                tc.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"%d", nil) , cell + MIN_YEAR];
            }
            break;
        }
        case 1:{
            tc.textLabel.text=[NSString stringWithFormat:NSLocalizedString(@"Month%d", nil) , cell+1];
            break;
        }
        case 2:{
            tc.textLabel.text=[NSString stringWithFormat:@"%d", cell+1];
            break;
        }
        default:
            break;
    }
}

//设置选中条的位置
- (NSUInteger)selectionPosition {
    return 1;
}

//当滚轮停止滚动的时候，通知调用者哪一列滚轮的哪一个Cell被选中
- (void)didSelectCell:(NSUInteger)cell inScroll:(NSUInteger)scroll {
    switch (scroll) {
        case 0:
            year = MIN_YEAR + cell;
            break;
        case 1:{
            month = cell + 1;
            [self changeDays];
            break;
        }
        case 2:{
            day = cell + 1;
            break;
        }
        default:
            break;
    }
}

#pragma mark -Calendar Data Handle-
//动态改变日期列表
- (void)changeDays{
    [picker reloadScroll:2];
    int maxDays = [self numberOfCellsInScroll:2];
    if (day > maxDays) {
        day = 1;//假如用户上次选择的是1月31日，当月份变为2月的时候，第三列的滚轮不可能再选中31日，我们设置默认的值为第一个
    }
    [picker selectCell:day - 1 inScroll:2];
}

- (void)setDate: (NSInteger) newYear month:(NSInteger) newMonth day: (NSInteger) newDay {
    year = newYear;
    month = newMonth;
    day = newDay;
    
    [picker reloadScroll:1];
    [picker reloadScroll:2];
    
    if (showYear) {
        [picker selectCell:year - MIN_YEAR inScroll:1];
    }
    [picker selectCell:month - 1 inScroll:1];
    [picker selectCell:day - 1 inScroll:2];
}

#pragma mark -dealloc-
- (void)dealloc{
    [picker release];
    [super dealloc];
}

@end
