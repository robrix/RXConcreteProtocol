// RXTestConcreteProtocol.h
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXConcreteProtocol.h"

@protocol RXTestProtocol
-(BOOL)isFoo;
@end

@protocol RXTestProtocol2
-(int)bar;
@end

@interface RXTestConcreteProtocol : RXConcreteProtocol <RXTestProtocol, RXTestProtocol2>
@end