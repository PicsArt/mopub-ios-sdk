//
//  MPAdConfiguration.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MPAdConfiguration.h"

#import "MPConstants.h"
#import "MPGlobal.h"

#import "CJSONDeserializer.h"

NSString * const kAdTypeHeaderKey = @"X-Adtype";
NSString * const kClickthroughHeaderKey = @"X-Clickthrough";
NSString * const kCustomSelectorHeaderKey = @"X-Customselector";
NSString * const kCustomEventClassNameHeaderKey = @"X-Custom-Event-Class-Name";
NSString * const kCustomEventClassDataHeaderKey = @"X-Custom-Event-Class-Data";
NSString * const kFailUrlHeaderKey = @"X-Failurl";
NSString * const kHeightHeaderKey = @"X-Height";
NSString * const kImpressionTrackerHeaderKey = @"X-Imptracker";
NSString * const kInterceptLinksHeaderKey = @"X-Interceptlinks";
NSString * const kLaunchpageHeaderKey = @"X-Launchpage";
NSString * const kNativeSDKParametersHeaderKey = @"X-Nativeparams";
NSString * const kNetworkTypeHeaderKey = @"X-Networktype";
NSString * const kRefreshTimeHeaderKey = @"X-Refreshtime";
NSString * const kScrollableHeaderKey = @"X-Scrollable";
NSString * const kWidthHeaderKey = @"X-Width";

NSString * const kInterstitialAdTypeHeaderKey = @"X-Fulladtype";
NSString * const kOrientationTypeHeaderKey = @"X-Orientation";

NSString * const kAdTypeHtml = @"html";
NSString * const kAdTypeInterstitial = @"interstitial";
NSString * const kAdTypeMraid = @"mraid";

@interface MPAdConfiguration ()

@property (nonatomic, copy) NSString *adResponseHTMLString;

- (MPAdType)adTypeFromHeaders:(NSDictionary *)headers;
- (NSString *)networkTypeFromHeaders:(NSDictionary *)headers;
- (NSTimeInterval)refreshIntervalFromHeaders:(NSDictionary *)headers;
- (NSDictionary *)dictionaryFromHeaders:(NSDictionary *)headers forKey:(NSString *)key;
- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MPAdConfiguration

@synthesize adType = _adType;
@synthesize networkType = _networkType;
@synthesize preferredSize = _preferredSize;
@synthesize clickTrackingURL = _clickTrackingURL;
@synthesize impressionTrackingURL = _impressionTrackingURL;
@synthesize failoverURL = _failoverURL;
@synthesize interceptURLPrefix = _interceptURLPrefix;
@synthesize shouldInterceptLinks = _shouldInterceptLinks;
@synthesize scrollable = _scrollable;
@synthesize refreshInterval = _refreshInterval;
@synthesize adResponseData = _adResponseData;
@synthesize adResponseHTMLString = _adResponseHTMLString;
@synthesize nativeSDKParameters = _nativeSDKParameters;
@synthesize orientationType = _orientationType;
@synthesize customEventClass = _customEventClass;
@synthesize customEventClassData = _customEventClassData;
@synthesize adSize = _adSize;
@synthesize customSelectorName = _customSelectorName;

- (id)initWithHeaders:(NSDictionary *)headers data:(NSData *)data
{
    self = [super init];
    if (self) {
        self.adResponseData = data;

        self.adType = [self adTypeFromHeaders:headers];

        self.networkType = [self networkTypeFromHeaders:headers];
        self.networkType = self.networkType ? self.networkType : @"";

        self.preferredSize = CGSizeMake([[headers objectForKey:kWidthHeaderKey] floatValue],
                                        [[headers objectForKey:kHeightHeaderKey] floatValue]);

        self.clickTrackingURL = [self URLFromHeaders:headers
                                              forKey:kClickthroughHeaderKey];
        self.impressionTrackingURL = [self URLFromHeaders:headers
                                                   forKey:kImpressionTrackerHeaderKey];
        self.failoverURL = [self URLFromHeaders:headers
                                         forKey:kFailUrlHeaderKey];
        self.interceptURLPrefix = [self URLFromHeaders:headers
                                                forKey:kLaunchpageHeaderKey];

        NSNumber *shouldInterceptLinks = [headers objectForKey:kInterceptLinksHeaderKey];
        self.shouldInterceptLinks = shouldInterceptLinks ? [shouldInterceptLinks boolValue] : YES;
        self.scrollable = [[headers objectForKey:kScrollableHeaderKey] boolValue];
        self.refreshInterval = [self refreshIntervalFromHeaders:headers];


        self.nativeSDKParameters = [self dictionaryFromHeaders:headers
                                                        forKey:kNativeSDKParametersHeaderKey];
        self.customSelectorName = [headers objectForKey:kCustomSelectorHeaderKey];

        self.orientationType = [self orientationTypeFromHeaders:headers];

        NSString *customEventClassName = [headers objectForKey:kCustomEventClassNameHeaderKey];
        self.customEventClass = NSClassFromString(customEventClassName);

        self.customEventClassData = [self dictionaryFromHeaders:headers
                                                         forKey:kCustomEventClassDataHeaderKey];
    }
    return self;
}

- (void)dealloc
{
    self.networkType = nil;
    self.clickTrackingURL = nil;
    self.impressionTrackingURL = nil;
    self.failoverURL = nil;
    self.interceptURLPrefix = nil;
    self.adResponseData = nil;
    self.adResponseHTMLString = nil;
    self.nativeSDKParameters = nil;
    self.customSelectorName = nil;
    self.customEventClassData = nil;

    [super dealloc];
}

- (BOOL)hasPreferredSize
{
    return (self.preferredSize.width > 0 && self.preferredSize.height > 0);
}

- (NSString *)adResponseHTMLString
{
    if (!_adResponseHTMLString) {
        self.adResponseHTMLString = [[[NSString alloc] initWithData:self.adResponseData
                                                           encoding:NSUTF8StringEncoding] autorelease];
    }

    return _adResponseHTMLString;
}

- (NSString *)clickDetectionURLPrefix
{
    return self.interceptURLPrefix.absoluteString ? self.interceptURLPrefix.absoluteString : @"";
}

#pragma mark - Private

- (MPAdType)adTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:kAdTypeHeaderKey];

    if ([adTypeString isEqualToString:@"interstitial"]) {
        return MPAdTypeInterstitial;
    } else if ([adTypeString isEqualToString:@"mraid"] &&
               [headers objectForKey:kOrientationTypeHeaderKey]) {
        return MPAdTypeInterstitial;
    } else if (adTypeString) {
        return MPAdTypeBanner;
    } else {
        return MPAdTypeUnknown;
    }
}

- (NSString *)networkTypeFromHeaders:(NSDictionary *)headers
{
    NSString *adTypeString = [headers objectForKey:kAdTypeHeaderKey];
    if ([adTypeString isEqualToString:@"interstitial"]) {
        return [headers objectForKey:kInterstitialAdTypeHeaderKey];
    } else {
        return adTypeString;
    }
}

- (NSURL *)URLFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSString *URLString = [headers objectForKey:key];
    return URLString ? [NSURL URLWithString:URLString] : nil;
}

- (NSDictionary *)dictionaryFromHeaders:(NSDictionary *)headers forKey:(NSString *)key
{
    NSData *data = [(NSString *)[headers objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding];
    CJSONDeserializer *deserializer = [CJSONDeserializer deserializerWithNullObject:NULL];
    return [deserializer deserializeAsDictionary:data error:NULL];
}

- (NSTimeInterval)refreshIntervalFromHeaders:(NSDictionary *)headers
{
    NSString *intervalString = [headers objectForKey:kRefreshTimeHeaderKey];
    NSTimeInterval interval = -1;
    if (intervalString) {
        interval = [intervalString doubleValue];
        if (interval < MINIMUM_REFRESH_INTERVAL) {
            interval = MINIMUM_REFRESH_INTERVAL;
        }
    }
    return interval;
}

- (MPInterstitialOrientationType)orientationTypeFromHeaders:(NSDictionary *)headers
{
    NSString *orientation = [headers objectForKey:kOrientationTypeHeaderKey];
    if ([orientation isEqualToString:@"p"]) {
        return MPInterstitialOrientationTypePortrait;
    } else if ([orientation isEqualToString:@"l"]) {
        return MPInterstitialOrientationTypeLandscape;
    } else {
        return MPInterstitialOrientationTypeAll;
    }
}

@end
