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
    /*
     TODO: reload on notification
     */
//    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];

    
    if(!_chatModel.allMessages){
        return cell;
    }
    
    if(!(_chatModel.allMessages.count > indexPath.row)){
        return cell;
    }
    
//    PLChatObject *message = [_chatModel.allMessages objectAtIndex:_chatModel.userMessages.count - 1 - indexPath.row];
    PLChatObject *message = [_chatModel.allMessages objectForKey:_chatModel.allKeys[indexPath.row]];

    cell.textLabel.text = message.text;

    return cell;
}

- (void)onMessagesReceived {
    [self.tableView reloadData];
}


@end
