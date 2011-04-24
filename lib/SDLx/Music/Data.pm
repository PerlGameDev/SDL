package SDLx::Music::Data;

sub volume
{
	$_[0]->{volume} = $_[1] if $_[1];
	return $_[0]; 
}

sub file
{
	$_[0]->{file} = $_[1] if $_[1];
	return $_[0]; 
}


sub fade_in
{
	$_[0]->{fade_in} = $_[1] if $_[1];
	return $_[0]; 
}

sub loops
{
	$_[0]->{loops} = $_[1] if $_[1];
	return $_[0]; 
}

1;
