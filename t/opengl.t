#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# basic testing of SDL::OpenGL

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;

if ( SDL::Config->has('GL') && SDL::Config->has('GLU') ) {
		plan ( tests => 3 );
} else {
	plan ( skip_all => 'OpenGL support not compiled' );
}

use_ok('SDL::OpenGL');

can_ok('main', qw/
	glBegin
	glClear
	glClearColor
	glColor
	glCullFace
	glEnable
	glEnd
	glEvalCoord1
	glEvalCoord2
	glEvalMesh2
	glFrontFace
	glFrustum 
	glGet
	glLight
	glLoadIdentity
	glMap1
	glMap2
	glMapGrid2
	glMaterial
	glMatrixMode
	glPointSize
	glPopMatrix
	glPushMatrix
	glRotate
	glScale
	glShadeModel
	glTranslate
	glVertex
	glVertex
	glViewport /);

can_ok('main',qw/
	gluPerspective
	gluBeginSurface
	gluBeginTrim
	gluEndSurface
	gluEndTrim
	gluNewNurbsRenderer 
	gluNurbsCurve
	gluNurbsProperty
	gluNurbsSurface
	gluPwlCurve /);
