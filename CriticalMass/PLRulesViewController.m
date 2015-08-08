//
//  PLRulesViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 08.09.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLRulesViewController.h"
#import "AccordionView.h"
#import "UIColor+Helper.h"

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
        _titles = @[
                   @"Corken!?",
                   @"Gegenverkehr",
                   @"Sachte, Keule!",
                   @"Keine Vollbremsungen",
                   @"Vorne nur bei Grün",
                   @"Locker bleiben",
                   @"Hab Spaß!"
                   ];
        
        _texts = @[
                  @"Schütze Autofahrer vor sich selbst durch corken!",
                  @"Verzichte darauf auf der Gegenfahrbahn zu fahren.",
                  @"Vorne: nicht rasen!\nHinten, Lücken zufahren!",
                  @"Wenn's mal nicht anders geht, versuche die anderen per Handzeichen zu warnen.",
                  @"Wenn du an der Spitze der Mass fährst, musst du warten bis die Ampel auf Grün schaltet.",
                  @"Lass dich nicht provozieren. Sei freundlich zur Polizei und zu Autofahrern, auch wenn die's nicht sind.",
                  @"Genieße autofreie Straßen. Fahr ein bisschen mit den Sound-Rädern mit. Check die Bikes deiner Mitfahrer aus. Quatsch Autofahrer, Passanten, Mitfahrer an. Hab Spaß!"
                  ];
        
        _images = @[
                   @"Corken",
                   @"WrongLane",
                   @"Slowly",
                   @"Brake",
                   @"Green",
                   @"Friendly",
                   @"Pose"
                   ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // navbar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = [@"KNIGGE" uppercaseString];
    navBar.items = @[ navItem ];
    navBar.translucent = NO;
    [self.view addSubview:navBar];
    
    AccordionView *accordion = [[AccordionView alloc] initWithFrame:CGRectMake(0, 71, self.view.frame.size.width, self.view.frame.size.height-149)];
    [self.view addSubview:accordion];
    
    for (int i=0; i < [_images count]; i++) {
        [accordion addHeader:[self getHeader:i] withView:[self getView:i]];
    }
    
    [accordion setNeedsLayout];
    [accordion setAllowsMultipleSelection:NO];
    [accordion setAllowsEmptySelection:YES];
    accordion.startsClosed = YES;
    
    // add link to cm hamburg
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-80, self.view.frame.size.width-20, 30)];
    label.font = [UIFont systemFontOfSize:12.0f];
    NSString *labelText = NSLocalizedString(@"rules.source", nil);

    NSArray *keys = [[NSArray alloc] initWithObjects:(id)kCTForegroundColorAttributeName,(id)kCTUnderlineStyleAttributeName
                     , nil];
    NSArray *objects = [[NSArray alloc] initWithObjects:[UIColor magicColor],[NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    label.linkAttributes = linkAttributes;
    
    label.text = labelText;
    NSRange range = [labelText rangeOfString:@"criticalmass-hh.de"];
    [label addLinkToURL:[NSURL URLWithString:@"open-cmhamburg"] withRange:range];
    label.delegate = self;
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (UIButton*)getHeader:(NSInteger)index
{
    UIButton *header = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    [header setTitle:_titles[index] forState:UIControlStateNormal];
    [header setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    header.titleLabel.font = [UIFont systemFontOfSize:20];
    header.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    header.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    header.backgroundColor = [UIColor whiteColor];
    
    return header;
}


- (UIView*)getView:(NSInteger)index
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    UILabel *label = [[UILabel alloc]initWithFrame: CGRectMake(10, 0, self.view.frame.size.width-20, 80)];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.text = _texts[index];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 150)];
    imageView.image = [UIImage imageNamed:_images[index]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [view addSubview:label];
    [view addSubview:imageView];
    
    return view;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.criticalmass-hh.de"]];
}


@end
