package pantry::Role::JSON;
use Moose::Role;

use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

sub TO_JSON{
	my $self = shift;

	return { %{ $self } };
}

sub validate_json{
	my ($self,$json) = @_;

	my @json_keys = keys %{$json};

	my $valid_json = 1;
	foreach my $json_k (@json_keys){
		my $found = 0;
		foreach my $k ($self->meta->get_all_attributes){
			if ($k->name eq $json_k) {
				$found = 1;
			}
		}
		unless($found) {
			return 0;
		}
	}

	return $valid_json;
}
1;