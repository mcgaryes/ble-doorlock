//
//  ViewController.m
//  BLEDoorLock
//
//  Created by Eric McGary on 10/9/13.
//  Copyright (c) 2013 Eric McGary. All rights reserved.
//

#import "ViewController.h"
#import "DoorLock.h"

@interface ViewController () <DoorLockDelegate>

@property (nonatomic,strong) DoorLock* doorlock;

@end

@implementation ViewController

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    if(self == [super initWithCoder:aDecoder]) {
        _doorlock = [[DoorLock alloc] initWithDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set initial view states
    _connectedButton.hidden = NO;
    _disconnectButton.hidden = YES;
    _connectionStateLabel.text = @"Disconnected";
    _lockButton.hidden = _unlockButton.hidden = YES;
    _connectionIndicator.hidden = YES;
    [_connectionIndicator stopAnimating];
}

#pragma mark - DoorLockDelegate Methods

-(void) doorlockDidConnect
{
    _connectedButton.hidden = YES;
    _disconnectButton.hidden = NO;
    _connectionStateLabel.text = @"Connected";
    _lockButton.hidden = _unlockButton.hidden = NO;
    _connectionIndicator.hidden = YES;
    [_connectionIndicator stopAnimating];
}

-(void) doorlockDidDisconnect
{
    _connectedButton.hidden = NO;
    _disconnectButton.hidden = YES;
    _connectionStateLabel.text = @"Disconnected";
    _lockButton.hidden = _unlockButton.hidden = YES;
    _connectionIndicator.hidden = YES;
    [_connectionIndicator stopAnimating];
}

-(void) doorlockDidLock
{
    NSLog(@"doorlockDidLock");
}

-(void) doorlockDidUnlock
{
    NSLog(@"doorlockDidUnlock");
}

#pragma mark - IBActions

- (IBAction)lock:(id)sender {
    [_doorlock lockDoor];
}

- (IBAction)unlock:(id)sender {
    [_doorlock unlockDoor];
}

- (IBAction)connectToShield:(id)sender {
    [_doorlock connectToDoorlock];
}

- (IBAction)disconnectFromSheild:(id)sender {
    [_doorlock dissconnectFromDoorlock];
}

@end
