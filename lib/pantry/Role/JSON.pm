package pantry::Role::JSON;
use Mojo::Base -role, -signatures;

sub TO_JSON{
	my $self = shift;

	return { %{ $self } };
}

1;