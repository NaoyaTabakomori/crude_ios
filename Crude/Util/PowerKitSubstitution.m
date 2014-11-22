#import "PowerKitSubstitution.h"

@implementation
UIView (Additions)

+	(id)
viewFromClassNameXibWithOwner:(id)owner {
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (nib == nil) return nil;

    return [[nib instantiateWithOwner:owner options:nil] objectAtIndex:0];
}

-	(void)
setHidden:(BOOL)hidden
animated:(BOOL)animated
duration:(NSTimeInterval)duration {
	
	self.alpha = self.hidden ? 0 : 1;
	self.hidden = NO;
	[	UIView
		animateWithDuration:duration
		animations:^{
			self.alpha = hidden ? 0 : 1;
		}
		completion:^(BOOL finished) {
			self.hidden = hidden;
		}
	];
}


-	(CGFloat)
width {
	return self.frame.size.width;
}
-	(void)
setWidth:(CGFloat)p {
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, p, self.frame.size.height );
}

-	(CGFloat)
height {
	return self.frame.size.height;
}
-	(void)
setHeight:(CGFloat)p {
	self.frame = CGRectMake( self.frame.origin.x, self.frame.origin.y, self.frame.size.width, p );
}

-	(CGFloat)
y {
	return self.frame.origin.y;
}
-	(void)
setY:(CGFloat)p {
	self.frame = CGRectMake( self.frame.origin.x, p, self.frame.size.width, self.frame.size.height );
}
@end


static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

@implementation
UIAlertView (Additions)

+ (UIAlertView*) alertViewWithTitle:(NSString*) title                    
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissBlock) dismissed
                           onCancel:(CancelBlock) cancelled {
    
    _cancelBlock  = [cancelled copy];

    _dismissBlock  = [dismissed copy];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return alert;
}


+ (void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
	if(buttonIndex == [alertView cancelButtonIndex])
	{
		_cancelBlock();
	}
    else
    {
        _dismissBlock(buttonIndex - 1); // cancel button is button 0
    }
}

@end

#import <objc/runtime.h>

static void* BlockKey = &BlockKey;

@implementation
UIGestureRecognizer (Additions)

-	(void (^)( UIGestureRecognizer* ))
block {
    return objc_getAssociatedObject( self, BlockKey );
}

-	(void)
setBlock:(void (^)( UIGestureRecognizer* ))p {
    objc_setAssociatedObject( self, BlockKey, p, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}
-	(instancetype)
initWithBlock:(void (^)( UIGestureRecognizer* ))p {
	if ( ( self = [ self initWithTarget:self action:@selector(Fired:) ] ) ) self.block = p;
	return self;
}

-	(void)
Fired:(UIGestureRecognizer*)p {
	self.block( p );
}

@end

