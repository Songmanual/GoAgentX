//
//  GAShadowSocksService.m
//  GoAgentX
//
//  Created by messense on 12-11-16.
//  Copyright (c) 2012年 xujiwei.com. All rights reserved.
//

#import "GAShadowSocksService.h"

@implementation GAShadowSocksService

- (BOOL)hasConfigured {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"ShadowSocks:Server"] length] > 0;
}


- (NSString *)configPath {
    return nil;
}

- (NSString *)serviceName {
    return @"shadowsocks";
}

- (NSString *)serviceTitle {
    return @"shadowsocks";
}


- (BOOL)supportReconnectAfterDisconnected {
    return YES;
}

- (int)proxyPort {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ShadowSocks:LocalPort"];
}

- (bool)listenOnRemote {
    return (bool)[[NSUserDefaults standardUserDefaults] boolForKey:@"ShadowSocks:ListenOnRemote"];
}

- (NSString *)proxySetting {
    return [NSString stringWithFormat:@"SOCKS 127.0.0.1:%d; SOCKS5 127.0.0.1:%d", [self proxyPort], [self proxyPort]];
}

- (void)setupCommandRunner {
    [super setupCommandRunner];
    commandRunner.commandPath = @"./shadowsocks";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *args = [[NSMutableArray alloc] init];
    [args addObject:@"-s"];
    [args addObject:[defaults objectForKey:@"ShadowSocks:Server"]];
    [args addObject:@"-p"];
    [args addObject:[defaults objectForKey:@"ShadowSocks:ListenOnRemote"]];
    [args addObject:@"-l"];
    [args addObject:[defaults objectForKey:@"ShadowSocks:LocalPort"]];
    [args addObject:@"-k"];
    [args addObject:[defaults objectForKey:@"ShadowSocks:Password"]];
    [args addObject:@"-m"];
    int encrypt_method = [[defaults objectForKey:@"ShadowSocks:EncryptMethod"] intValue];
    if (encrypt_method == 0) {
        [args addObject:@"table"];
    } else if (encrypt_method == 1) {
        [args addObject:@"rc4"];
    }
    
    commandRunner.arguments = args;
}

@end
