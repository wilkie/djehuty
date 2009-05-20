/*
 * xinerama.d
 *
 * This file holds bindings to xinerama. This file was created from xinerama.h
 * which is provided with xinerama proper.
 *
 * Author: Dave Wilkinson
 * Originated: May 20th, 2009
 *
 */

module platform.unix.x.xinerama;

import platform.unix.x.Xlib;

struct XineramaScreenInfo {
   int   screen_number;
   short x_org;
   short y_org;
   short width;
   short height;
}

//_XFUNCPROTOBEGIN

Bool XineramaQueryExtension (
   Display *dpy,
   int     *event_base,
   int     *error_base
)

Status XineramaQueryVersion(
   Display *dpy,
   int     *major,
   int     *minor
)

Bool XineramaIsActive(Display *dpy);

/* 
   Returns the number of heads and a pointer to an array of
   structures describing the position and size of the individual
   heads.  Returns NULL and number = 0 if Xinerama is not active.
  
   Returned array should be freed with XFree().
*/

XineramaScreenInfo * 
XineramaQueryScreens(
   Display *dpy,
   int     *number
);

//_XFUNCPROTOEND
