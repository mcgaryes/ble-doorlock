//
//  ViewController.h
//  BLEDoorLock
//
//  Created by Eric McGary on 10/9/13.
//  Copyright (c) 2013 Eric McGary. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BLE_DEVICE_TX_UUID          "713D0003-503E-4C75-BA94-3148F18D941E"
#define BLE_DEVICE_TX_WRITE_LEN     20

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *connectionStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectedButton;
@property (weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *connectionIndicator;

@end
