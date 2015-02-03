//
//  BLCAwesomeFloatingToolbar.h
//  Bloc Browser
//
//  Created by Man Hong Lee on 1/24/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPinchWithScale:(CGFloat)pinch;


@end

@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *)titles;
- (void) addTarget:(id)targeted forButtonWithTitle:(NSString *)title andAction: (SEL)things setEnabled:(BOOL)enabled;

//- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;

@property (nonatomic, weak) id <BLCAwesomeFloatingToolbarDelegate> delegate;

@end