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
@property(nonatomic,strong) NSString *twitterQuery;

@end

@implementation PLTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _data = [PLDataModel sharedManager];
    
    if(_data.locality){
        _twitterQuery = [PLUtils getTwitterQueryByLocality:_data.locality];
    }else{
        _twitterQuery = @"#criticalmaps";
    }
    
    // table
    CGRect frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 120);
    _tableVC = [[UITableViewController alloc] init];
    [_tableVC.tableView setDelegate:self];
    [_tableVC.tableView setDataSource:self];
    _tableVC.tableView.frame = frame;
    [self.view addSubview:_tableVC.tableView];
    
    _twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e0vyKNT3iC89SkUaIzEvX1oii" consumerSecret:@"151lpogCiUp4RhjRNZukl2tJSeGyskq37U8wmldFm9FDPfzBW8"];

    // navbar
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = [[NSString stringWithFormat:@"%@", _twitterQuery] uppercaseString];
    navBar.items = @[ navItem ];
    navBar.translucent = NO;
    [self.view addSubview:navBar];
    
    // refresh control
    _tableVC.refreshControl = [[UIRefreshControl alloc] init];
    _tableVC.refreshControl.backgroundColor = [UIColor magicColor];
    _tableVC.refreshControl.tintColor = [UIColor whiteColor];
    [_tableVC.refreshControl addTarget:self
                                action:@selector(onRefreshPull)
                      forControlEvents:UIControlEventValueChanged];
    
    [self loadTweets];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [_tableVC.tableView reloadData];
}


- (void)loadTweets {
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
        
        DLog(@"Access granted with %@", bearerToken);
        
        [_twitter verifyCredentialsWithSuccessBlock:^(NSString *bearerToken) {
            
            [_twitter getSearchTweetsWithQuery: _twitterQuery
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
    
    DLog(@"%@", status);
    
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
