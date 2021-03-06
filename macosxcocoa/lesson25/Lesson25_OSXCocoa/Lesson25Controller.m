/*
 * Original Windows comment:
 * "This code was created by Pet & Commented/Cleaned Up By Jeff Molofee
 * If you've found this code useful, please let me know.
 * Visit my site at nehe.gamedev.net"
 * 
 * Cocoa port by Bryan Blackburn 2002; www.withay.com
 */

/* Lesson25Controller.m */

#import "Lesson25Controller.h"

@interface Lesson25Controller (InternalMethods)
- (void) setupRenderTimer;
- (void) updateGLView:(NSTimer *)timer;
- (void) createFailed;
@end

@implementation Lesson25Controller

- (void) awakeFromNib
{  
   [ NSApp setDelegate:self ];   // We want delegate notifications
   renderTimer = nil;
   [ glWindow makeFirstResponder:self ];
   glView = [ [ Lesson25View alloc ] initWithFrame:[ glWindow frame ]
              colorBits:16 depthBits:16 fullscreen:FALSE ];
   if( glView != nil )
   {
      [ glWindow setContentView:glView ];
      [ glWindow makeKeyAndOrderFront:self ];
      [ self setupRenderTimer ];
   }
   else
      [ self createFailed ];
}


/*
 * Setup timer to update the OpenGL view.
 */
- (void) setupRenderTimer
{
   NSTimeInterval timeInterval = 0.005;

   renderTimer = [ [ NSTimer scheduledTimerWithTimeInterval:timeInterval
                             target:self
                             selector:@selector( updateGLView: )
                             userInfo:nil repeats:YES ] retain ];
   [ [ NSRunLoop currentRunLoop ] addTimer:renderTimer
                                  forMode:NSEventTrackingRunLoopMode ];
   [ [ NSRunLoop currentRunLoop ] addTimer:renderTimer
                                  forMode:NSModalPanelRunLoopMode ];
}


/*
 * Called by the rendering timer.
 */
- (void) updateGLView:(NSTimer *)timer
{
   if( glView != nil )
      [ glView drawRect:[ glView frame ] ];
}


/*
 * Handle key presses
 */
- (void) keyDown:(NSEvent *)theEvent
{ 
   unichar unicodeKey;
   
   unicodeKey = [ [ theEvent characters ] characterAtIndex:0 ];
   switch( unicodeKey )
   {
      case 'q':
      case 'Q':
         [ glView decreaseZPos ];
         break;

      case 'z':
      case 'Z':
         [ glView increaseZPos ];
         break;

      case 'w':
      case 'W':
         [ glView increaseYPos ];
         break;

      case 's':
      case 'S':
         [ glView decreaseYPos ];
         break;

      case 'd':
      case 'D':
         [ glView increaseXPos ];
         break;

      case 'a':
      case 'A':
         [ glView decreaseXPos ];
         break;

      case '1':
         if( ![ theEvent isARepeat ] )
            [ glView setMorphTo1 ];
         break;

      case '2':
         if( ![ theEvent isARepeat ] )
            [ glView setMorphTo2 ];
         break;

      case '3':
         if( ![ theEvent isARepeat ] )
            [ glView setMorphTo3 ];
         break;

      case '4':
         if( ![ theEvent isARepeat ] )
            [ glView setMorphTo4 ];
         break;

      case NSPageUpFunctionKey:
         [ glView increaseZSpeed ];
         break;

      case NSPageDownFunctionKey:
         [ glView decreaseZSpeed ];
         break;

      case NSDownArrowFunctionKey:
         [ glView increaseXSpeed ];
         break;

      case NSUpArrowFunctionKey:
         [ glView decreaseXSpeed ];
         break;

      case NSRightArrowFunctionKey:
         [ glView increaseYSpeed ];
         break;

      case NSLeftArrowFunctionKey:
         [ glView decreaseYSpeed ];
         break;
   }
}  


/*
 * Set full screen.
 */
- (IBAction)setFullScreen:(id)sender
{ 
   [ glWindow setContentView:nil ];
   if( [ glView isFullScreen ] ) 
   {
      if( ![ glView setFullScreen:FALSE inFrame:[ glWindow frame ] ] )
         [ self createFailed ];
      else 
         [ glWindow setContentView:glView ];
   }
   else
   {
      if( ![ glView setFullScreen:TRUE
                    inFrame:NSMakeRect( 0, 0, 800, 600 ) ] )
         [ self createFailed ];
   }
}  


/*
 * Called if we fail to create a valid OpenGL view
 */
- (void) createFailed
{
   NSWindow *infoWindow;

   infoWindow = NSGetCriticalAlertPanel( @"Initialization failed",
                                         @"Failed to initialize OpenGL",
                                         @"OK", nil, nil );
   [ NSApp runModalForWindow:infoWindow ];
   [ infoWindow close ];
   [ NSApp terminate:self ];
}


/*
 * Cleanup
 */
- (void) dealloc
{
   [ glWindow release ];
   [ glView release ];
   if( renderTimer != nil && [ renderTimer isValid ] )
      [ renderTimer invalidate ];
}

@end
