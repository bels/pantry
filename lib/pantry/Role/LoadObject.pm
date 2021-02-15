package pantry::Role::LoadObject;
use Moose::Role;

use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

sub load_object($self,$data){

	foreach my $key (keys %{$data}){
		$self->$key($data->{$key});
	}
}

1;