#!/usr/bin/perl -w
#
# Copyright (C) 2003 Tels
# Copyright (C) 2004 David J. Goehrig
#
# Copyright (C) 2005 David J. Goehrig <dgoehrig\@cpan.org>
#
# ------------------------------------------------------------------------------
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#
# ------------------------------------------------------------------------------
#
# Please feel free to send questions, suggestions or improvements to:
#
#	David J. Goehrig
#	dgoehrig\@cpan.org
#
#
# basic testing of SDL::OpenGL

BEGIN {
	unshift @INC, 'blib/lib','blib/arch';
}

use strict;
use SDL::Config;

use Test::More;
plan ( tests => 3 );


use_ok('SDL::OpenGL');

SKIP:
{
skip ( 'No GL support found', 1) unless SDL::Config->has('GL');

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
}

SKIP:
{
skip ( 'No GLU support found', 1) unless SDL::Config->has('GLU');

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
}
sleep(2);
