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
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) UILabel *currentLable;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;


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
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc]init];
        
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button=[[UIButton alloc]init];
            
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle];
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setTitle:titleForThisLabel forState:UIControlStateNormal];
            button.backgroundColor = colorForThisLabel;
            button.titleLabel.textColor= [UIColor whiteColor];
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        
        for (UIButton *thisButton in self.buttons) {
            [self addSubview:thisButton];
        }
//        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
//        [self addGestureRecognizer:self.tapGesture];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        [self addGestureRecognizer:self.panGesture];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        [self addGestureRecognizer:self.pinchGesture];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
        [self addGestureRecognizer:self.longPressGesture];
    }
    
    return self;
}
//-(void) labelButton: (UIButton *)sender; {
//    
//}
//-(void ) tapFired:(UITapGestureRecognizer *)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateRecognized) {
//        CGPoint location = [recognizer locationInView:self];
//        UIView *tappedView = [self hitTest:location withEvent:nil];
//        
//        if ([self.buttons containsObject:tappedView]) {
//            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UIButton*)tappedView).titleLabel.text];
//            }
//        }
//    }
//}

-(void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}

-(void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [recognizer scale];
        NSLog(@"%f",currentScale);
    
    
    if ([self.delegate respondsToSelector:@selector(floatingToolbar: didTryToPinchWithScale:)]) {
        [self.delegate floatingToolbar:self didTryToPinchWithScale: currentScale];
        
    
    }
    }
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
}

-(void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
//    UILabel *thisLabel = (UILabel *)recognizer.view;
//    thisLabel.backgroundColor = [UIColor greenColor];
    
    
    NSMutableArray* changeColors = [self.colors mutableCopy];
    for (int i=0; i < changeColors.count; ++i) {
        NSInteger remainingCount = changeColors.count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t)remainingCount);
        [changeColors exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        
    }
    
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton* button = self.buttons[i];
        button.backgroundColor = changeColors[i];
    }

    NSLog(@"Hello");
//    self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
//                    [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
//                    [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
//                    [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
//    

    
}

-(void) layoutSubviews {
    
    for (UIButton *thisButton in self.buttons) {
        NSUInteger currentLabelIndex = [self.buttons indexOfObject: thisButton];
        
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
        
        thisButton.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
        
    }
}

- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch =[touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UILabel *label = [self labelFromTouches:touches withEvent:event];
//    
//    if ([label isKindOfClass: [UILabel class]]) {
//        self.currentLable = label;
//        self.currentLable.alpha = 0.5;
//    }
//
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UILabel *label = [self labelFromTouches:touches withEvent:event];
//    
//    if (self.currentLable !=label) {
//        //The label being touches is no longer the initial label
//        self.currentLable.alpha = 1;
//    } else{
//        //the label being touches is the initial label
//        self.currentLable.alpha = 0.5;
//    }
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UILabel*label = [self labelFromTouches:touches withEvent:event];
//    
//    if (self.currentLable == label) {
//        NSLog(@"Label tapped: %@", self.currentLable.text);
//        
//        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
//            [self.delegate floatingToolbar:self didSelectButtonWithTitle:self.currentLable.text];
//        }
//    }
//    
//    self.currentLable.alpha = 1;
//    self.currentLable = nil;
//}
//
//-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.currentLable.alpha = 1;
//    self.currentLable = nil;
//}

- (void) addTarget:(id)targeted forButtonWithTitle:(NSString *)title andAction: (SEL)things setEnabled:(BOOL)enabled {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        [button addTarget:targeted action:things forControlEvents:UIControlEventTouchUpInside];
        button.userInteractionEnabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
        
    }
}

//-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
//    NSUInteger index = [self.currentTitles indexOfObject:title];
//    
//    if (index !=NSNotFound) {
//        UIButton *button = [self.buttons objectAtIndex:index];
//        button.userInteractionEnabled = enabled;
//        button.alpha = enabled ? 1.0 : 0.25;
//
//    }
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
