//
//  Defs.h
//  saxcraig
//
//  Created by Vadim A. Khohlov on 9/12/12.
//  Copyright (c) 2012 Vadim A. Khohlov. All rights reserved.
//

/*
 *  Defs.h
 *  LifelikeClassifieds
 *
 *  Created by Eugene Dorfman on 10/4/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#define THE_CRAIGSLIST_TIMES @"The Craigslist Times"
#define THE_CRAIGSLIST       @"The Craigslist"
#define CRAIGSLIST_TIMES @"Craigslist Times"
#define CRAIGSLIST @"Craigslist"

#define STORAGE_PATH @"ClassifiedsLocalStorage"
#define STATES_PATH @"states"
#define CITIES_AND_STATES_PATH @"citiesAndStates"

#define FORMAT_TXT @"txt"

#define KEY_LOCATION @"location"
#define KEY_CATEGORY @"category"
#define KEY_NAME @"name"
#define KEY_CREATED @"created"
#define KEY_DATE  @"date"
#define KEY_PARENT @"parent"
#define KEY_IS_CURRENT @"isCurrent"
#define KEY_LOGIN @"login"
#define KEY_TYPE @"type"
#define KEY_IS_SELECTED @"isSelected"
#define KEY_TITLE @"title"
#define KEY_HREF @"href"
#define KEY_SEQUENCE @"sequence"
#define KEY_CONTINENT @"continent"
#define KEY_LINK @"link"
#define KEY_POSTING_ID @"postingID"
#define KEY_IS_FAVORITE @"isFavorite"
#define KEY_IS_AUTOLOCATED @"isAutolocated"
#define KEY_PARSING_RESULT @"parsingResult"
#define KEY_DISPATCH_TYPE @"dispatchType"
#define KEY_REQUEST @"request"
#define KEY_CITY_MARKER @"cityMarker"
#define KEY_SEARCHSTRING @"searchString"
#define KEY_DISPLAY_NAME @"displayName"
#define KEY_STATE @"state"
#define KEY_LOCATION_ID @"location_id"
#define KEY_EMAIL @"email"
#define KEY_URL @"url"
#define KEY_SEARCH_NAME @"searchString"
#define KEY_ORIGINAL_HTML_STRING @"original_html_string"
#define KEY_IS_LAST_POST_VIEW @"is_last_post_view"

//these defines are needed for posting error notifications from RequestHandlers
#define KEY_ERROR_NAME @"error_name"
#define ERROR_REACHABILITY_CONNECTION @"ERROR_REACHABILITY_CONNECTION"
#define ERROR_REACHABILITY_WEBSITE @"ERROR_REACHABILITY_WEBSITE"
#define ERROR_REQUEST @"ERROR_REQUEST"

#define KEY_GROUPS @"groups"
#define KEY_GROUP_NAMES @"group_names"
#define KEY_NEXT_URL @"next_url"
#define KEY_NEIGHBORHOODS @"neighborhoods"
#define KEY_SQFT @"sqft"
#define KEY_SUBLOCATIONS @"sublocations"
#define KEY_LOCATION_NAME @"location_name"
#define KEY_CATEGORY_NAME @"category_name"
#define KEY_REQUEST_INFO @"request_info"
#define KEY_TOP_CATEGORY_HREF @"top_category_href"
#define KEY_INPUT_EMAIL_HANDLE @"inputEmailHandle"
#define KEY_INPUT_PASSWORD @"inputPassword"
#define KEY_POST_FORM_DATA @"postFormData"
#define KEY_POST_HTML_STRING @"htmlString"
#define KEY_POST_TOP_HTML_STRING @"topHtmlString"
#define KEY_IS_LOGGED_IN @"isLoggedIn"
#define KEY_ERROR @"error"
#define KEY_IMAGE @"image"
#define KEY_GALLERY_ID @"key_gallery_id"
#define KEY_GALLERY_IMAGE_URLS @"key_gallery_image_urls"
#define KEY_POST_IMAGE_URL @"post_image_url"
#define KEY_AD_DATA @"key_ad_data"

#define IMG_BUTTON @"button"
#define IMG_BLACK_BUTTON @"blackButtonImage"
#define SEPARATOR @"_"

#define KEY_FILE @"file://"

#define KEY_TOP_TITLE @"topTitle"
#define KEY_CATEGORIES @"categories"

#define TAG_NEIGHBORHOODS 5
#define TAG_SEARCHOPTIONS 10
#define TAG_SORTBYTYPE 15
#define TAG_GROUPBYTYPE 20
#define TAG_BEDROOMS 25

#define IMG_BUTTON_LOCATION		IMG_BUTTON	SEPARATOR	@"location"
#define IMG_BUTTON_FAVORITES	IMG_BUTTON	SEPARATOR	@"favorites"
#define IMG_BUTTON_FONT_SIZE	IMG_BUTTON	SEPARATOR	@"fontsize"
#define IMG_BUTTON_REFRESH		IMG_BUTTON	SEPARATOR	@"refresh"
#define IMG_BUTTON_ADS      	IMG_BUTTON	SEPARATOR	@"ads"
#define IMG_BUTTON_INFO			IMG_BUTTON	SEPARATOR	@"info"
#define IMG_BUTTON_PARCEL		IMG_BUTTON	SEPARATOR	@"parcel"
#define IMG_BUTTON_BACK			IMG_BUTTON	SEPARATOR	@"back"
#define IMG_BUTTON_SEARCHES		IMG_BUTTON	SEPARATOR	@"searches"

#define IMAGE_BUTTON_BACK @"button_back"
#define IMAGE_BUTTON_ADS @"button_ads"
#define IMAGE_BUTTON_BACK_SHADOW @"button_back_shadow"
#define IMAGE_BUTTON_ADS_SHADOW @"button_ads_shadow"
#define IMAGE_BUTTON_ADS_LIST_SCALED_SIZE @"ads_scaled_size"
#define IMAGE_BUTTON_ADS_LIST_NORMAL_SIZE @"ads_normal_size"
#define IMAGE_BUTTON_ADS_LIST_SCALED_SIZE_OFF @"ads_scaled_size_off"
#define IMAGE_BUTTON_ADS_LIST_NORMAL_SIZE_OFF @"ads_normal_size_off"

#define IMG_BTN_IN_APP_PURCHASE         @"button_in_app_purchase"
#define IMG_BTN_PURCHASE                @"button_purchase"

#define IMG_SEARCH_RED_BOOKMARK              @"search_red_bookmark"
#define IMG_SEARCH_GRAY_BOOKMARK             @"search_gray_bookmark"
#define IMG_SEARCH_BLACK_VERTIVCAL_BOOKMARK  @"search_black_vertical_bookmark"

#define IMG_ICON_BULLET					@"icon_bullet"
#define	IMG_ICON_GEAR					@"icon_gear"
#define IMG_ICON_ARROW					@"icon_arrow"
#define IMG_ICON_FILTER_STAR			@"icon_filter_star"
#define BUTTON_FILTERS                  @"button_filters"
#define BUTTON_FILTERS_ON               @"button_filters_on"
#define IMG_ICON_ARROW_UP               @"button_arrow_up"

#define IMG_BACKGROUND_CATEGORY			@"background_category"
#define IMG_BACKGROUND_CATEGORY_TITLE	@"background_category_title"
#define IMG_BACKGROUND_LIST_TITLE		@"background_list_title"
#define IMG_BACKGROUND_ALERT_VIEW		@"background_alert_view"
#define IMG_BACKGROUND_DESK				@"background_desk"


#define IMG_OTHER_APPS_HORIZONTAL		@"other_apps_horizontal"
#define IMG_WHITE_BUTTON				@"button_background_white"
#define IMG_WHITE_BUTTON_SHADOW			@"button_background_white_shadow"
#define BUTTON_BACKGROUND_GRAY          @"button_background_gray"
#define BUTTON_ALERT_GRAY               @"button_alert_gray"

#define IMG_DROPDOWN_BLACK				@"dropdown_black"
#define IMG_TOOLBAR_DROPDOWN	    	@"toolBar_dropdown"
#define IMG_DROPDOWN_SMALL				@"dropdown_small"
#define IMG_DROPDOWN_ROUND				@"dropdown_round"

#define IMG_FAVORITE_CIRCLE				@"favorite-circle"
#define IMG_MARKED_OFF					@"marked_off"

#define BUTTON_RIGHT_SEARCH             @"search_bar_right_element"
#define IMG_SEARCHBAR_EXTENSION         @"searchbar_extension"
#define BUTTON_SAVE_SEARCH              @"button_save_search"

#define BTN_INDEX_BACK 0
#define BTN_INDEX_ADS_SCALE 1
#define BTN_INDEX_LOCATION 2
#define BTN_INDEX_SEARCHES 3
#define BTN_INDEX_FAVORITES 4
#define BTN_INDEX_FONT_SIZE 5
#define BTN_INDEX_ADS 6
#define BTN_INDEX_INFO 7
#define BTN_INDEX_PARCEL 8

#define BTN_INDEX_FIRST BTN_INDEX_BACK
#define BTN_INDEX_LAST BTN_INDEX_PARCEL

// ad images
#define IMG_AD_MARKED					@"ad_marked_ad"
#define IMG_AD_TOOLBAR_SHADOW			@"ad_toolbar_shadow"
#define IMG_AD_FAVORITE_STAR			@"ad_favorite_star"
#define IMG_AD_MAP_CLOSE_BUTTON			@"ad_map_close_button"
#define IMG_AD_MAP_CLOSE_BUTTON_IPHONE  @"iphone_ad_map_close_button"

// ad buttons images
#define IMG_AD_MAP						@"ad_button_map"
#define IMG_AD_FORWARD					@"ad_button_forward"
#define IMG_AD_REPLY					@"ad_button_reply"
#define IMG_AD_FLAG                     @"ad_button_flag"
#define IMG_AD_FACEBOOK                 @"ad_button_facebook"
#define IMG_AD_TWITTER                  @"ad_button_twitter"
#define IMG_AD_MAIL                     @"ad_button_mail"
#define IMG_AD_PRINT                    @"ad_button_print"

#define IMG_AD_ADD_TO_FAVORITES			@"ad_button_add_to_favorites"
#define IMG_AD_REMOVE_FAVORITE			@"ad_button_remove_favorite"

// checkbox images
#define CHECKBOX                        @"checkbox"
#define CHECKBOX_PRESSED                @"checkbox-pressed"
#define CHECKBOX_CHECKED                @"checkbox-checked"

#define AD_BTN_INDEX_FLAG 0
#define AD_BTN_INDEX_FAVORITE 1
#define AD_BTN_INDEX_MAP 2
#define AD_BTN_INDEX_PRINT 3
#define AD_BTN_INDEX_REPLY 4
#define AD_BTN_INDEX_FACEBOOK 5
#define AD_BTN_INDEX_TWITTER 6
#define AD_BTN_INDEX_MAIL 7
#define AD_BTN_INDEX_ORIGINAL_AD 8

#define AD_BTN_INDEX_FIRST AD_BTN_INDEX_FLAG
#define AD_BTN_INDEX_LAST AD_BTN_INDEX_ORIGINAL_AD

// reply popover button tags
#define POP_BTN_REPLY_ON_FACABOOK 1
#define POP_BTN_REPLY_ON_TWITTER 2
#define POP_BTN_REPLY_BY_EMAIL 3

#define TOOLBAR_HEIGHT 49.0f
#define SORTING_VIEW_H 35.f

#define IMG_BUTTON_SELECTED             @"selected_button"

// iPhone bottom toolbar images
#define IPHONE_BTN_FLAG					@"iphone_btn_flag"
#define IPHONE_BTN_SHARE				@"iphone_btn_share"
#define IPHONE_BTN_MAP					@"iphone_btn_map"
#define IPHONE_BTN_MORE					@"iphone_btn_more"
#define IPHONE_BTN_FONTSIZE				@"iphone_btn_fontsize"
#define IPHONE_BTN_LOCATION				@"iphone_btn_location"
#define IPHONE_BTN_CATEGORIES			@"iphone_btn_categories"
#define IPHONE_BTN_FAVORITES			@"iphone_btn_favorites"
#define IPHONE_BTN_SEARCH				@"iphone_btn_search"
#define IPHONE_BTN_SETTINGS				@"iphone_btn_settings"

#define IPHONE_BTN_FLAG_SELECTED		@"iphone_btn_flag_selected"
#define IPHONE_BTN_SHARE_SELECTED		@"iphone_btn_share_selected"
#define IPHONE_BTN_MAP_SELECTED			@"iphone_btn_map_selected"
#define IPHONE_BTN_MORE_SELECTED		@"iphone_btn_more_selected"
#define IPHONE_BTN_FONTSIZE_SELECTED	@"iphone_btn_fontsize_selected"
#define IPHONE_BTN_LOCATION_SELECTED	@"iphone_btn_location_selected"
#define IPHONE_BTN_CATEGORIES_SELECTED	@"iphone_btn_categories_selected"
#define IPHONE_BTN_FAVORITES_SELECTED	@"iphone_btn_favorites_selected"
#define IPHONE_BTN_SEARCH_SELECTED		@"iphone_btn_search_selected"
#define IPHONE_BTN_SETTINGS_SELECTED	@"iphone_btn_settings_selected"

#define IPHONE_BTN_SAVE_SEARCH          @"iphone_btn_save_search"
#define IPHONE_BTN_SAVED_SEARCHES       @"iphone_btn_saved_searches"

#define IPHONE_BOTTOM_TOOLBAR			@"iphone_bottom_toolbar"
#define IPHONE_MORE_BACKGROUND			@"iphone_more_background"
#define IPHONE_FONTSIZE_BACKGROUND		@"iphone_fontsize_background"

#define IPHONE_TOOLBAR_BTN_1  0
#define IPHONE_TOOLBAR_BTN_2  1
#define IPHONE_TOOLBAR_BTN_3  2
#define IPHONE_TOOLBAR_BTN_4  3
#define IPHONE_TOOLBAR_BTN_5  4
#define IPHONE_BTN_BACK_INDEX 5
#define IPHONE_BTN_EDIT_INDEX 6

// iPhone top toolbar images
#define IPHONE_BTN_BACK					@"iphone_btn_back"
#define IPHONE_BTN_BACK_BROWN			@"iphone_btn_back_brown"
#define IPHONE_BTN_REPLY				@"iphone_btn_reply"
#define IPHONE_BTN_REPLY_SHADOW			@"iphone_btn_reply_shadow"
#define IPHONE_TOP_TOOLBAR				@"iphone_top_toolbar"

#define IPHONE_AD_BTN_LIST_FRONT_INDEX 10
#define IPHONE_AD_BTN_LIST_BACK_INDEX 11
#define IPHONE_AD_BTN_REPLY_INDEX 12
#define IPHONE_AD_BTN_FAVORITE_INDEX 13
#define IPHONE_AD_BTN_PRINT_INDEX 14

#define IPHONE_AD_BTN_INDEX_FIRST IPHONE_AD_BTN_LIST_FRONT_INDEX
#define IPHONE_AD_BTN_INDEX_LAST IPHONE_AD_BTN_PRINT_INDEX
#define IPHONE_AD_BTN_ORIGINAL_AD_INDEX 15

#define IPHONE_AD_FAVORITE_STAR			@"iphone_ad_favorite_star"
#define IPHONE_AD_ADD_TO_FAVORITES		@"iphone_ad_button_add_to_favorites"
#define IPHONE_AD_REMOVE_FROM_FAVORITES	@"iphone_ad_button_remove_from_favorites"
#define IPHONE_AD_LIST_FRONT            @"iphone_ad_button_list_front"
#define IPHONE_AD_LIST_BACK             @"iphone_ad_button_list_back"
#define IPHONE_AD_REPLY                 @"iphone_ad_button_reply"
#define IPHONE_AD_PRINT                 @"iphone_ad_button_print"

// iPhone moreController images
#define IPHONE_POST_AN_AD_IMG			@"iphone_post_an_ad"
#define IPHONE_MY_ACCOUNT_IMG			@"iphone_my_account"
#define IPHONE_SETTINGS_IMG				@"iphone_settings"
#define IPHONE_HELP_IMG					@"iphone_help"
#define IPHONE_GIFT_IMG                 @"iphone_gift"
#define IPHONE_WHAT_IN_FULL             @"iphone_what_in_paid"
#define IPHONE_HEADER_SEPARATOR			@"iphone_header_separator"

// iPhone search images
#define IPHONE_IMG_FILTERS				@"iphone_img_filters"
#define IPHONE_IMG_SORTING				@"iphone_img_sorting"
#define IPHONE_BTN_FILTERS				@"iphone_btn_filters"
#define IPHONE_BTN_FILTERS_ON			@"iphone_btn_filters_on"

// fonts
#define FONT_BIG_CASLON_MEDIUM @"BigCaslonMedium"
#define FONT_LUCIDA_GRANDE_REGULAR @"Lucida_Grande_Regular"
#define FONT_HELVETICA_NEUE_CONDENSED_BOLD @"HelveticbNeueCondensedBold"
#define FONT_HELVETICA_NEUE_BOLD @"HelveticaNeueBold"
#define FONT_HELVETICA_NEUE_CONDENSED_BLACK @"HelveticcNeueCondensedBlack"
#define FONT_HELVETICA_NEUE_MEDIUM @"HelveticaNeueMedium"
#define FONT_OLDE_ENGLISH_REGULAR @"OldeEnglish"
#define FONT_TIMES_NEW_ROMAN_ITALIC @"TimesNewRomanItalic"
#define FONT_TIMES_NEW_ROMAN_REGULAR @"TimesNewRomanRegular"
#define FONT_HELVETICA_NEUE_REGULAR @"HelveticaNeue"
#define FONT_DAKOTA_HANDWRITING_REGULAR @"dakota-regular"
#define FONT_HELVETICA         @"Helvetica"

//UIFont made available thru UIAppFonts key in plist
#define UIFONT_TIMES_NEW_ROMAN_REGULAR @"Times New Roman"
#define UIFONT_BIG_CASLON @"Big Caslon"
#define UIFONT_OLDE_ENGLISH_REGULAR @"Olde English"



#define UIFONT_HELVETICA_NEUE_REGULAR @"HelveticaNeue"
#define UIFONT_HELVETICA_NEUE_BOLD @"HelveticaNeue-Bold"
#define UIFONT_HELVETICA_NEUE_MEDIUM @"HelveticaNeue-Medium"
#define UIFONT_HELVETICA_NEUE_CONDENSED_BOLD @"HelveticbNeue-CondensedBold"
#define UIFONT_HELVETICA_NEUE_CONDENSED_BLACK @"HelveticcNeue-CondensedBlack"

#define IPHONE_3_2 3.2
#define IPHONE_4_0 4.0
#define IPHONE_4_2 4.2
#define IPHONE_5_0 5.0

#define RES_BIGGER_IPHONE 480
#define RES_SMALLER_IPHONE 320
#define DEFAULT_STATUS_BAR_HEIGHT 20
#define ZERO_STATUS_BAR_HEIGHT    0
#define RES_BIGGER 1024
#define RES_SMALLER 768


#define FB 255.0
#define RGB(r,g,b) [UIColor colorWithRed:r/FB green:g/FB blue:b/FB alpha:1.0]
#define RGB_A(r,g,b,a) [UIColor colorWithRed:r/FB green:g/FB blue:b/FB alpha:a]

#define COLOR_BOTTOM_TOOLBAR RGB(86.0,55.0,28.0)
#define COLOR_DESK_TITLE RGB(130.0,68.0,49.0)
#define COLOR_SEPARATOR [UIColor lightGrayColor]
#define COLOR_SEARCHPANEL_BACKGROUND RGB(235.0,235.0,235.0)
#define COLOR_RED_PEPPER RGB(128.0,0.0,0.0)
#define COLOR_LIGHT_BLUE RGB(17.0,115.0,237.0)
#define COLOR_REDDISH_BROWN RGB(206.0,41.0,49.0)

#define COLOR_POPOVER_BACKGROUND RGB(211.0,213.0,219.0)
#define COLOR_LIGHT_GRAY RGB_A(192,192,192,0.2)
#define COLOR_BOTTOM_TOOLBAR_SELECTED_TEXT RGB(254,194,111)
#define COLOR_IPHONE_WOOD_SEPARATOR RGB(147, 103, 68)
#define COLOR_IPHONE_TEXT_ON_WOOD RGB(86.0,55.0,28.0)
#define COLOR_LIGHT_PINK (getDeviceVersion()>IPHONE_3_2)?RGB_A(255,230,230,0.36):[UIColor whiteColor]
#define COLOR_SEARCH_RADAR_DISTANCE RGB(127.0,127.0,127.0)
#define COLOR_SEARCH_RADAR_IPHONE_BGD RGB(218.0,218.0,218.0)
#define COLOR_SEARCH_RADAR_IPHONE_LABEL RGB(64.0,64.0,64.0)

#define TAG_UL @"ul"
#define TAG_LI @"li"
#define TAG_SPAN @"span"
#define TAG_DIV @"div"
#define TAG_A @"a"
#define TAG_FORM @"form"
#define TAG_FIELDSET @"fieldset"
#define TAG_P @"p"
#define TAG_BLOCKQUOTE @"blockquote"
#define TAG_B @"b"
#define TAG_TABLE @"table"
#define TAG_TH @"th"
#define TAG_TR @"tr"
#define TAG_TD @"td"
#define TAG_H2 @"h2"
#define TAG_H4 @"h4"
#define TAG_H5 @"h5"
#define TAG_INPUT @"input"
#define TAG_LABEL @"label"
#define TAG_SELECT @"select"
#define TAG_OPTION @"option"
#define TAG_TEXTAREA @"textarea"
#define TAG_BUTTON @"button"
#define TAG_BR @"br"
#define TAG_LEGEND @"legend"
#define TAG_TBODY @"tbody"
#define TAG_EM @"em"
#define TAG_IMG @"img"
#define TAG_TITLE @"title"

#define ATTRIBUTE_ID @"id"
#define ATTRIBUTE_CLASS @"class"
#define ATTRIBUTE_HREF KEY_HREF
#define ATTRIBUTE_ACTION @"action"
#define ATTRIBUTE_NAME @"name"
#define ATTRIBUTE_VALUE @"value"
#define ATTRIBUTE_TYPE @"type"
#define ATTRIBUTE_SELECTED @"selected"
#define ATTRIBUTE_CHECKED @"checked"
#define ATTRIBUTE_ENCTYPE @"enctype"
#define ATTRIBUTE_STYLE @"style"
#define ATTRIBUTE_SUMMARY @"summary"
#define ATTRIBUTE_SRC @"src"

#define ATTRIBUTE_VALUE_DELETE   @"delete"
#define ATTRIBUTE_VALUE_UNDELETE @"undelete"
#define ATTRIBUTE_VALUE_REPOST   @"repost"
#define ATTRIBUTE_VALUE_KEEP     @"keep"
#define ATTRIBUTE_VALUE_CHANGE   @"change"
#define ATTRIBUTE_VALUE_SIGNUP   @"/signup"

#define TYPE_RADIO @"radio"
#define TYPE_CHECKBOX @"checkbox"
#define TYPE_FILE @"file"
#define TYPE_HIDDEN @"hidden"
#define TYPE_SUBMIT @"submit"

#define ENCTYPE_MULTIPART_FORM_DATA @"multipart/form-data"

#define DATE_FORMAT_FEED @"yyyy-MM-dd'T'HH:mm:ssZZZ"
#define DATE_FORMAT_AD @"yyyy-MM-dd','  h:mma zzz"
#define DATE_FORMAT_SIMPLE @"MMMM d"

#define NIB_TABLE_CELLS @"TableCells"
#define US_CITIES @"us cities"
#define NBSP @"&nbsp;"
#define QUOT @"&quot;"
#define AMP  @"&amp;"
#define GT   @"&gt;"
#define SPACE @" "
#define NEWLINE @"\n"

#define HREF_HOUSING		@"hhh"
#define HREF_FORSALE		@"sss"
#define HREF_JOBS			@"jjj"
#define HREF_GIGS			@"ggg"
#define HREF_PERSONALS		@"ppp"
#define HREF_COMMUNITY		@"ccc"
#define HREF_SERVICES		@"bbb"
#define HREF_RESUMES		@"res"
#define HREF_PARTTIME		@"addFour=part-time"
#define HREF_CAL			@"cal"
#define HREF_CLASSES		HREF_CAL @"/#classes"
#define HREF_CARSANDTRUCKS	@"cta"
#define HREF_FURNITURE		@"fua"
#define HREF_APARTMENTSCGI	@"cgi-bin/apartments.cgi"
#define HREF_LOSTANDFOUND	@"laf"
#define HREF_ROOMSSHARED	@"roo"
#define HREF_WANTED         @"wan"
#define HREF_CARSANDTRUCKS_AUTOS @"i/autos"

#define HEIGHT_POPOVER 450
// sounds
#define SOUND_PAGE_TURN		@"newspaperPageTurn"

#define HTML_CRAIGSLIST_HOSTED	@"<div id=\"iwt\">"
#define HTML_CRAIGSLIST_HOSTED_SECOND @"<div class=\"iw\">"
#define HTML_CRAIGSLIST_HOSTED_THIRD  @"<img src=\""
#define HTML_CRAIGSLIST_HOSTED_THIRD_CLOSE @"<!-- START CLTAGS -->"
#define HTML_TABLE_CLOSING		@"PostingID:"

#define HTML_HREF_START @"<a href"
#define HTML_HREF_END   @"</a>"

#define HTML_CRAIGSLIST_HOSTED_TITLE_IMAGE @"<div class=\"iw\">"

#define HTML_AD_BODY_OPEN   @"<div id=\"userbody\">"
#define HTML_AD_BODY_CLOSE  @"<ul class=\"clfooter\">"

#define HTML_AD_PARSER_START_TAG @"<p class=\"row\" data-latitude=\"\" data-longitude=\"\">"
#define HTML_AD_PARSER_END_TAG   @"</p>"

#define SIZE_STANDARD CGSizeMake(320, 480)

// localizations
#define LOCALE_FR @"fr"
#define LOCALE_EN @"en"
#define LOCALE_DE @"de"

typedef enum {
	DispatchType_Unknown,
	DispatchType_PostLink,
	DispatchType_PostCategories,
	DispatchType_PostSublocations,
	DispatchType_PostSubcategories,
    DispatchType_PostGigSubcategories,
	DispatchType_PostForm,
	DispatchType_PostConfirmForm,
	DispatchType_PostPersonalsSubcategories,
	DispatchType_PostDatingSubcategories,
	DispatchType_PostPersonalsSeekingType,
    DispatchType_PostSignedIn,
    DispatchType_PostImageUpload,
    DispatchType_PostCreateAccount
} DispatchType;

#define REG_EXP_EXCLUDE_ADS  @"([^[:alnum:]]|^)%@([^[:alnum:]]|$)"
#define REG_EXP_ABSOLUTE_URL @"^[^:]*://.*$"

#define SHOW_PERSONALS_ALWAYS

//iPhone version only:
#define IMG_BACKGROUND_ADS_SECTION_HEADER @"iphone_background_section_header"
#define IMG_IPHONE_UP_ARROW_ICON @"iphone_up_arrow_icon"

#define APP_PAID_DISPLAY_NAME @"Craigslist app for iPad & iPhone"
#define APP_FREE_DISPLAY_NAME @"Craigslist app for iPhone & iPad"

#define IMG_ROTATE_BUTTON           @"image_button_rotate"
#define IMG_CLOSE_BUTTON            @"image_button_close"

#define IMG_ATTACH_ROTATE_BUTTON            @"button_rotate"
#define IPHONE_IMG_ATTACH_ROTATE_BUTTON     @"iphone_button_rotate"

// this tag we use to not let font changed after device rotation
#define UNRESIZABLE_HTML_TAG @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0;'>"
#define KEY_LOCATION_DATA @"location_data"
#define KEY_CATEGORIES_DATA @"categories_data"

// images and constants for free version
#define MAX_FREE_SAVED_SEARCHES  1
#define MAX_FREE_SAVED_FAVORITES 2
#define FREE_IPHONE_BUTTON  @"free_iPhone_button"
#define FREE_IPHONE_MESSAGE @"free_iPhone_message"
#define FREE_IPAD_BUTTON    @"free_iPad_button"

#define IPHONE_NEWSPAPER_TOP_VIEW @"iphone_newspaper-top"
#define IPHONE_NEWSPAPER_RIGHT_VIEW @"iphone_newspaper-right"
#define NEWSPAPER_TOP_VIEW @"newspaper-top"
#define NEWSPAPER_RIGHT_VIEW @"newspaper-right"
#define NEWSPAPER_BOTTOM_VIEW @"newspaper-bottom"
#define IMG_BACKGROUND_NEWSPAPER @"newspaper-background"
#define IMG_BACKGROUND_NEWSPAPER_CLEAN @"newspaper-background-clean"
#define IMG_BACKGROUND_NEWSPAPER_CLAEN_SEPARATOR @"newspaper-background-clean_separator"

// not for translate
#define BEST_OF_CRAIGSLIST @"BEST OF CRAIGSLIST"

//facebook and twitter resources
#define IPHONE_BTN_REPLY_FACEBOOK   @"iphone_btn_reply_facebook"
#define IPHONE_BTN_REPLY_MAIL       @"iphone_btn_reply_mail"
#define IPHONE_BTN_REPLY_TWITTER    @"iphone_btn_reply_twitter"
#define IPHONE_POPOVER_BACKGROUND   @"iphone_popver_background"

#define BITLY_LOGIN                 @"lifelikeapps"
#define BITLY_KEY                   @"R_b898e57d7c6b9bfba0a5765d59a6e228"

#define ACCOUNT_LOGIN @"user"
#define ACCOUNT_TOKEN @"token"
#define ACCOUNT_TYPE  @"type"
#define REPLY_TW_MESSAGE @"TWEET"

// headerView buttons (iPad)
#define INDEX_HEADER_BUTTON_FACEBOOK 0
#define INDEX_HEADER_BUTTON_TWITTER 1
#define INDEX_HEADER_BUTTON_EMAIL 2
#define INDEX_HEADER_BUTTON_BYPAID 3

#define IMG_HEADER_BUTTON_EMAIL @"header_button_email"
#define IMG_HEADER_BUTTON_TWITTER @"header_button_twitter"
#define IMG_HEADER_BUTTON_FACEBOOK @"header_button_facebook"

#define T_HEADERVIEW_REPLY_MESSAGE_FORMAT @"The Craigslist App for iPad and iPhone is an awesome way to browse Craigslist. Here's a link to try it for free: %@"
#define T_ARROW_UP_NAME @"UP"

#define FILE_WHAT_IN_FULL_VERSION @"WhatInFullVersion"
#define FILE_TYPE_TXT @"txt"

// List of Flurry events. Used in: [PromotionManager flurryLogEvent:eventName withParameters:nil];
#define FLURRY_EVENT_SHARE_WAKEUP_ON_TWITTER    @"Share ad via Twitter"
#define FLURRY_EVENT_SHARE_WAKEUP_ON_FACEBOOK   @"Share ad via Facebook"
#define FLURRY_EVENT_NEW_POST                   @"New post"
#define FLURRY_EVENT_BUY_PAID                   @"Clicked to buy paid version"
#define FLURRY_EVENT_CANT_LOGIN                 @"Can't login"


#define NEARBY_CITIES                   @"nearby cl"
#define USA_COUNTRY                     @"US"
#define CANADA_COUNTRY                  @"Canada"
#define LAT_AMERICA_COUNTRY             @"Latin America and Caribbean"
#define LOCATIONS_WITHOUT_STATES_KEY    @"empty_state"
#define FILE_LOS_ANGELES                @"LosAngeles"

// List of Search Radar definitions
#define SHORT_GROUP_KEY              @"short_distance"
#define MIDDLE_GROUP_KEY             @"middle_distance"
#define HIGH_GROUP_KEY               @"high_distance"

#define BUTTON_SHOW_SHORT_TAG        77
#define BUTTON_SHOW_MIDDLE_TAG       88
#define BUTTON_SHOW_HIGH_TAG         99

#define SHORT_DISTANCE               @"100"
#define MIDDLE_DISTANCE              @"250"
#define HIGH_DISTANCE                @"500"

#define CRAIGLIST_SEARCH_RADAR                @"Craigslist Search Radar"
#define SEARCH_RADAR                          @"Search Radar"
#define R_SYMBOL                              @"\u00AE"
#define RESULTS_LOADING_WITHIN_DIST_FORMAT    @"Loading results within %@ miles"
#define NO_RESULTS                            @"No"
#define ADDITIONAL_FOUND_WITHIN_DIST_FORMAT   @"%@ additional results found within %@ miles of your location"
#define MORE_FOUND_WITHIN_DIST_FORMAT         @"%@ more within %@ miles"
#define IMG_SEARCH_RADAR	    			  @"icon_search_radar"
#define LOADING_TEXT                          @"Please wait. Many Craigslist sites are within this radius..."

#define ADDITIONAL_FOUND_FOR_FREE_WITHIN_DIST_FORMAT  @"%@ additional results found near your area. Upgrade to the full version to view neighboring results"//@"%@ additional results found within %@ miles in full version due to its Search Radar feature "

// List of in-app-purchase prices
#define SHORT_RADAR_PRICE            @"0.99"
#define MIDDLE_RADAR_PRICE           @"1.99"
#define HIGH_RADAR_PRICE             @"2.99"

// List of search radar in-app-purchase id
#define SHORT_RADAR_UNIVERSAL_PRODUCT_ID       @"100_mile_SR_1"
#define SHORT_RADAR_UNIVERSAL_FREE_PRODUCT_ID  @"100_mile_SR_2"
#define SHORT_RADAR_IPAD_PRODUCT_ID            @"100_mile_SR_3"
#define SHORT_RADAR_IPHONE_PRODUCT_ID          @"100_mile_SR_5"
#define SHORT_RADAR_IPAD_FREE_PRODUCT_ID       @"" // we don't use SR for this version
#define MIDDLE_RADAR_UNIVERSAL_PRODUCT_ID      @"250_mile_SR_1"
#define MIDDLE_RADAR_UNIVERSAL_FREE_PRODUCT_ID @"250_mile_SR_2"
#define MIDDLE_RADAR_IPAD_PRODUCT_ID           @"250_mile_SR_3"
#define MIDDLE_RADAR_IPHONE_PRODUCT_ID         @"250_mile_SR_5"
#define MIDDLE_RADAR_IPAD_FREE_PRODUCT_ID      @""
#define HIGH_RADAR_UNIVERSAL_PRODUCT_ID        @"500_mile_SR_1"
#define HIGH_RADAR_UNIVERSAL_FREE_PRODUCT_ID   @"500_mile_SR_2"
#define HIGH_RADAR_IPAD_PRODUCT_ID             @"500_mile_SR_3"
#define HIGH_RADAR_IPHONE_PRODUCT_ID           @"500_mile_SR_5"
#define HIGH_RADAR_IPAD_FREE_PRODUCT_ID        @""

// In-app-purchase labels
#define HEADER_UPGRADE_SRADAR_TEXT @"View more results for all your queries"
#define FOOTER_UPGRADE_SRADAR_TEXT @"Search Radar will work instantly on all your Craigslist searches!"
#define FOOTER_ALREADY_UPGRADE_SRADAR_TEXT @"Search Radar works on all your Craigslist searches!"
#define BOTTOM_DISABLE_SRADAR_TEXT @"If you wish to disable Search Radar, you can turn it off in the settings menu."
#define ALREADY_PURCHASE_MESSAGE_FORMAT @"You've already purchased the %@-mile search radar but you can upgrade to a more powerfull option to see more results :"
#define HEADER_ALREADY_UPGRADE_SRADAR_TEXT @"Upgrade to one of the following Search Radar options"

#define SHORT_RADAR_TITLE         @"100-mile Search Radar"
#define MIDDLE_RADAR_TITLE        @"100 and 250-mile Search Radar"
#define MIDDLE_RADAR_TITLE_IPHONE @"250-mile Search Radar"
#define HIGH_RADAR_TITLE          @"100, 250 and 500-mile Search Radar (see more results!)"
#define HIGH_RADAR_TITLE_IPHONE   @"500-mile Search Radar"
#define RADAR_UPGRADE_TITLE_FORMAT         @"%@-mile Search Radar upgrade"
#define RADAR_UPGRADE_TITLE_FORMAT_IPHONE  @"%@-mile SR upgrade"

#define PURCHASE_SUCCESS_MESSAGE @"You can use Search Radar for reviewing the app."
#define PURCHASE_FAILURE_MESSAGE @"This is failure during transaction."

// Iphone Search Radar
#define CELL_HEIGHT 115
#define SR_SECTION_HEADER_HEIGHT 30.0f
#define SR_SECTION_FOOTER_HEIGHT 115.0f
#define IMG_SEARCH_RADAR_IPHONE  @"icon_search_radar_iphone"
#define BOTTOM_DISABLE_SRADAR_TEXT_IPHONE @"Search Radar can be turned off in settings"




//ads column item width and height
#define ADS_COLUMN_ITEM_WIDTH 230
#define ADS_COLUMN_ITEM_HEIGHT 105

#define ADS_COLUMN_ITEM_HEIGHT_SCALED 233

#define CITIES_AND_COORDINATES_PATH @"Coordnates_locations"

//iCloud sync keys
#define FAV_ADS_FOR_MARK         @"favAds"
#define FAV_ADS_FOR_UNMARK       @"unfavAds"
#define CROSS_OFF_ADS_FOR_MARK   @"cross_offAds"
#define CROSS_OFF_ADS_FOR_UNMARK @"uncross_offAds"
#define SETLOCATIONS             @"setLocations"
#define UNSETLOCATIONS           @"unsetLocations"
#define SETSEARCHES              @"setSearches"
#define UNSETSEARCHES            @"unsetSearches"
//iCloud update locations notificatons keys
#define LOCATION_ADDED_NOTIFICATION    @"LOCATION_ADDED"
#define LOCATION_RECEIVED_NOTIFICATION @"LOCATION_RECEIVED_NOTIFICATION"
//iCloud update searches notificatons keys
#define SEARCHES_UPDATE_NOTIFICATION    @"SEARCHES_UPDATE"
#define SEARCHES_RECEIVED_NOTIFICATION @"SEARCHES_RECEIVED_NOTIFICATION"
//fav reload
#define REFRESH_DATA                    @"RefreshData"
//iCloud content keys
#define ICLOUD_RELEASE_VERSION               @"iCloudReleaseVersion"
#define SYNC_KEY                             @"SYNCDATA"
#define FAVS_KEY                             @"FAVS"
#define CROSS_OFF_KEY                        @"CROSSOFF"
#define LOCATIONS_KEY                        @"LOCATIONS"
#define SEARCHES_KEY                         @"SEARCHES"

#define RECEIVED_ALL_LIFELIKE_ADMIN_DATA @"Received_all_lifelike_admin_data"

#define FAVORITE_CATEGORY_NAME @"for sale"


#define ALL_CATEGORIES_FILE_NAME        @"allCategories.json"
#define ROOT_PATH                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define ALL_CATEGORIES_DOCUMENT_DIRECTORY_FILE_PATH        [ROOT_PATH stringByAppendingPathComponent:ALL_CATEGORIES_FILE_NAME]
#define ALL_CATEGORIES_MAIN_BUNDLE_FILE_PATH  [[NSBundle mainBundle] pathForResource:ALL_CATEGORIES_FILE_NAME ofType:nil]


#define kNameKey        @"name"
#define kHrefKey        @"href"
#define kSubcategoryKey @"subcategory"
#define kCategoriesKey  @"categories"
#define kRevisionKey    @"revision"

#define CENSORED_IMAGE  @"censored_image"
#define kImagesStartBorder @"<div class=\"iw\"><div id=\"iwt\"><div class=\"tn\">"
#define kImagesEndBorder   @"</div></div>"
#define kImageSeparator    @"</div><br><div class=\"tn\">"

//added in 4.9.3
#define BOSTON_LOCATION @"boston"
#define NEWYOURK_LOCATION @"new york"
#define UKRAINE_LOCATION @"ukraine"
#define SERVICES_THERAPEUTIC_SUBCATEGORY_HREF @"thp"
#define SERVICES_THERAPEUTIC_SUBCATEGORY_HREF_FIX @"ths"
#define CATEGORY_APTS_HOUSING_HREF @"apa"
#define CATEGORY_APTS_HOUSING_NAME @"apts"
#define CATEGORY_ALL_APARTMENTS_NAME @"all apartments"
#define CATEGORY_ALL_APARTMENTS_HREF @"aap"
#define CATEGORY_ALL_NO_FREE_APTS_NAME @"all no fee apts"
#define CATEGORY_ALL_NO_FREE_APTS_HREF @"nfa"
#define CATEGORY_BY_OWNER_APARTMENTS_NAME @"by-owner apartments only"
#define CATEGORY_BY_OWNER_APARTMENTS_HREF @"abo"
#define CATEGORY_REGISTRATION_FREE_NAME @"registration fee"
#define CATEGORY_REGISTRATION_FREE_HREF @"aiv"

//added 4.9.4
#define WARNING_TITLE @"Warning!"


#define NEED_UPDATE_PRICE          @"need_update_price"

#define kCURRENT_ICLOUD_RELEASE_VERSION @"1.0"

#define DEFAULT_PRICE                   @"0.99"
#define CRAIGSLIST_SALE_BORDER_PRICE    @"1.99"


