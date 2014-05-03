//
//  SRGraphicSlider.h
//  SRGraphicSlider
//
//  Created by Sylvain REUCHERAND on 03/05/2014.
//  Copyright (c) 2014 Sylvain Reucherand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRGraphicSlider : UIControl
@property (assign, nonatomic) CGFloat minimumValue;
@property (assign, nonatomic) CGFloat maximumValue;
@property (assign, nonatomic) CGFloat value;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat radius;

@property (strong, nonatomic) UIColor *minimumColor;
@property (strong, nonatomic) UIColor *maximumColor;
@end
