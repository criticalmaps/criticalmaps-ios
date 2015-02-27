//
//  PLChatViewController.m
//  CriticalMaps
//
//  Created by Norman Sander on 18.01.15.
//  Copyright (c) 2015 Pokus Labs. All rights reserved.
//

#import "PLChatViewController.h"
#import "PLChatObject.h"
#import "PLConstants.h"

@interface PLChatViewController ()

@end

@implementation PLChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataModel = [PLDataModel sharedManager];
    _chatModel = [PLChatModel sharedManager];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessagesReceived) name:kNotificationChatMessagesReceived object:_chatModel];
    
    // add table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-140)];
    self.tableView.dataSource = self;
    [self.view addSubview: self.tableView];
    
    // add textfield
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, 250, 70)];
    self.textField.layer.borderWidth = 1.0;
    [self.view addSubview: self.textField];
    
    // add button
    self.btnSend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSend.frame = CGRectMake(250,  self.view.frame.size.height-120, 70, 70);
    self.btnSend.layer.borderWidth = 1.0;
    [self.btnSend addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSend setTitle:@"send" forState:UIControlStateNormal];
    [self.view addSubview: self.btnSend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSend {
    DLog(@"send %@", self.textField.text);

    if([self.textField.text isEqualToString: @""]){
        return;
    }
    
    [_chatModel collectMessage: self.textField.text];
    self.textField.text = @"";
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _chatModel.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    
    if(!_chatModel.messages){
        return cell;
    }
    
    if(!(_chatModel.messages.count > indexPath.row)){
        return cell;
    }
    
    PLChatObject *message = [_chatModel.messages objectAtIndex:indexPath.row];

    cell.textLabel.text = message.text;
    
    if(!message.isActive){
        [cell.textLabel setTextColor:[UIColor redColor]];
    }

    return cell;
}

- (void)onMessagesReceived {
    [self.tableView reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: _chatModel.messages.count-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


@end
