//
//  IDJDatePickerViewSimple.h
//
//

#import <UIKit/UIKit.h>
#import "IDJPickerView.h"
#define MIN_YEAR 1900
#define DEFAULT_YEAR 2000
#define MAX_YEAR 2100

@interface IDJDatePickerViewSimple : UIView<IDJPickerViewDelegate>{
    int year;    
    int month;
    int day;
    IDJPickerView *picker;
    
    BOOL showYear;
}
- (id)initWithFrame:(CGRect)frame showYear: (BOOL) isShowYear;
- (void)setDate: (NSInteger) year month: (NSInteger) month day: (NSInteger) day;
@end
