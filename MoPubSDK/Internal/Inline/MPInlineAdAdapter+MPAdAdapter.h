//
//  MPInlineAdAdapter+MPAdAdapter.h
//
//  Copyright 2018-2020 Twitter, Inc.
//  Licensed under the MoPub SDK License Agreement
//  http://www.mopub.com/legal/sdk-license-agreement/
//

#import <Foundation/Foundation.h>
#import "MPAdAdapter.h"
#import "MPInlineAdAdapter.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPInlineAdAdapter (MPAdAdapter) <MPAdAdapter>

@property (nonatomic, readonly) id<MPAdAdapterInlineEventDelegate> inlineAdAdapterDelegate;

@end

NS_ASSUME_NONNULL_END
