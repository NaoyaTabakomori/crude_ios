#import <UIKit/UIKit.h>

@interface
UIView (Additions)

+	(id)
viewFromClassNameXibWithOwner:(id)owner
;
-	(void)
setHidden:(BOOL)hidden
animated:(BOOL)animated
duration:(NSTimeInterval)duration
;

@property	(assign, nonatomic)	CGFloat	width;
@property	(assign, nonatomic)	CGFloat	height;
@property	(assign, nonatomic)	CGFloat	y;

@end

typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface
UIAlertView (Additions)
+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled
;
@end

inline	static	BOOL
IsNilOrEmptyOrWhitespace( NSString* p ) {
	if ( ! p ) return YES;
	return ! [ p stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet ].length;
}
inline	static	UIColor*
ColorWithAlpha( NSString* p, CGFloat alpha ) {
 
	NSScanner* wScanner = [ NSScanner scannerWithString:p ];
 
	wScanner.charactersToBeSkipped = [ NSCharacterSet characterSetWithCharactersInString:@"#" ];
	unsigned int w = 0;
	[ wScanner scanHexInt:&w ];
 
	return [
		UIColor
		colorWithRed	:( ( w >> 16 ) & 0x00ff ) / 255.
		green			:( ( w >>  8 ) & 0x00ff ) / 255.
		blue			:( ( w       ) & 0x00ff ) / 255.
		alpha			:alpha
	];
}
inline	static	UIColor*
Color( NSString* p ) {
	return ColorWithAlpha( p, 1 );
}

inline	static	BOOL
Is3_5Inch() {
	return UIScreen.mainScreen.bounds.size.height == 480;
}

@interface
UIGestureRecognizer (Additions)

@property	(nonatomic, strong)	void (^block)( UIGestureRecognizer* );

-	(instancetype)
initWithBlock:(void (^)( UIGestureRecognizer* ))p
;

@end

