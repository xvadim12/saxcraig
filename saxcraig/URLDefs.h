/*
 *  URLDefs.h
 *  LifelikeClassifieds
 *
 *  Created by Eugene Dorfman on 10/4/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

//#define URL_CRAIGSLIST_GEO	@"http://geo.craigslist.org/iso/us"						//for tests!!! (Blank categories list)
//#define URL_CRAIGSLIST_GEO	@"http://losangeles.craigslist.org/wst/"				//for tests!!!
//#define URL_CRAIGSLIST_GEO	URL_HTTP_SCHEME @"losangeles" @"." URL_CRAIGSLIST_BASE      //for tests!!!

#define URL_WWW                 @"www."
#define URL_HTTP_SCHEME			@"http://"
#define URL_HTTPS_SCHEME		@"https://"
#define URL_CRAIGSLIST_BASE		@"craigslist.org"
#define URL_GEO                 @"geo"
#define URL_CRAIGSLIST_GEO      URL_HTTP_SCHEME URL_GEO @"." URL_CRAIGSLIST_BASE

#define URL_ALL_SITES           URL_HTTP_SCHEME URL_WWW URL_CRAIGSLIST_BASE @"/about/sites"
#define	URL_CRAIGSLIST_CHICAGO  URL_HTTP_SCHEME @"chicago." URL_CRAIGSLIST_BASE
#define URL_INDEX_RSS           @"index.rss"
#define URL_INDEX_HTML          @"index.html"

#define URL_ACCOUNTS URL_HTTPS_SCHEME   @"accounts" @"." URL_CRAIGSLIST_BASE
#define URL_LOGIN URL_ACCOUNTS          @"/login"
#define URL_LOGOUT URL_ACCOUNTS         @"/login/logout"

#define URL_CREATE_ACCOUNT URL_LOGIN    @"/signup?rp=&rt="

#define LIFELIKE_DOMAIN         @"lifelikeapps.com"

#define CL @"/CL"

#define URL_REDIRECT_FREE_NO_HTTP LIFELIKE_DOMAIN CL
#define URL_REDIRECT_FREE URL_HTTP_SCHEME LIFELIKE_DOMAIN CL

#define URL_LIFELIKE_CRAIGSLIST URL_HTTP_SCHEME LIFELIKE_DOMAIN @"/craigslist/settings/"
#define USER_AGENT              @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/534.15 (KHTML, like Gecko) Chrome/10.0.612.3 Safari/534.15"

#define HELP_NEED_HELP_URL      URL_HTTP_SCHEME LIFELIKE_DOMAIN @"/help/Craig"
#define HELP_CRAIGSLIST_URL     URL_HTTP_SCHEME URL_WWW URL_CRAIGSLIST_BASE @"/about/help/"
#define APPLE_SUPPORT_URL       URL_HTTP_SCHEME @"www.apple.com/support/itunes/contact/"
#define BEST_OF_ALL_URL         @"http://losangeles.craigslist.org" @"/about/best/all"//URL_CRAIGSLIST_GEO @"/about/best/all"

// UNIVERSAL version
#define APPSTORE_APP_FREE_ID    @"438875956"
#define APPSTORE_APP_ID         @"408666056"

// IPHONE version
#define APP_IPHONE_FREE_ID   @"468402394"
#define APP_IPHONE_PAID_ID   @"468401854"

// IPAD version
#define APP_IPAD_FREE_ID   @"469403868"
#define APP_IPAD_PAID_ID   @"468402617"

#define HELP_RATING_FORMAT_URL         @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8"
#define APPSTORE_APP_INFO_FORMAT_URL   @"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsLookup?id=%@"
#define APPSTORE_FORMAT_URL            @"http://click.linksynergy.com/fs-bin/click?id=MAgb3nScYeo&subid=&offerid=146261.1&type=10&tmpid=3909&RD_PARM1=http%%3A%%2F%%2Fitunes.apple.com%%2Fapp%%2Flifelike-craig-hd-craigslist%%2Fid%@%%3Fmt%%3D8"
//Old linek to appstore -  @"http://itunes.apple.com/app/lifelike-craig-hd-craigslist/id%@?mt=8"
#define GIFT_FORMAT_URL              @"http://click.linksynergy.com/fs-bin/click?id=MAgb3nScYeo&subid=&offerid=146261.1&type=10&tmpid=3909&RD_PARM1=https%%3A%%2F%%2Fbuy.itunes.apple.com%%2FWebObjects%%2FMZFinance.woa%%2Fwa%%2FgiftSongsWizard%%3Fgift%%3D1%%2526salableAdamId%%3D%@%%2526productType%%3DC%%2526pricingParameter%%3DSTDQ"
//Old link to gift -  @"https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/giftSongsWizard?gift=1&salableAdamId=%@&productType=C&pricingParameter=STDQ"

#define APPLE_DOMAIN            @"apple.com"
#define TOP_LELVEL_DOMAIN_ORG   @".org/"

#define URL_IMAGE_GALLERY       URL_HTTP_SCHEME LIFELIKE_DOMAIN @"/gallery"
#define URL_IMAGE_GALLERY_POST  URL_IMAGE_GALLERY @"/post/"
#define URL_IMAGE_GALLERY_GET   URL_IMAGE_GALLERY @"/get/"

#define URL_GOOGLE_MAP_API_FORMAT @"http://maps.google.com/maps/geo?q=%@?output=json"
#define URL_BITLY_API_FORMAT      @"http://api.bit.ly/v3/shorten?login=%@&apikey=%@&longUrl=%@&format=txt"

#define URL_ACTIVE_FREE_URLS      URL_HTTP_SCHEME LIFELIKE_DOMAIN @"/craigslist/active_urls.json"
#define URL_GOOGLE_DISTANCE_MATRIX_FORMAT  @"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&sensor=false"

#define CRAIGSLIST_THUMBNAIL_FORMAT URL_HTTP_SCHEME @"images." URL_CRAIGSLIST_BASE @"/thumb/%@"
#define CRAIGSLIST_MEDIUM_THUMBNAIL_FORMAT URL_HTTP_SCHEME @"images." URL_CRAIGSLIST_BASE @"/medium/%@"
