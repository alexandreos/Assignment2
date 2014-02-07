//
//  SQMacros.h
//
//  Created by Alexandre Oliveira Santos on 27/08/12.
//  Copyright (c) 2012 Squadra. All rights reserved.
//
//  Macros para tratar a utilização do ARC em tempo de compilação
//

#ifndef SQMacros_h
#define SQMacros_h

#define SQARC __has_feature(objc_arc)

// -fno-objc-arc
#if ! __has_feature(objc_arc)
#define SQAutorelease(__v) ([__v autorelease])
#define SQReturnAutoreleased SQAutorelease

#define SQRetain(__v) ([__v retain]);
#define SQReturnRetained SQRetain

#define SQRelease(__v) ([__v release]);

#define SQDispatchQueueRelease(__v) (dispatch_release(__v))

#define SQNoARC(__code) __code

#else
// -fobjc-arc
#define SQAutorelease(__v)
#define SQReturnAutoreleased(__v) (__v)

#define SQRetain(__v)
#define SQReturnRetained(__v) (__v)

#define SQRelease(__v)

#define SQNoARC(__code)

#if TARGET_OS_IPHONE
// Compiling for iOS
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
// iOS 6.0 or later
#define SQDispatchQueueRelease(__v)
#else
// iOS 5.X or earlier
#define SQDispatchQueueRelease(__v) (dispatch_release(__v))
#endif
#else
// Compiling for Mac OS X
#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080
// Mac OS X 10.8 or later
#define SQDispatchQueueRelease(__v)
#else
// Mac OS X 10.7 or earlier
#define SQDispatchQueueRelease(__v) (dispatch_release(__v))
#endif
#endif
#endif

// Debug
#ifdef DEBUG
#define SQLog(format, ...) \
NSLog(@"<%s:%d> %s, " format, strrchr("/" __FILE__, '/') + 1, __LINE__, __PRETTY_FUNCTION__, ## __VA_ARGS__)
#else
// Ignora os comandos de DEBUG
#define SQLog(format, ...) {}
#endif

#define SQ_IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


/*
 *  System Versioning Preprocessor Macros
 */

#define SQ_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SQ_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SQ_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SQ_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SQ_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
