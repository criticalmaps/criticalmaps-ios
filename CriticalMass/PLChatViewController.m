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

#define kOFFSET_FOR_KEYBOARD 200.0

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataModel = [PLDataModel sharedManager];
    _chatModel = [PLChatModel sharedManager];
    
    // add table
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-140)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview: self.tableView];
    
    // add
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.tableView addGestureRecognizer:gesture];
    
    // add control
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-110, self.view.frame.size.width, 50)];
    [self.view addSubview:self.controlView];
    
    
    // add textfield
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 240, 50)];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textField.layer.cornerRadius = 3;
    self.textField.delegate = self;
    [self.controlView addSubview: self.textField];
    
    // add button
    self.btnSend = [HOButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSend.frame = CGRectMake(260,  0, 50, 50);
    self.btnSend.layer.borderWidth = 1.0;
    [self.btnSend addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSend setTitle:@"send" forState:UIControlStateNormal];
    [self.controlView addSubview: self.btnSend];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessagesReceived) name:kNotificationChatMessagesReceived object:_chatModel];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationChatMessagesReceived
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.view endEditing:YES]; // Hide keyboard
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSend {
    
    if([self.textField.text isEqualToString: @""]){
        return;
    }
    
    [_chatModel collectMessage: self.textField.text];
    self.textField.text = @"";
}

- (void)moveContent:(BOOL)moveUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rectControl = self.controlView.frame;
    CGRect rectTable = self.tableView.frame;
    if (moveUp)
    {
        rectTable.size.height -= kOFFSET_FOR_KEYBOARD;
        rectControl.origin.y -= kOFFSET_FOR_KEYBOARD;
        
    }
    else
    {
        rectTable.size.height += kOFFSET_FOR_KEYBOARD;
        rectControl.origin.y += kOFFSET_FOR_KEYBOARD;
    }
    
    self.tableView.frame = rectTable;
    self.controlView.frame = rectControl;
    
    [UIView commitAnimations];
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
    cell.imageView.image = [UIImage imageNamed:@"Punk"];
    cell.imageView.frame = CGRectMake(0,0,12,12);
    
    if(message.isActive){
        return cell;
    }
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    // Spacer is a 1x1 transparent png
    UIImage *spacer = [UIImage imageNamed:@"Spacer"];
    
    UIGraphicsBeginImageContext(spinner.frame.size);
    
    [spacer drawInRect:CGRectMake(0,0,spinner.frame.size.width,spinner.frame.size.height)];
    UIImage* resizedSpacer = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    cell.imageView.image = resizedSpacer;
    [cell.imageView addSubview:spinner];
    [spinner startAnimating];
    
    return cell;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self moveContent:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self moveContent:NO];
}

- (void)onTap:(UITapGestureRecognizer *)recognizer {
    [self.view endEditing:YES]; // Hide keyboard
}

- (void)onMessagesReceived {
    [self.tableView reloadData];
//    NSIndexPath* ipath = [NSIndexPath indexPathForRow: _chatModel.sortedMessages.count-1 inSection: 0];
//    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}


@end
