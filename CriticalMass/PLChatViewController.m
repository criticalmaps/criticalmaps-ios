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
    [self.view addSubview: self.tableView];
    
    // add textfield
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-110, 240, 50)];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.textField.layer.cornerRadius = 3;
    
    [self.view addSubview: self.textField];
    
    // add button
    self.btnSend = [HOButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnSend.frame = CGRectMake(260,  self.view.frame.size.height-110, 50, 50);
    self.btnSend.layer.borderWidth = 1.0;
    [self.btnSend addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSend setTitle:@"send" forState:UIControlStateNormal];
    [self.view addSubview: self.btnSend];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessagesReceived) name:kNotificationChatMessagesReceived object:_chatModel];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationChatMessagesReceived
                                                  object:nil];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.textField])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    CGRect rectTable = self.tableView.frame;
    if (movedUp)
    {
        rectTable.origin.y += kOFFSET_FOR_KEYBOARD;
        rectTable.size.height -= kOFFSET_FOR_KEYBOARD;
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rectTable.origin.y -= kOFFSET_FOR_KEYBOARD;
        rectTable.size.height += kOFFSET_FOR_KEYBOARD;
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    self.tableView.frame = rectTable;
    
    [UIView commitAnimations];
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

- (void)onMessagesReceived {
    [self.tableView reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow: _chatModel.messages.count-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}


@end
