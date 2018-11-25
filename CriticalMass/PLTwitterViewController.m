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
#import "PLUtils.h"
#import "PLDataModel.h"
#import "UIColor+Helper.h"


@interface PLTwitterViewController ()

@property(nonatomic,strong) STTwitterAPI *twitter;
@property(nonatomic,strong) UITableViewController *tableVC;
@property(nonatomic,strong) NSArray *statuses;
@property(nonatomic,strong) PLDataModel *data;
@property(nonatomic,assign) NSArray *supportedLocalities;

@end

@implementation PLTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [PLDataModel sharedManager];
    
    // table
    CGFloat navigationBarHeight = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGRect frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, self.view.frame.size.height-navigationBarHeight-tabbarHeight);
    _tableVC = [[UITableViewController alloc] init];
    [_tableVC.tableView setDelegate:self];
    [_tableVC.tableView setDataSource:self];
    _tableVC.tableView.frame = frame;
    [self.view addSubview:_tableVC.tableView];
    
    _twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e0vyKNT3iC89SkUaIzEvX1oii" consumerSecret:@"151lpogCiUp4RhjRNZukl2tJSeGyskq37U8wmldFm9FDPfzBW8"];
    
    self.title = [NSString stringWithFormat:@"%@", KTwitterQuery];

    
    // refresh control
    _tableVC.refreshControl = [[UIRefreshControl alloc] init];
    _tableVC.refreshControl.backgroundColor = [UIColor magicColor];
    _tableVC.refreshControl.tintColor = [UIColor whiteColor];
    [_tableVC.refreshControl addTarget:self
                                action:@selector(onRefreshPull)
                      forControlEvents:UIControlEventValueChanged];
    
    [self loadTweets];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableVC.tableView reloadData];
}


- (void)loadTweets {
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        DLog(@"Access granted with %@", bearerToken);
        [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            [_twitter getSearchTweetsWithQuery: KTwitterQuery
                                  successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                      _statuses = statuses;
                                      [_tableVC.tableView reloadData];
                                      [_tableVC.refreshControl endRefreshing];
                                      
                                  } errorBlock:^(NSError *error) {
                                      // ...
                                  }];
            
        } errorBlock:^(NSError *error) {
            // ...
        }];
        
    } errorBlock:^(NSError *error) {
        DLog(@"-- error %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickReload:(id)sender {
    [self loadTweets];
}

- (void)onRefreshPull {
    [self loadTweets];
}

#pragma mark - Data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_statuses.count) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
        return 1;
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = NSLocalizedString(@"twitter.noData", nil);
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_statuses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLTwitterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TwitterCell"];
    
    if (cell == nil) {
        cell = [[PLTwitterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TwitterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        [cell.imageView setClipsToBounds:YES];
        UIFont *myFont = [self fontForCell];
        cell.textLabel.font  = myFont;
    }
    
    NSDictionary *status = [_statuses objectAtIndex:indexPath.row];
    NSString *profileImageURL = status[@"user"][@"profile_image_url"];
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
//    NSString *dateString = [status valueForKey:@"created_at"];
    
    [cell.imageView  sd_setImageWithURL:[NSURL URLWithString: profileImageURL]
                       placeholderImage:[UIImage imageNamed:@"Avatar"]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"@%@: %@", screenName, text];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *status = [_statuses objectAtIndex:indexPath.row];
    NSString *cellText = [status valueForKey:@"text"];
    
    NSDictionary *attributes = @{NSFontAttributeName: [self fontForCell]};
    CGRect rect = [cellText boundingRectWithSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    return rect.size.height + 20;
}

- (UIFont*)fontForCell {
    return [UIFont fontWithName: @"Helvetica" size: 14.0];
}


@end
