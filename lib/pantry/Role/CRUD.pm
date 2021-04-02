package pantry::Role::CRUD;
use Moose::Role;

use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

requires ('sql','table');


sub create($self,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->insert($self->table,$data,{returning => '*'})->hash; #returning is not supported in sqlite yet but it is coming
	$self->sql->db->insert($self->table,$data);
	my $returned_data =  $self->sql->db->query('select * from ' . $self->table . ' order by genesis desc limit 1')->hash;
	$self->load_object($returned_data);
}

sub update($self,$id,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->update($self->table,$data,{id => $id}, {returning => '*'})->hash;
	$self->sql->db->update($self->table,$data,{id => $id});
	my $returned_data = $self->sql->db->select($self->table,undef,{id => $id})->hash;
	$self->load_object($returned_data);
}

sub getOne($self,$id,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	my $data = {};
	if ($predicate) {
		my $where = [{id => $id}, $predicate];
		$data = $self->sql->db->select($self->table,undef,$where)->hash;
	} else {
		$data = $self->sql->db->select($self->table,undef,{id => $id})->hash;
	}

	$self->load_object($data);
}

sub getAll($self,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	my $objects = [];
	my $raw_objects;
	if ($predicate) {
		$raw_objects = $self->sql->db->select($self->table,undef,$predicate)->hashes->to_array;
	} else {
		$raw_objects = $self->sql->db->select($self->table)->hashes->to_array;
	}

	my $object_type = ref $self;
	foreach my $raw (@{$raw_objects}){
		push(@{$objects},$object_type->new($raw));
	}

	return $objects;
}

sub delete($self,$id){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->update($self->table,{active => 0},{id => $id},{returning => '*'});
	return $self->sql->db->update($self->table,{active => 0},{id => $id});
}

1;