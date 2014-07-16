//
//  BLEConnect.m
//  BLEDoorLock
//
//  Created by Eric McGary on 10/12/13.
//  Copyright (c) 2013 Eric McGary. All rights reserved.
//

#import "DoorLock.h"



@interface DoorLock()

@property (nonatomic,strong) CBPeripheral* peripheral;
@property (nonatomic,strong) CBCentralManager* manager;

@end

@implementation DoorLock

#pragma mark - 

-(id) initWithDelegate:(id)delegate
{
    if(self = [super init]) {
        _delegate = delegate;
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

#pragma mark - 

-(void) connectToDoorlock
{
    [_manager connectPeripheral:_peripheral options:nil];
}

-(void) dissconnectFromDoorlock
{
    [_manager cancelPeripheralConnection:_peripheral];
}

-(void) lockDoor
{
    UInt8 buf[2] = {0x00, 0x00};
    buf[1] = 0x01;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self write:data];
}
 
-(void) unlockDoor
{
    UInt8 buf[2] = {0x00, 0x00};
    buf[1] = 0x00;
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [self write:data];
}

#pragma mark -

-(void) write:(NSData *)d
{
    CBUUID *uuid_service = [CBUUID UUIDWithString:@"713D0000-503E-4C75-BA94-3148F18D941E"];
    CBUUID *uuid_char = [CBUUID UUIDWithString:@"713D0003-503E-4C75-BA94-3148F18D941E"];
    
    // get service we'll be writing to
    CBService *service = nil;
    for(int i = 0; i < _peripheral.services.count; i++) {
        CBService *s = [_peripheral.services objectAtIndex:i];
        if([s.UUID isEqual:uuid_service]) service = s;
        
    }
    
    // get characteristic we'll be writing to
    CBCharacteristic *characteristic;
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if([c.UUID isEqual:uuid_char]) characteristic = c;
    }
    
    // check to see that neither is nil
    if (service == nil || characteristic == nil) return;
    
    // write to peripheral
    [_peripheral writeValue:d forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - CBCentralManagerDelegate Methods

-(void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_delegate doorlockDidDisconnect];
}

-(void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_delegate doorlockDidDisconnect];
}

-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
    peripheral.delegate = self;
    [_delegate doorlockDidConnect];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if(central.state == CBCentralManagerStatePoweredOn) {
        NSUUID* shield = [[NSUUID alloc] initWithUUIDString:@"12F630B3-91BF-2C5A-E04A-EEE7F599BBD8"];
        NSArray* peripherals = [_manager retrievePeripheralsWithIdentifiers:@[shield]];
        _peripheral = [peripherals objectAtIndex:0];
    }
}

#pragma mark - CBPeripheralDelegate Methods

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%@",peripheral.services);
    
    for (NSUInteger i = 0; i<peripheral.services.count; i++) {
        CBService* service = [peripheral.services objectAtIndex:i];
        if(service.isPrimary) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

@end
