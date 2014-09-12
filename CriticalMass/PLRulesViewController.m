//
//  PLSecondViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLRulesViewController.h"
#import "AccordionView.h"

@interface PLRulesViewController ()

@end

@implementation PLRulesViewController{
    NSArray *_titles;
    NSArray *_texts;
    NSArray *_images;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _titles = [NSArray arrayWithObjects:
                   @"Regel 1",
                   @"Regel 2",
                   @"Regel 3",
                   @"Regel 4",
                   @"Regel 5",
                   @"Regel 6",
                   @"Regel 7",
                   nil];
        
        _texts = [NSArray arrayWithObjects:
                  @"Schütze Autofahrer vor sich selbst durch Corken",
                  @"Versuche Team Blau nicht zu provozieren",
                  @"Verzichte darauf auf der Gegenfahrbahn zu überholen.",
                  @"Vorne, Nicht rasen!\nHinten, Lücken zufahren!",
                  @"Keine Vollbremsung, auch wenn mal was verloren geht.",
                  @"Sei freundlich zu nervösen Autofahrern",
                  @"Wenn man vorne ist: Nur bei grün fahren",
                  nil];
        
        _images = [NSArray arrayWithObjects:
                   @"Corken",
                   @"Police",
                   @"WrongLane",
                   @"Slowly",
                   @"Brake",
                   @"Friendly",
                   @"Green",
                   nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    AccordionView *accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height-90)];
    
    [self.view addSubview:accordion];
    
    for (int i=0; i < [_images count]; i++) {
        [accordion addHeader:[self getHeader:i] withView:[self getView:i]];
    }
    
    [accordion setNeedsLayout];
    [accordion setAllowsMultipleSelection:NO];
    [accordion setAllowsEmptySelection:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UIButton*)getHeader:(NSInteger)index
{
    UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    [header setTitle:_titles[index] forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont systemFontOfSize:20];
    [header setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    header.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    header.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return header;
}


- (UIView*)getView:(NSInteger)index
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 220)];
    UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(10, 0, self.view.frame.size.width-20, 50)];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = _texts[index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:_images[index]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:label];
    [view addSubview:imageView];
    
    return view;
}


@end
