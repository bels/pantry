package pantry::Role::LoadObject;

use Mojo::Base -role, -signatures;

sub load_object($self,$data){

	foreach my $key (keys %{$data}){
		$self->attr($key => $data->{$key});
	}
}

1;