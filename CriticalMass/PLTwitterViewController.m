//
//  PLTwitterViewController.m
//  CriticalMass
//
//  Created by Norman Sander on 09.11.14.
//  Copyright (c) 2014 Pokus Labs. All rights reserved.
//

#import "PLTwitterViewController.h"
#import "STTWitter.h"
#import "PLLabel.h"

@interface PLTwitterViewController ()

@end

@implementation PLTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PLLabel *label = [[PLLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    label.text = @"Latest Tweets of #cmberlin";
    [label setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [self.view addSubview:label];
    
    CGRect frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 120);
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.rowHeight = 300;
    
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

    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e0vyKNT3iC89SkUaIzEvX1oii" consumerSecret:@"151lpogCiUp4RhjRNZukl2tJSeGyskq37U8wmldFm9FDPfzBW8"];
    
    [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        NSLog(@"Access granted with %@", bearerToken);
        
        [twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            
            [twitter getSearchTweetsWithQuery:@"CMBerlin"
                                 successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                     _statuses = statuses;
                                     [_tableView reloadData];
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

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

#pragma mark - Data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TwitterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *status = [_statuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    CGRect rect = CGRectMake(0, 0, cell.frame.size.width, 100);
    cell.textLabel.frame = rect;
    cell.textLabel.text = text;
    cell.textLabel.layer.borderColor = [UIColor blackColor].CGColor;
    cell.textLabel.layer.borderWidth = 4.0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


@end
