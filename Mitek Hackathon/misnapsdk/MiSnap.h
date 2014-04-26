/*! @header

 The MiSnap SDK API is an interface that allows the app developer targeting Mitek
 Mobile Imaging servers to construct mobile device apps.

 The API consists of

 - a way to invoke the camera

 - calls into the API to query and establish parameters MiSnap uses during operation

 - constant values that can be used by the app developer to override MiSnap defaults

 - callback protocols to which the app must conform in order to retrieve MiSnap results

 @author Mitek Engineering on 2012-11-8
 @copyright 2013 Mitek Systems, Inc. All rights reserved.
 @unsorted
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#ifdef TURN_ON_GPS
#import <CoreLocation/CoreLocation.h>
#endif

/*!
 An app making use of the MiSnap SDK must conform to this protocol in order to receive
 the delegate callbacks for successful capture or canceled session.
 */
@protocol MiSnapViewControllerDelegate <NSObject>

/*! @abstract This delegate callback method is called upon successful image capture or decode.

 @param encodedImage for resultCode @link kMiSnapResultSuccessVideo @/link or
 @link kMiSnapResultSuccessStillCamera @/link, this will be a scaled,
 compressed and base64 encoded image, with BI/UXP data embedded as an
 Exif comment in the encoded JPEG, suitable for processing on a Mitek
 Systems mobile imaging server; for resultCode
 @link kMiSnapResultSuccessPDF417 @/link, this value will be nil.
 @param originalImage for resultCode @link kMiSnapResultSuccessVideo @/link or
 @link kMiSnapResultSuccessStillCamera @/link, this will be the original
 unmodified image; for resultCode kMiSnapResultSuccessPDF417, this value
 will be nil.
 @param results dictionary containing the result code (via key @link kMiSnapResultCode @/link).
 For resultCode @link kMiSnapResultSuccessPDF417 @/link, this dictionary
 will also contain the decoded PDF417 data (via key
 @link kMiSnapPDF417Data @/link). For image-based result codes, the value
 obtained via key @link kMiSnapMIBIData @/link will contain recorded
 environmental factors at the time the image was captured (focus quality,
 brightness level, etc.) plus user experience data during the
 auto-capture process.

 @param encodedImage for resultCode @link kMiSnapResultSuccessVideo @/link or
 @link kMiSnapResultSuccessStillCamera @/link, this will be a scaled,
 compressed and base64 encoded image, with BI/UXP data embedded as an
 Exif comment in the encoded JPEG, suitable for processing on a Mitek
 Systems mobile imaging server; for resultCode
 @link kMiSnapResultSuccessPDF417 @/link, this value will be nil.
 */
- (void)miSnapFinishedReturningEncodedImage:(NSString *)encodedImage
							  originalImage:(UIImage *)originalImage
								 andResults:(NSDictionary *)results;

/*! @abstract invoked if the user cancels a capture MiSnap transaction or other conditions occur that
 cause a MiSnap transaction to end without capturing an image.

 @discussion

 The result code will be @link kMiSnapResultCancelled @/link if the user touched the X Cancel
 button during capture.

 The result code will be @link kMiSnapResultVideoCaptureFailed @/link if the user encounters
 the @link kMiSnapMaxTimeouts @/link threshold and the setting
 @link kMiSnapAutoCaptureFailoverToStillCapture @/link was pre-set to 0 .

 The result code will be @link kMiSnapResultCameraNotSufficient @/link if the device does not
 support capturing a 2 Megapixel image.

 The results will also contain a value for the key @link kMiSnapMIBIData @/link if such data
 was captured prior to cancellation or other termination conditions.

 @param results dictionary containing the result code (via key @link kMiSnapResultCode @/link)
 and other information about the termination of the MiSnap transaction.

 */
- (void)miSnapCancelledWithResults:(NSDictionary *)results;
@end

#ifdef TURN_ON_GPS
@interface MiSnapViewController : UIViewController
	<AVCaptureVideoDataOutputSampleBufferDelegate, CLLocationManagerDelegate>
#else
/*! The Mitek Capture View Controller establishes itself as a recipient of
 @link //apple_ref/doc/uid/TP40009762 AVCaptureVideoDataOutputSampleBufferDelegate @/link
 messages and evaluates the images returned.

 Buttons are provided in the overlay to allow the user to request help manually or turn the
 device torch on/off.

 As the user learns how to position the document, help "bubbles" will be displayed with
 messages guiding the user regarding corrective actions.

 Once the image evaluation algorithms of the view controller determine that a document
 is sufficiently positioned in the fame and that there is enough light and that the document
 is properly in focus, the document will be automatically captured and compressed.  User
 experience data and other business intelligence information will also be captured and
 embedded into the JPEG Exif/JFIF as an Exif comment.  This scaled, compressed JPEG Exif
 image will then be base64-encoded.  The originally captured image, the encoded image,
 the business intelligence data and a detailed success result code will be sent to the
 delegate method @link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link .

 If the user does not capture the image within the timeout established in the setup
 parameters, a help tutorial will be displayed.

 If the user is shown the help tutorial the number of times established in the setup
 parameters and still times out attempting to capture an image, the default behavior is
 to failover to using the still camera, with an additional button provided on the overlay
 to allow the user to manually take a picture of the image.  This default behavior can be
 overridden with a parameter setting that will cause failover to simply return with a
 "Video Capture Failed" result-code to delegate method
 @link miSnapCancelledWithResults: @/link

 @unsorted
 */
@interface MiSnapViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>
#endif

/*! @abstract a pointer back to the method implementing the callback methods MiSnap will invoke
 upon transaction termination
 */
@property (strong, nonatomic) NSObject<MiSnapViewControllerDelegate>* delegate;
@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic, assign) BOOL rotateCameraOutput;

/*! the dictionary of parameters sent as a parameter to this call will replace any previously
 established parameters.

 if not called, a set of defaults will be internally established.

 @abstract method to establish parameters MiSnap will use during operation
 @param params key-value pairs whose range of eligible keys are drawn from NSString* values
 in @link //apple_ref/doc/header/MiSnap.h @/link
 in group MiSnap Input Parameters keys
 */
- (void) setupMiSnapWithParams:(NSDictionary *)params;

/*! @abstract the current MiSnap SDK version
 @return string representing the current MiSnap SDK version
 */
+ (NSString *)miSnapVersion;

/*! for use by app prior to invoking MiSnap (by presenting the @link MiSnapViewController @/link)
 to determine whether or not the feature specified will be supported once MiSnap is invoked.

 @abstract allows caller to pre-determine whether MiSnap supports named features
 @param featureName name of the feature to support, drawn from
 @link //apple_ref/doc/header/MiSnap.h @/link
 in group MiSnap Supported Feature Keys
 @return YES if the named feature is supported; NO if not supported or not recognized

 */
+ (BOOL)isFeatureSupported:(NSString*)featureName;

/*!	supplies the default set of MiSnap SDK parameters that the current version of MiSnap will
 use in the absence of the parameters being supplied to the
 @link setupMiSnapWithParams: @/link method.

 @abstract all of the relevant default MiSnap parameters, useful for establishing overrides
 @return a dictionary whose keys are drawn from @link //apple_ref/doc/header/MiSnap.h @/link
 group MiSnap Input Parameters keys, and whose values consist of string
 representations of the values of each key (the domains of which are described in the
 Programmer's Guide).
 */
+ (NSDictionary*)defaultParameters;

/*! This method only returns the values that MiSnap uses as defaults overridden with those
 values in the supplied dictionary.  It will not establish the values as defaults.

 Use @link setupMiSnapWithParams: @/link is still required after invoking this method to
 override necessary MiSnap parameter defaults.

 This method will not insert values from the overrideValues into the returned dictionary for
 which there are not already relevant keys.

 It will not insert deprecated values.

 @abstract a convenience class method returning @link defaultParameters @/link overridden
 with the values supplied in the overrideValues param
 @param overrideValues a dictionary containing key-value pairs that will override values
 normally returned by @link defaultParameters @/link .

 */
+ (NSDictionary*)defaultParametersWithOverrides:(NSDictionary*)overrideValues;
@end


// Parameter names for NSDictionary representation
// Viewfinder and Document sizes

/*! @group MiSnap Input Parameters key constants
 *
 *	@abstract Parameter names for use in NSDictionary passed to @link setupMiSnapWithParams: @/link
 */

extern
/*! This parameter controls the heart of the MiSnap Video-mode Auto-capture process.
 *	@note Values
 *		When <b>ON</b> ("1")[default], MiSnap will attempt to detect the document, evaluate it
 *		for certain criteria based upon document type, and then capture an image of the
 *		document without user having to press a button.
 *																					<br><br>
 *		When <b>OFF</b> ("0"), MiSnap will use the device still-camera in manual-mode (i.e.
 *		requiring the user to press a button to capture an image of the document), and return
 *		that document to the app to be sent to the server for further processing.<br>
 *		default = <b>ON</b>
 */
NSString* const kMiSnapVideoAutoCaptureOption;

extern
/*!	By establishing this MiSnap parameter with the value 1, MiSnap will return the live video
 *	frame evaluated using Mitek algorithms to the calling app to be sent to the server.
 *
 *	By establishing this MiSnap parameter with the value 0, MiSnap will only use the live video
 *	frame for evaluation, and once evaluation determines a clear image, the still camera will be
 *	used to capture the image to be sent to the server.
 *
 *	@note Values
 *		0 == disallow video frames to be sent to the server
 *		1 == allow video frames to be sent to the server
 */
NSString* const kMiSnapAllowVideoFrames;

extern
/*!	When @link kMiSnapAllowVideoFrames @/link is set to 1, this parameter determines the number
 *	of consecutive video frames that must evaluate to roughly the same conditions.  (This allows
 *	the UX experience of "settling" on the image, and helps prevent the capture of "random"
 *	images that happen to come into frame in focus while the user may still be moving the device
 *	into the initial position to make the capture.
 *
 *	The value of "1" indicates only that a single video frame is required.
 *
 *	The default value of "3" means that 2nd and 3rd video frame with approximately the same size
 *	and horizontal dimension must match within a small tolerance.
 *
 *	Higher values simply mean more consecutive frames must also match within a small tolerance.
 *
 *	@note Values
 *		range 1-5
 *		default = 3
 */
NSString* const kMiSnapConsecutiveVideoFrames;

extern
/*! By default, MiSnap will automatically failover to still-camera manual-capture mode after
 *	allowing the user to re-attempt kMiSnapMaxTimeouts times.
 *
 *	By establishing this MiSnap parameter with the value 0, MiSnap will instead call
 *	@link miSnapCancelledWithResults: @/link with the results parameter containing an
 *	NSDictionary element with key @link kMiSnapResultCode @/link set to
 *	@link kMiSnapResultVideoCaptureFailed @/link after allowing the user to
 *	re-attempt auto-capture @link kMiSnapMaxTimeouts @/link times.
 *
 *	@note Values
 *		0 == disallow automatic failover to still-camera manual capture mode<br>
 *		1 == allow automatic failover to still-camera manual-capture mode<br>
 *		default = 1
 */
NSString* const kMiSnapAutoCaptureFailoverToStillCapture;

extern
/*	the maximum size of either the height or width (whichever is greater) for the
 *	image submitted to the Mitek image processing server
 *
 *	@note Values
 *	range 300-5500<br>
 *  default = 1600
 */
NSString* const kMiSnapRequiredMaxImageHeightAndWidth;

extern
/*	Used in conjunction with @link kMiSnapViewfinderMinHorizontalFill @/link to determine the
 *	minimum allowable amount of a document that must fill the screen before MiSnap will
 *	start evaluating the document for readiness to be sent to the server.  (I.e. these
 *	parameters are used to ensure that the document fills enough of the screen that it will
 *	have enough detail for the algorithms on the server to be able to consider it usable.)
 *	If the threshold is met, MiSnap will start the further processing.
 *
 *	This specific setting is the minimum area in terms of percentage of the entire
 *	viewfinder area.
 *
 *	@note Values
 *	range 200-1000 measured in tenths of a percent (i.e. 333 = 33.3%)<br>
 *	default = 333
 */
NSString* const kMiSnapMinDocumentPercentage;

extern
/*	Used in conjunction with @link kMiSnapMinDocumentPercentage @/link to determine the
 *	minimum allowable amount of a document that must fill the screen before MiSnap will
 *	start evaluating the document for readiness to be sent to the server.  (I.e. these
 *	parameters are used to ensure that the document fills enough of the screen that it will
 *	have enough detail for the algorithms on the server to be able to consider it usable.)
 *	If the threshold is met, MiSnap will start the further processing.
 *
 *	This specific setting is the minimum width in terms of percentage of the entire
 *	viewfinder width.
 *
 *	@note Values
 *	range 500-1000 measured in tenths of a percent (i.e. value of 800 == 80%)
 *	default = 800
 */
NSString* const kMiSnapViewfinderMinHorizontalFill;

extern
/*!
 *	The number of unnecessary touches by the user that will trigger the help screen.
 *
 *	@note Values
 *		Range: 2-9
 *		Default: 4
 */
NSString* const kMiSnapUnnecessaryScreenTouchLimit;

extern
/*!	The length of time (in seconds) at the very beginning of a MiSnap user session that the
 *	user will be allowed to initially attempt to capture an image.
 *
 *	At the end of this time, if the default value (or any non-zero value) is in effect for 
 *	@link kMiSnapMaxTimeouts @/link, then the video-mode tutorial/help screen will be
 *	automatically displayed.
 *
 *	If the value of @link kMiSnapMaxTimeouts @/link is set to 0 and the value of
 *	@link kMiSnapAutoCaptureFailoverToStillCapture @/link is set to the default value of "1", 
 *	then the transition tutorial screen will be automatically displayed. 
 *
 *	If the values of both @link kMiSnapMaxTimeouts @/link and 
 *	@link kMiSnapAutoCaptureFailoverToStillCapture @/link are set to 0, then at the end of this 
 *	time, the MiSnap session will end and the @link miSnapCancelledWithResults: @/link delegate
 *	callback will be invoked with a resultCode of @link kMiSnapResultVideoCaptureFailed @/link.
 *
 *	When @link kMaxTimeouts @/link is non-zero subsequent timeouts prior to the dispaly of 
 *	either a tutorial or cancellation will be governed by the @link kMiSnapTimeout @/link,
 *	assuming it is equal to or larger than this value.
 *
 *	@note Values
 *	range 15-90<br>
 *	default = 30 seconds
 */
NSString* const kMiSnapInitialTimeout;

extern
/*!	The length of time (in seconds) a user is given to attempt to capture an image (with the
 *	exception of the initial attempt, which is goverend by @link kMiSnapInitialTimeout @/link ).
 *
 *	This value will only have an effect if @link kMiSnapMaxTimeouts @/link is non-zero.  
 *
 *  At the end of this time, if the number of attempts by the user has not exceeded the value of
 *	@link kMiSnapMaxTimeouts @/link , then the video-mode tutorial/help screen will be
 *	automatically displayed.
 *
 *	If the number of attempts by the user has exceeded the value of
 *	@link kMiSnapMaxTimeouts @/link and the value of
 *	@link kMiSnapAutoCaptureFailoverToStillCapture @/link is set to the default value of "1",
 *	then the transition tutorial screen will be automatically displayed.
 *
 *	If the number of attempts by the user has exceeded the value of
 *	@link kMiSnapMaxTimeouts @/link and the value of
 *	@link kMiSnapAutoCaptureFailoverToStillCapture @/link is set to 0, then at the end of this
 *	time, the MiSnap session will end and the @link miSnapCancelledWithResults: @/link delegate
 *	callback will be invoked with a resultCode of @link kMiSnapResultVideoCaptureFailed @/link.
 *
 *	The range is not allowed to be below the value of @link kMiSnapInitialTimeout @/link ; any 
 *	value less than that parameter value will be replaced by the value of that parameteter.
 *
 *	@note Values
 *	range @link kMiSnapInitialTimeout @/link-90<br>
 *	default = 45 seconds
 */
NSString* const kMiSnapTimeout;

extern
/*!	number of times MiSnap will automatically show the Help dialog after the timeout
 *	interval. (in other words, MiSnap will timeout @link kMiSnapMaxTimeouts @/link+1 times
 *	before failover to either still-camera manual-capture mode or invoking
 *	@link MiSnapViewControllerDelegate @/link callback @link miSnapCancelledWithResults: @/link
 *	based on the value of parameter  @link kMiSnapAutoCaptureFailoverToStillCapture @/link.
 *
 *	@note Values
 *	range 0-10<br>
 *	default = 2 timeouts
 */
NSString* const kMiSnapMaxTimeouts;

extern
/*!	The length if time (in milliseconds) that the Tutorial is displayed upon first
 *  run of MiSnap by a new user.
 *
 *	@note Values
 *	range 3000-10000<br>
 *	default = 7500 (7.5 seconds)
 */
NSString* const kMiSnapTutorialBrandNewUserDuration;

// Image quality parameters
extern
/*	indicates how much to compress the image. Typically, images are compressed to reduce
 *	bandwidth overhead and time when transferring the image to Mitek mobile imaging servers.
 *
 *	@note Values
 *	range: 0-100<br>
 *	0 == "minimum quality"/"maximum compression"<br>
 *	100 == "maximum quality"/"no compression"<br>
 *  default = 50
 */
NSString* const kMiSnapImageQuality;

// Environmental criteria to satisfy
extern
/*	The acceptable brightness (where 1000 is “ideal”) to allow automatic image capture
 *	(applies to video camera only)
 *
 *	@note Values
 *	range: 0 - 1000 (1000 indicates "ideal brightness"; 0 indicates ignore setting)<br>
 *  default = 400
 */
NSString* const kMiSnapBrightness;

extern
/*!	<b>SHARPNESS SETTING IS IGNORED IN THIS VERSION OF MiSnap .</b><br>
 <i>It may once again become relevant in a later release.</i>
 */
NSString* const kMiSnapSharpness;

extern
/* The detected angle rotated from the display measured at the time of automatic image capture.
 *
 *	@note Values
 *	range 0-1000 measured in tenths of a percent (i.e. 150 == 15%)<br>
 *	0 indicates that the angle setting is to be ignored by MiSnap during processing<br>
 *  default = 150
 */
NSString* const kMiSnapAngle;

// Flash/Torch
extern
/*! DEPRECATED this parameter represents the old value still employed by some MIP
 *	Servers, but has been replaced by kMiSnapLightingVideo and kMiSnapLightingStillCamera
 */
NSString* const kMiSnapTorchValue;

extern
/*	The initial setting for the torch in MiSnap Video Auto-Capture mode.<br>
 *
 *  For value AUTO (or AUTO+DL), MiSnap uses the @link kMiSnapBrightness @/link calculated for
 *	each video frame versus @link kMiSnapAutoTorchLowLightMinimum @/link passed into MiSnap to
 *	automatically determine when to turn on the device torch for the user.  (If the user
 *	subsequently turns off the torch, or turns on the torch prior to the auto-torch calculation
 *	kicking in and then turns off the torch, the Auto-Torch calculation will be suspended for
 *	the remainder of that MiSnap capture session.)
 *
 *	For @link kMiSnapDocumentType @/link containing "DRIVER_LICENSE", MiSnap will ignore the
 *	AUTO setting and leave the torch off (but will make it available for the user).  AUTO+DL
 *	ignores this MiSnap internal override.
 *
 *	@note Values
 *		3 == Auto + DL = Same as auto, but override MiSnap ignoring setting for Driver License<br>
 *		2 == ON - torch on<br>
 *		1 == Auto - MiSnap determines if torch is needed during Video Frame processing<br>
 *		0 == OFF - no torch<br><br>
 *		default = 1
 */
NSString* const kMiSnapLightingVideo;

extern
/*	The initial setting for the camera flash in MiSnap Still-Camera Manual-Capture mode.
 *
 *  The value AUTO (or AUTO+DL) represents the same value that would be passed to iOS API calls
 *	to establish camera settings.  This means the device camera logic will determine whether or
 *	not to invoke the torch at the initiation of a Manual-Capture session.
 *
 *	This value will be ignored for failover from Vide Auto-Capture mode to Still-Camera
 *	Manual mode.  In that case, if the torch was ON, then the torch will remain ON, and if the
 *	torch was OFF, then the torch will remain OFF.
 *
 *	For @link kMiSnapDocumentType @/link containing "DRIVER_LICENSE", MiSnap will ignore the
 *	AUTO setting and leave the torch off (but will make it available for the user).  AUTO+DL
 *	ignores this MiSnap internal override.
 *
 *	@note Values:
 *	3 == AUTO+DL - Same as auto, but override MiSnap ignoring setting for Driver License<br>
 *	2 == ON - torch on<br>
 *	1 == AUTO - device camera logic determines if flash is needed at image capture time<br>
 *	0 == OFF - no torch<br><br>
 *	default = 1
 */
NSString* const kMiSnapLightingStillCamera;

// Document type
extern
/*	The type of document to be captured.
 *
 *	If value @link kMiSnapDocumentTypePDF417 @/link is specified, then MiSnap will internally
 *	capture an image of the 2D Barcode and return the decoded string using key
 *	@link kMiSnapPDF417Data @/link in the @link kMiSnapResultCode @/link field in the delegate
 *	callback @link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link
 *
 *	@note Values
 *  default = "ACH"
 */
NSString* const kMiSnapDocumentType;

extern
/* A human readable description of the document type referenced in
 *	@link kMiSnapDocumentType @/link
 *
 *	@note Values
 *  default = "ACH Enrollment"
 */
NSString* const kMiSnapShortDescription;

// Customizable UI Elements
extern
/*!	This value represents whether or not to animate the final set of icons displayed as
 *	part of the transition from a successful capture of a document to the scene to be
 *	displayed after MiSnap returns to the view controller that presented it.
 *
 *	@note Values
 *	0 means display the PNG file bug_animation_01.png for 2 seconds<br>
 *	1 means animate the MiSnap final bug<br>
 *  default = 1
 */
NSString* const kMiSnapAnimatedBug;

extern
/*! Stroke-width(thickness) in pixels of the line representing the rectangle that is
 *	animated when MiSnap has determined that the user has successfully captured an image of
 *	a document
 *
 *	@note Values
 *  range 1-100<br>
 *  default = 20
 */
NSString* const kMiSnapAnimationRectangleStrokeWidth;

extern
/*!	Corner-radius in pixels of the line representing the rectangle that is animated
 *	when MiSnap has determined that the user has successfully captured an image of a document
 *
 *	@note Values
 *  range 1-100<br>
 *  default = 16
 */
NSString* const kMiSnapAnimationRectangleCornerRadius;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	of the rectangle that is animated when MiSnap has determined that the user has
 *	successfully captured an image of a document.
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = ED1C24
 */
NSString* const kMiSnapAnimationRectangleColor;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	to be use as the background of the MiSnap "Tutorial" screen
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = E1E1E2 (light gray)
 */
NSString* const kMiSnapTutorialBackgroundColor;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	to be use as the background of the MiSnap First-Time User "Tutorial" screen
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = E1E1E2 (light gray)
 */
NSString* const kMiSnapTutorialBackgroundColorFirstTimeUser;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	to be use as the background of the MiSnap Failover to Still Camera "Tutorial" screen
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = E1E1E2 (light gray)
 */
NSString* const kMiSnapTutorialBackgroundColorFailoverToStillCamera;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	to be use as the background of the MiSnap Still Camera "Tutorial" screen
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = E1E1E2 (light gray)
 */
NSString* const kMiSnapTutorialBackgroundColorStillCamera;

extern
/*!	6-character color value (HTML-like RGB format, with two hex characters per R, G, and B)
 *	to be use as the background of the MiSnap First Time User Still Camera "Tutorial" screen
 *
 *	@note Values
 *		range 6-character string with hex values, no prefix<br>
 *		default = E1E1E2 (light gray)
 */
NSString* const kMiSnapTutorialBackgroundColorStillCameraFirstTimeUser;

extern
/*!	Indicates if Smart Bubble feature is enabled or not
 *
 *	If the value is YES/TRUE/1 then the Smart Bubble feature is enabled.
 *  Otherwise it is not enabled.
 *
 *	@note Values
 *		0/NO/FALSE means Smart Bubble feature is NOT enabled<br>
 *		1/YES/TRUE means Smart Bubble feature IS enabled<br>
 *		default = 1/YES/TRUE
 */
NSString* const kMiSnapSmartBubbleEnabled;

extern
/*	When @link kMiSnapSmartBubbleEnabled @/link is YES/ON/1 then this setting
 *  defines how often the Smart Bubble is shown after MiSnap starts.
 *	@note Values
 *		range 1000-10000 milliseconds (1-10 seconds)<br>
 *		default = 3000 (3 seconds)
 */
NSString* const kMiSnapSmartBubbleAppearanceDelay;

extern
/*	Indicates the number total number of a particular error
 *  that must occur before that error is shown to the user
 *  as a Smart Bubble.
 *	@note Values
 *		range 5-20<br>
 *		default = 10
 */
NSString* const kMiSnapSmartBubbleCumulativeErrorThreshold;


// Auto Torch feature

extern
/*	This setting defines how soon the Torch is turned on when in a low light condition.
 *	@note Values
 *		range 3000-10000 milliseconds (3-10 seconds)<br>
 *		default = 5000 (5 seconds)
 */
NSString* const kMiSnapAutoTorchAppearanceDelay;

extern
/*	Indicates the threshold to determine a low light condition.
 *  When this condition is met for @link kMiSnapAutoTorchAppearanceDelay @/link
 *  milliseconds, and  Auto Torch is Enabled,
 *  then the Video Camera's Torch is turned ON
 *	@note Values
 *		range 100-1000<br>
 *		default = 600
 */
NSString* const kMiSnapAutoTorchLowLightMinimum;

extern
/*	The amount of time, in milliseconds, that MiSnap will
 * suspend frame by frame processing after Auto Torch turns
 * on the Torch. This will allow the camera to "recover"
 * from the sudden brightness when the torch initially
 * turns on
 *	@note Values
 *		range 0-5000<br>
 *		default = 1500 (1.5 seconds)
 */
NSString* const kMiSnapAutoTorchSuspendProcessingTime;

// Guide Image feature
extern
/*!	Indicates if Guide Image feature is enabled or not
 *
 *	If the value is YES/TRUE/1 then the Guide Image feature is enabled.
 *  otherwise it is not enabled.
 *	@note Values
 *		0/NO/FALSE means Guide Image feature is NOT enabled<br>
 *		1/YES/TRUE means Guide Image feature IS enabled<br>
 *		default = 1/YES/TRUE
 */
NSString* const kMiSnapCameraGuideImageEnabled;

extern
/*	This setting defines how much of the document needs to fill the viewfinder
 *  in order for the Guide Image to fade out. The setting is a percentage
 *  of the @link kMiSnapMinDocumentPercentage @/link.
 *	@note Values
 *		range 333-1000 measured in tenths of a percent (i.e. value of 600 == 60%)<br>
 *		default = 600 (60 percent of @link kMiSnapMinDocumentPercentage @/link)
 */
NSString* const kMiSnapCameraGuideImageAppearanceFillPercentage;

extern
/*	Indicates the length of time in milliseconds that MiSnap
 *  does NOT find a document before the Guide Image reappears
 *	@note Values
 *		range 3000-15000<br>
 *		default = 5000
 */
NSString* const kMiSnapCameraGuideImageReappearanceDelay;

extern
/*	Indicates the amount of transparency to apply
 *  to the guide image when used in Still Camera mode
 *	@note Values
 *		range 0-100 (0=completely transparent; 100 = no transparency)<br>
 *		default = 50 (half transparent)
 */
NSString* const kMiSnapCameraGuideImageStillCameraAlpha;

extern
/*!	Indicates if Guide Image feature is enabled or not FOR THE STILL CAMERA
 *
 *	If the value is YES/TRUE/1 then the Guide Image feature is enabled
 *  when MiSnap is in Still Camera mode. Otherwise it is not enabled.
 *	@note Values
 *		0/NO/FALSE means Guide Image feature is NOT enabled<br>
 *		1/YES/TRUE means Guide Image feature IS enabled<br>
 *		default = 1/YES/TRUE
 */
NSString* const kMiSnapCameraGuideImageStillCameraEnabled;

/*! @group MiSnap Input Parameters Document Type constant values */

extern
/*! indicates MiSnap use internal parameters to attempt to capture the back of a check,
 *	displaying "Back of check" at the top of the capture preview display.
 */
NSString* const kMiSnapDocumentTypeCheckBack;

extern
/*! indicates MiSnap use internal parameters to attempt to capture the front of a check,
 *	displaying "Front of check" at the top of the capture preview display.
 */
NSString* const kMiSnapDocumentTypeCheckFront;

extern
/*! indicates MiSnap should internally invoke the barcode reader library and return the
 *	text of the captured PDF417
 */
NSString* const kMiSnapDocumentTypePDF417;

/*! @group MiSnap Input Parameters key constants
 @abstract keys for values in NSDictionary passed to MiSnap as parameters to
 @link setupMiSnapWithParams: @/link
*/

// Server Versions that MiSnap knows about
extern NSString* const kMiSnapMIPServerVersion;
extern NSString* const kMiSnapMDServerVersion;

extern
/*	The amount of time, in milliseconds, that MiSnap will
 * suspend frame by frame processing after the device
 * is rotated. This will prevent the camera from capturing
 * an image while the device is in the middle of rotating.
 *	@note Values
 *		range 0-5000<br>
 *		default = 1500 (1.5 seconds)
 */
NSString* const kMiSnapScreenRotationSuspendTime;

/*!	@group MiSnap Supported Feature parameters names
 @abstract names of features that can be passed to @link isFeatureSupported: @/link
 */

extern
/*!	For use in MiSnap API method @link isFeatureSupported: @/link.
 @note Return BOOL Value
 using this value:</b><br>
 YES if the device has video preview capability and can produce a 2 Megapixel image<br>
 NO if the device is incapable of this basic level of camera support
 */
NSString* const kMiSnapDeviceHasMinimumAutoCaptureCapability;

/*!	@group MiSnap Output Parameters key constants
 @abstract keys for values in NSDictionary passed back as parameter to
 @link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link or
 @link miSnapCancelledWithResults: @/link
 */

extern
/*! The key constant to access the value indicating success, cancellation, or other MiSnap
 *	termination conditions as passed in the @link MiSnapViewControllerDelegate @/link protocol
 *	method callbacks @link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link
 *	and @link miSnapCancelledWithResults: @/link
 *
 * @note Values
 *		@link kMiSnapResultSuccessVideo @/link, @link kMiSnapResultSuccessStillCamera @/link,
 *		@link kMiSnapResultSuccessPDF417 @/link, @link kMiSnapResultCameraNotSufficient @/link,
 *		@link kMiSnapResultCancelled @/link, @link kMiSnapResultVideoCaptureFailed @/link
 */
NSString* const kMiSnapResultCode;

extern
/*! The key constant to access the value containing the PDF417 data captured by the barcode
 *	reader library in MiSnap as passed in the @link MiSnapViewControllerDelegate @/link protocol
 *	method callback @link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link
 */
NSString* const kMiSnapPDF417Data;

extern
/*! The key constant to access the value containing the MIBI/UXP data collected during the video
 *	auto-capture process in MiSnap as passed in the @link MiSnapViewControllerDelegate @/link
 *	protocol method callbacks
 *	@link miSnapFinishedReturningEncodedImage:originalImage:andResults: @/link and
 *	@link miSnapCancelledWithResults: @/link.
 *
 *	Mitek Best Practices Guide recommend passing this data to the Mitek imaging server to which
 *	the app is connected (usually via app proxy server) in the case of cancellation to ensure
 *	that MIBI/UXP data for abandoned sessions is collected.
 */
NSString* const kMiSnapMIBIData;

extern
/*! The detected angle rotated from the display measured at the time of automatic image
 *	capture. 0 means there was no detected difference. This should never exceed the Angle
 *	input parameter.
 *
 *	@note Values
 *	range: 0-1000 measured in tenths of a percent (i.e. 150 == 15%).<br>
 *	0 means there was no detected difference in rotation or skew.
 */
NSString* const kMiSnapReturnAngle;

extern
/*!	The brightness value (where 1000 is “ideal”) measured at the time of automatic image
 *	capture (applies to video camera only)
 *
 *	@note Values
 *		range: 0-1000 (1000 represents "ideal brightness")
 */
NSString* const kMiSnapReturnBrightness;

extern
/*! The sharpness value (where 1000 is “ideal”) measured at the time of automatic image
 *	capture (applies to video camera only). <br><br>
 *
 *	@note Values
 *		range: 0-1000 (1000 represents "ideal sharpness")
 */
NSString* const kMiSnapReturnSharpness;

extern
/*!	An indicator of whether or not MiSnap was in Video Auto-capture mode at the time of
 *	capture.
 *
 *	@note Values
 *	1 == Video Auto-Capture mode / 0 == Still-camera Manual-capture mode
 */
NSString* const kMiSnapReturnVideoAutoCapture;

extern
/*!	An indicator of whether or not MiSnap is in a mode to send video frames to the
 *	@link MiSnapViewControllerDelegate @/link
 *
 *	This value is only meaningful if @link kMiSnapReturnVideoAutoCapture @/link == 1
 *
 *	@note Values
 *	1 == Video frame images sent to delegate / 0 == Video mode still capture sent to delegate
 */
NSString* const kMiSnapReturnAllowVideoFrames;

extern
/*!	An indicator of whether or not the torch was on or off at the end of the MiSnap session
 *
 *	@note Values
 *	1 == Torch was on at end of session / 0 == Torch was off at end of session
 */
NSString* const kMiSnapReturnLighting;

// Device ID
extern
/*!	A string representing a unique identifier with a 1-to-1 correspondence with the
 *	current installation of the app linking in the MiSnap SDK library, and which is passed in
 *	the MIBI data embedded in successful image captures or in the results of Cancelled or Failed
 *	MiSnap transactions to help identify this device during BI analysis.
 *
 *	MiSnap generates a GUID the first time it is executed, saves the value in User
 *	Defaults, and uses the same value for subsequent invocations of MiSnap. (This means that
 *	re-installation of the app will re-generate the unique identifier, and that the identifier
 *	will not be the same across separate apps containing MiSnap that all exist on one device.)
 */
NSString* const kMiSnapDeviceID;

/*!	@group MiSnap Output ResultCode value constants  */

extern
/*! MiSnap image capture transaction resulted in successful auto-capture in video-mode */
NSString* const kMiSnapResultSuccessVideo;

extern
/*! MiSnap image capture transaction resulted in successful capture in still-camera mode */
NSString* const kMiSnapResultSuccessStillCamera;

extern
/*! MiSnap PDF417 Capture transaction resulted in successful capture and translation */
NSString* const kMiSnapResultSuccessPDF417;

extern
/*! MiSnap transaction aborted due to inability of camera to perform necessary function */
NSString* const kMiSnapResultCameraNotSufficient;

extern
/*! MiSnap transaction cancelled by user */
NSString* const kMiSnapResultCancelled;

extern
/*! MiSnap video-mode auto-capture failed and auto-failover to still camera disabled */
NSString* const kMiSnapResultVideoCaptureFailed;
