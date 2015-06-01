//
//  bridge.m
//  meteor-ios-starter-swift
//
//  Created by Kevin Chen on 5/27/15.
//  Copyright (c) 2015 aspin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeteorClient.h"
#import "ObjectiveDDP.h"
#import <ObjectiveDDP/MeteorClient.h>

// Abstracts parts of the ObjectiveDDP library. You can now connect to any Meteor app from iOS
// with this function. See AppDelegate for its initialization.
MeteorClient* initializeMeteor(NSString* version, NSString* endpoint) {
    MeteorClient *meteorClient = [[MeteorClient alloc] initWithDDPVersion:version];
    ObjectiveDDP *ddp = [[ObjectiveDDP alloc] initWithURLString:endpoint delegate:meteorClient];
    meteorClient.ddp = ddp;
    [meteorClient.ddp connectWebSocket];
    return meteorClient;
}