//
//  ClockView.m
//  LockoutDemo
//
//  Created by Jessie.W on 17/1/9.
//  Copyright © 2017年 Jessie.W. All rights reserved.
//

#import "ClockView.h"
#import <QuartzCore/QuartzCore.h>

#define BtnWidth   74.0
#define BtnHeight  74.0
#define Cloum     3

@interface ClockView()

@property (nonatomic, strong) NSMutableArray *selectedArray;

@property (nonatomic, assign) CGPoint currenPoint;
@end

@implementation ClockView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark - methods
- (void)setupUI {
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_selected"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [self addSubview:btn];
    }
    self.currenPoint = CGPointZero;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat betweenWidth = (CGRectGetWidth(self.frame) - 3 * BtnWidth) / (Cloum - 1);
    CGFloat betweenHeight = (CGRectGetHeight(self.frame) - 3 * BtnHeight) / (Cloum - 1);
    
    for (int i = 0; i < [self.subviews count]; i++) {
        UIButton *btn = (UIButton *)self.subviews[i];
        [btn setFrame:CGRectMake((i%Cloum) * (betweenWidth + BtnWidth), (i/Cloum) * (betweenHeight + BtnHeight), BtnWidth, BtnHeight)];
    }
}

- (CGPoint)getCurPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}

- (UIButton *)getCurrentSelectedBtn:(CGPoint)point {
    for (UIButton *btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        } else {
            self.currenPoint = point;
        }
    }
    return nil;
}

- (void)removeAllSelectedLine {
    for (UIButton *btn in self.selectedArray) {
        btn.selected = NO;
    }
    [self.selectedArray removeAllObjects];
    self.currenPoint = CGPointZero;
    [self setNeedsDisplay];
}

#pragma mark - touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint curPoint = [self getCurPoint:touches];
    UIButton *btn = [self getCurrentSelectedBtn:curPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedArray addObject:btn];
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint curPoint = [self getCurPoint:touches];
    UIButton *btn = [self getCurrentSelectedBtn:curPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectedArray addObject:btn];
    }
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(removeAllSelectedLine) withObject:nil afterDelay:1.0f];
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < [self.selectedArray count]; i++) {
        UIButton *btn = self.selectedArray[i];
        CGPoint point = btn.center;
        if (i == 0) {
            [path moveToPoint:point];
        } else {
            [path addLineToPoint:point];
        }
    }
    if (!CGPointEqualToPoint(self.currenPoint, CGPointZero)) {
        [path addLineToPoint:self.currenPoint];
    }
    path.lineWidth = 5.0f;
    [[UIColor darkGrayColor] set];
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

@end
