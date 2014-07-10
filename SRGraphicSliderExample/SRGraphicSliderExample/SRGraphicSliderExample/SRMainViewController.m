//
//  SRMainViewController.m
//  SRGraphicSliderExample
//
//  Created by Sylvain REUCHERAND on 03/05/2014.
//  Copyright (c) 2014 Sylvain Reucherand. All rights reserved.
//

#import "SRMainViewController.h"
#import "SRGraphicSlider.h"

@interface SRMainViewController ()

@property (weak, nonatomic) IBOutlet SRGraphicSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation SRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.slider.width = 200;
    self.slider.backgroundColor = self.view.backgroundColor;
    self.slider.cursorBackgroundColor = [UIColor colorWithRed:23/255.0f green:27/255.0f blue:36/255.0f alpha:1];
    self.slider.minimumColor = [UIColor whiteColor];
    self.slider.maximumColor = [UIColor colorWithRed:23/255.0f green:27/255.0f blue:36/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSliderValueChange:(SRGraphicSlider *)sender {
    self.valueLabel.text = [NSString stringWithFormat:@"%f", sender.value];
}

@end
