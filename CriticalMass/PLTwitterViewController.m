//
//  PLTwitterViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 09.11.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLTwitterViewController.h"
#import "PLLabel.h"
#import "PLConstants.h"
#import "PLTwitterTableViewCell.h"
#import "HOButton.h"


@interface PLTwitterViewController ()

@end

@implementation PLTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PLLabel *label = [[PLLabel alloc] initWithFrame:CGRectMake(0, 19, self.view.frame.size.width, 50)];
    label.text = @"Latest Tweets of #criticalmaps";
    [label setFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f]];
    [self.view addSubview:label];
    
    HOButton *reloadBtn = [[HOButton alloc] init];
    [reloadBtn setImage:[UIImage imageNamed:@"Reload"] forState:UIControlStateNormal];
    reloadBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 9, 10, 9);
    [reloadBtn addTarget:self action:@selector(onClickReload:) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.center = CGPointMake(self.view.frame.size.width-40, 40);
    [self.view addSubview:reloadBtn];
    
    CGRect frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 120);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 70.0)];
    [path addLineToPoint:CGPointMake(self.view.frame.size.width, 70.0)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blackColor] CGColor];
    shapeLayer.lineWidth = 1.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    
    [self.view.layer addSublayer:shapeLayer];
    
    //[_tableVC.tableView registerClass:[HOTwoRowViewCell class] forCellReuseIdentifier:@"CustomCell"];
    //_tableVC.tableView.tableHeaderView = [self headerView];
    
    [self.view addSubview:_tableView];
    
    
    _twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e0vyKNT3iC89SkUaIzEvX1oii" consumerSecret:@"151lpogCiUp4RhjRNZukl2tJSeGyskq37U8wmldFm9FDPfzBW8"];
    
    _loadingView = [[SAMLoadingView alloc] initWithFrame: frame];
    _loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_loadingView];
    
    [self loadTweets];
}

- (void)loadTweets {
    [_loadingView setHidden:NO];
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        NSLog(@"Access granted with %@", bearerToken);
        
        [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            
            [_twitter getSearchTweetsWithQuery: kTwitterQuery
                                  successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                      _statuses = statuses;
                                      [_tableView reloadData];
                                      [_loadingView setHidden:YES];
                    
                                  } errorBlock:^(NSError *error) {
                                      // ...
                                  }];
            
        } errorBlock:^(NSError *error) {
            // ...
        }];
        
    } errorBlock:^(NSError *error) {
        NSLog(@"-- error %@", error);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickReload:(id)sender {
    [self loadTweets];
}

#pragma mark - Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterCell"];
    
    if (cell == nil) {
        cell = [[PLTwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TwitterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        UIFont *myFont = [ UIFont fontWithName: @"Helvetica" size: 14.0 ];
        cell.textLabel.font  = myFont;
    }
    
    NSDictionary *status = [_statuses objectAtIndex:indexPath.row];
  
    NSLog(@"%@", status);
    
    NSString *profileImageURL = status[@"user"][@"profile_image_url"];
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    //NSString *dateString = [status valueForKey:@"created_at"];
    
    [cell.imageView  sd_setImageWithURL:[NSURL URLWithString: profileImageURL]
                       placeholderImage:[UIImage imageNamed:@"Twitter"]];
     
    cell.textLabel.text = [NSString stringWithFormat:@"@%@: %@", screenName, text];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
