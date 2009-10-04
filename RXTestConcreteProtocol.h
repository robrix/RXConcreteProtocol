// RXTestConcreteProtocol.h
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"

@protocol RXTestProtocol
+(BOOL)canFoo;
-(BOOL)isFoo;

@property (nonatomic, copy, readonly) NSString *foo;

@end

@protocol RXRecursiveTestProtocol
-(void)quux;
@end

@protocol RXTestProtocol2 <RXRecursiveTestProtocol>
-(int)bar;
@end

@interface RXTestConcreteProtocol : RXConcreteProtocol <RXTestProtocol, RXTestProtocol2>
@end