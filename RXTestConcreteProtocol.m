// RXTestConcreteProtocol.m
// Created by Rob Rix on 2009-10-03
// Copyright 2009 Monochrome Industries

#import "RXTestConcreteProtocol.h"

@implementation RXTestConcreteProtocol

+(BOOL)canFoo {
	return YES;
}

-(BOOL)isFoo {
	return NO;
}

-(int)bar { return 0; }

@end