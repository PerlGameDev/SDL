
SV *_color_number( SV *color, SV *alpha )
{
    int          c      = SvIV(color);
    int          a      = SvIV(alpha);
    unsigned int retval = SvUV(color);

    if( !SvOK(color) || color < 0 )
    {
        if( color < 0 )
        warn("Color was a negative number");
        retval = a == 1 ? 0x000000FF : 0;
    }
    else
    {
        if( a == 1 && (c > 0xFFFFFFFF) )
        {
            warn("Color was number greater than maximum expected: 0xFFFFFFFF");
            retval = 0xFFFFFFFF; 
        }
        else if ( a != 1 && ( c > 0xFFFFFF) )
        {
            warn("Color was number greater than maximum expected: 0xFFFFFF");
            retval = 0xFFFFFF;
        }
    }

    return newSVuv(retval);
}

AV *_color_arrayref( AV *color, SV *alpha )
{
    AV *retval = newAV();
    int length = alpha ? 4 : 3;
    int i      = 0;
    for(i = 0; i < length; i++)
    {
        SV *c = *av_fetch(color, i, 0);

        if( av_len(color) < i || !SvOK(*av_fetch(color, i, 0)) )
            av_push(retval, newSVuv(i == 3 ? 0xFF : 0));
        else
        {
            int c = SvIV(*av_fetch(color, i, 0));
            if( c > 0xFF )
            {
                warn("Number in color arrayref was greater than maximum expected: 0xFF");
                av_push(retval, newSVuv(0xFF));
            }
            else if( c < 0 )
            {
                warn("Number in color arrayref was negative");
                av_push(retval, newSVuv(0));
            }
            else
                av_push(retval, newSVuv(c));
        }
    }
    sv_2mortal((SV*)retval);
    return retval;
}
