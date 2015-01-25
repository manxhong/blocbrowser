//
//  BLCAwesomeFloatingToolbar.m
//  Bloc Browser
//
//  Created by Man Hong Lee on 1/24/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

@interface BLCAwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLable;

@end

@implementation BLCAwesomeFloatingToolbar

-(instancetype) initWithFourTitles:(NSArray *)titles {
    
    self= [super init];
    
    if (self) {
        
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *labelsArray = [[NSMutableArray alloc]init];
        
        for (NSString *currentTitle in self.currentTitles) {
            
            UILabel *label =[[UILabel alloc]init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        for (UILabel *thisLabel in self.labels) {
            [self addSubview:thisLabel];
        }
    }
    
    return self;
}

-(void) layoutSubviews {
    
    for (UILabel *thisLabel in self.labels) {
        NSUInteger currentLabelIndex = [self.labels indexOfObject: thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds)/2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds)/2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (currentLabelIndex < 2) {
            labelY =0;
        } else {
            
            labelY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentLabelIndex % 2 ==0) {
            
            labelX = 0;
        } else {
            
            labelX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        
    }
}

- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch =[touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if ([label isKindOfClass: [UILabel class]]) {
        self.currentLable = label;
        self.currentLable.alpha = 0.5;
    }

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel *label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLable !=label) {
        //The label being touches is no longer the initial label
        self.currentLable.alpha = 1;
    } else{
        //the label being touches is the initial label
        self.currentLable.alpha = 0.5;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UILabel*label = [self labelFromTouches:touches withEvent:event];
    
    if (self.currentLable == label) {
        NSLog(@"Label tapped: %@", self.currentLable.text);
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLable.text];
        }
    }
    
    self.currentLable.alpha = 1;
    self.currentLable = nil;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentLable.alpha = 1;
    self.currentLable = nil;
}

-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index !=NSNotFound) {
        UILabel *lable = [self.labels objectAtIndex:index];
        lable.userInteractionEnabled = enabled;
        lable.alpha = enabled ? 1.0 : 0.25;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
