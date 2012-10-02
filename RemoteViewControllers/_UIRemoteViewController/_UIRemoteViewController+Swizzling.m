//
//  _UIRemoteViewController+Swizzling.m
//  RemoteViewControllers
//
//  Created by Ole Begemann on 02.10.12.
//  Copyright (c) 2012 Ole Begemann. All rights reserved.
//

#import "_UIRemoteViewController+Swizzling.h"
#import "_UIAsyncInvocation.h"
#import "CTBlockDescription.h"

id (*globalOriginalRequestViewController)(id, SEL, id, id, id);

typedef void (^ConnectionHandler)(id blockArg1, id blockArg2);

_UIAsyncInvocation *SwizzledRequestViewControllerFromServiceWithBundleIdentifierConnectionHandler(_UIRemoteViewController *_self, SEL _cmd, NSString *viewControllerName, NSString *serviceBundleID, id connectionHandlerBlock)
{
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"self: %@", _self);
    NSLog(@"arg1: %@ %@", [viewControllerName class], viewControllerName);
    NSLog(@"arg2: %@ %@", [serviceBundleID class], serviceBundleID);
    NSLog(@"arg3: %@ %@", [connectionHandlerBlock class], connectionHandlerBlock);
    
    // Find out signature of connectionHandlerBlock
    //CTBlockDescription *blockDescription = [[CTBlockDescription alloc] initWithBlock:connectionHandlerBlock];
    //NSMethodSignature *blockSignature = blockDescription.blockSignature;
    //NSLog(@"connectionHandlerBlock signature: %@", blockSignature);
    /*
     Result:
     
     (NSMethodSignature *) $1 = 0x0b287dd0 <NSMethodSignature: 0xb287dd0>
     number of arguments = 3
     frame size = 12
     is special struct return? NO
     return value: -------- -------- -------- --------
     type encoding (v) 'v'
     flags {}
     modifiers {}
     frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
     memory {offset = 0, size = 0}
     argument 0: -------- -------- -------- --------
     type encoding (@) '@?'
     flags {isObject, isBlock}
     modifiers {}
     frame {offset = 0, offset adjust = 0, size = 4, size adjust = 0}
     memory {offset = 0, size = 4}
     argument 1: -------- -------- -------- --------
     type encoding (@) '@'
     flags {isObject}
     modifiers {}
     frame {offset = 4, offset adjust = 0, size = 4, size adjust = 0}
     memory {offset = 0, size = 4}
     argument 2: -------- -------- -------- --------
     type encoding (@) '@'
     flags {isObject}
     modifiers {}
     frame {offset = 8, offset adjust = 0, size = 4, size adjust = 0}
     memory {offset = 0, size = 4}
     */
    
    // Replace the connectionHandlerBlock with our own implementation
    ConnectionHandler originalBlock = [(ConnectionHandler)connectionHandlerBlock copy];
    ConnectionHandler swizzledBlock = ^(id blockArg1, id blockArg2) {
        NSLog(@"connectionHandlerBlock called");
        NSLog(@"blockArg1: %@ %@", [blockArg1 class], blockArg1);
        NSLog(@"blockArg2: %@ %@", [blockArg2 class], blockArg2);
        
        // Call the original block
        (originalBlock)(blockArg1, blockArg2);
    };
    
    // Call the original implementation of the method
    _UIAsyncInvocation *returnValue = globalOriginalRequestViewController(_self, _cmd, viewControllerName, serviceBundleID, swizzledBlock);
    
    NSLog(@"Return Value: %@ %@", [returnValue class], returnValue);
    return returnValue;
}