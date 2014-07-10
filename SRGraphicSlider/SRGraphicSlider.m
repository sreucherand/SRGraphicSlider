//
//  SRGraphicSlider.m
//  SRGraphicSlider
//
//  Created by Sylvain REUCHERAND on 03/05/2014.
//  Copyright (c) 2014 Sylvain Reucherand. All rights reserved.
//

#import "SRGraphicSlider.h"

typedef NS_ENUM(NSInteger, TrackingStatus) {
    TrackingNone,
    TrackingOn
};

static CGFloat const kTouchAbilitySurface = 50;

@interface SRGraphicSlider ()
{
    CGFloat _startTrackingValue;
    CGPoint _startLocation;
    
    TrackingStatus _trackingStatus;
}

@end

@implementation SRGraphicSlider

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder: decoder];
    
	if (self != nil) {
        [self setup];
    }
    
	return self;
}

- (void)setup
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _cursorBackgroundColor = [UIColor whiteColor];
    _minimumValue = 0;
    _maximumValue = 1;
    _value = 0.5;
    _width = CGRectGetWidth(self.frame);
    _lineWidth = 2;
    _radius = 5;
    _minimumColor = [UIColor colorWithRed:10/255.0f green:92/255.0f blue:255/255.0f alpha:1];
    _maximumColor = [UIColor colorWithRed:166/255.0f green:166/255.0f blue:166/255.0f alpha:1];
}

#pragma mark - Override setters

- (void)setMinimumValue:(CGFloat)minimumValue
{
    _minimumValue = minimumValue;
    
    if (self.value < minimumValue) {
        self.value = minimumValue;
    }
}

- (void)setMaximumValue:(CGFloat)maximumValue
{
    _maximumValue = maximumValue;
    
    if (self.value > maximumValue) {
        self.value = maximumValue;
    }
}

- (void)setCursorBackgroundColor:(UIColor *)cursorBackgroundColor
{
    _cursorBackgroundColor = cursorBackgroundColor;
    
    [self setNeedsDisplay];
}

- (void)setValue:(CGFloat)value
{
    if (value > self.maximumValue) {
        value = self.maximumValue;
    }
    
    if (value < self.minimumValue) {
        value = self.minimumValue;
    }
    
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    _value = value;
}

-(void)setWidth:(CGFloat)width
{
    if (width > CGRectGetWidth(self.frame)) {
        _width = CGRectGetWidth(self.frame);
        
        return;
    }
    
    _width = width;
}

#pragma mark - Values converters

- (float)valueFromTranslation:(CGFloat)translation
{
    return self.maximumValue * translation / self.width;
}

- (float)locationFromValue:(CGFloat)value
{
    return CGRectGetMinX([self calcTimelineRect]) + (CGRectGetWidth([self calcTimelineRect]) * (value - self.minimumValue) / (self.maximumValue - self.minimumValue));
}

#pragma mark - Touch events

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    
    _startLocation = location;
    
    if (CGRectContainsPoint(CGRectMake([self locationFromValue:self.value] - kTouchAbilitySurface / 2, CGRectGetMidY([self calcTimelineRect]) - kTouchAbilitySurface / 2, kTouchAbilitySurface, kTouchAbilitySurface), location)) {
        _trackingStatus = TrackingOn;
        _startTrackingValue = self.value;
        
        return YES;
    }
    _trackingStatus = TrackingNone;
    
    return [super beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    
    if (_trackingStatus == TrackingOn) {
        self.value = _startTrackingValue + [self valueFromTranslation:location.x - _startLocation.x];

        [self sendActionsForControlEvents:UIControlEventTouchDragExit];
        
        return YES;
    }
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _trackingStatus = TrackingNone;
    
    [super endTrackingWithTouch:touch withEvent:event];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    _trackingStatus = TrackingNone;
    
    [super cancelTrackingWithEvent:event];
}

#pragma mark - Draw methods

- (CGRect)calcTimelineRect
{
    CGRect frame = CGRectZero;
    
    frame.size = CGSizeMake(self.width - self.lineWidth, self.lineWidth);
    frame.origin = CGPointMake((CGRectGetWidth(self.frame) - self.width) / 2 + self.lineWidth / 2, roundf(CGRectGetHeight(self.frame) / 2 - self.lineWidth));
    
    return frame;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.maximumColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextMoveToPoint(context, CGRectGetMinX([self calcTimelineRect]), CGRectGetMidY([self calcTimelineRect]));
    CGContextAddLineToPoint(context, CGRectGetMaxX([self calcTimelineRect]), CGRectGetMidY([self calcTimelineRect]));
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, self.cursorBackgroundColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.minimumColor.CGColor);
    CGContextMoveToPoint(context, CGRectGetMinX([self calcTimelineRect]), CGRectGetMidY([self calcTimelineRect]));
    CGContextAddLineToPoint(context, [self locationFromValue:self.value], CGRectGetMidY([self calcTimelineRect]));
    
    CGContextStrokePath(context);
    
    CGContextAddArc(context, [self locationFromValue:self.value], CGRectGetMidY([self calcTimelineRect]), self.radius, 0, M_PI * 2, 1);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
