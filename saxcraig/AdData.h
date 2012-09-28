//
//  AdData.h
//  saxcraig
//
//  Created by Vadim Khohlov on 9/27/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdData : NSObject

@property (nonatomic,retain) NSString* title;
@property (nonatomic,retain) NSString* link;
@property (nonatomic,retain) NSDate* date;
@property (nonatomic,retain) NSDate* created;
@property (nonatomic,retain) NSString* price;
@property (nonatomic,retain) NSString* place;
@property (nonatomic,retain) NSString* body;
@property (nonatomic,retain) NSString* thumbnailLink;

//both should be persisted:
@property (nonatomic,retain) NSString* mailto;
@property (nonatomic,retain) NSString* replyURL;

//this is for easy reference to coredata persisted entities
@property (nonatomic,retain) NSString* postingID;

//this value should not be persisted it is parsed out from ad title/body
@property (nonatomic,retain) NSString* phone;

//this field should not be persisted it is made of body
@property (nonatomic,retain) NSString* descr;

//this value should not be persisted, but should be calculated instead using current date and AdData.date
//however calculating it each time might be a performance penalty
@property (nonatomic,retain) NSString* relativeTime;

//the imageURLs values should not be persisted, they are parsed out from the ad body
//and can be replaced by file urls once we persist an ad
@property (nonatomic,retain) NSArray* imageURLs;

//favorite ad
@property (nonatomic,assign) BOOL isFavorite;

//marked off
@property (nonatomic,assign) BOOL isMarkedOff;

//was the ad viewed, this is not persisted
@property (nonatomic,assign) BOOL isViewed;

//locationData for our ad
//@property (nonatomic,retain) LocationData* locationData;

//categoryData for our ad
//@property (nonatomic,retain) CategoryData* categoryData;

@property (nonatomic,assign) BOOL hideLocation;


//just copies the fields to the existing object from some other object
//useful if you have a pointer to this object in several places and want to maintain
//one copy of an object in both places, so instead of assigning in one place (and ending up having two copies)
//you can just call this method and copy the data without the need to assign
//it might be a slight performance penalty, but it probably is worth it.
//- (void) copyDataFrom:(AdData*)data;

//marshalls to core data entity
//- (Ad*) adEntity;

//this method releases fields such as body,descr,etc. that can be reloaded
//- (void) releaseUnnecessary;

//inits from core data entity
//- (id) initWithAd:(Ad *)ad;

//checking if the ads are equal (by postingID)
//- (BOOL) isEqual:(id)object;

//- (BOOL) canFavorite;
//- (BOOL) canUnfavorite;
//- (BOOL) canCrossOff;
//- (BOOL) canUncrossOff;

//- (BOOL) isPersonalsAndCanShowImagesInPersonals;
//- (BOOL) isPersonalsWithoutImages;

@end
