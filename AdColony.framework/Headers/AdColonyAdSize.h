

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 AdColonyAdSize is used to define size for Banner ads.
 */
struct AdColonyAdSize {
    CGFloat width;
    CGFloat height;
};
typedef struct CG_BOXABLE AdColonyAdSize AdColonyAdSize;

// Represents the banner ad size.
typedef struct AdColonyAdSize AdColonyAdSize;

/**
 @abstract Get a custom AdColonyAdSize
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param width height for a banner ad.
 @param height width for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeMake(CGFloat width, CGFloat height);

/**
 @abstract Get a custom AdColonyAdSize from CGSize.
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param size The size for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeFromCGSize(CGSize size);

/**
 @abstract 320 x 50
 @discussion The constant for a banner with 320 in width and 50 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeBanner;

/**
 @abstract 300 x 250
 @discussion The constant for a banner with 300 in width and 250 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeMediumRectangle;

/**
 @abstract 728 x 90
 @discussion The constant for a banner with 728 in width and 90 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeLeaderboard;

/**
 @abstract 160 x 600
 @discussion The constant for a banner with 160 in width and 600 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeSkyscraper;


NS_ASSUME_NONNULL_END
