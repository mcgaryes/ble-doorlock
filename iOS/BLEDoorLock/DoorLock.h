//
//  BLEConnect.h
//  BLEDoorLock
//
//  Created by Eric McGary on 10/12/13.
//  Copyright (c) 2013 Eric McGary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "BLEContants.h"

/**
 *
 */
typedef enum DoorlockState : NSUInteger {
    
    /**
     *
     */
    kConnected,
    
    /**
     *
     */
    kDisconnected,
    
    /**
     *
     */
    kConnecting,
    
    /**
     *
     */
    kDisconnecting
} DoorlockState;

@protocol DoorLockDelegate;

@interface DoorLock : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

/**
 *
 */
-(id) initWithDelegate:(id)delegate;

/**
 *
 */
-(void) connectToDoorlock;

/**
 *
 */
-(void) dissconnectFromDoorlock;

/**
 *
 */
-(void) lockDoor;

/**
 *
 */
-(void) unlockDoor;

/**
 *
 */
@property (nonatomic,strong) id<DoorLockDelegate> delegate;

/**
 *
 */
@property (nonatomic) DoorlockState state;

@end

/**
 *
 */
@protocol DoorLockDelegate <NSObject>

/**
 *
 */
- (void) doorlockDidUnlock;

/**
 *
 */
- (void) doorlockDidLock;

/**
 *
 */
- (void) doorlockDidConnect;

/**
 *
 */
- (void) doorlockDidDisconnect;

@end