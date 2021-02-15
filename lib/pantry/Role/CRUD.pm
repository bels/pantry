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
	return $self->sql->db->query('select * from ' . $self->table . ' order by genesis desc limit 1')->hash;
}

sub update($self,$id,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->update($self->table,$data,{id => $id}, {returning => '*'})->hash;
	$self->sql->db->update($self->table,$data,{id => $id});
	return $self->sql->db->select($self->table,undef,{id => $id})->hash;
}

sub getOne($self,$id,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	if ($predicate) {
		my $where = [{id => $id}, $predicate];
		return $self->sql->db->select($self->table,undef,$where)->hash;
	} else {
		return $self->sql->db->select($self->table,undef,{id => $id})->hash;
	}
}

sub getAll($self,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	if ($predicate) {
		return $self->sql->db->select($self->table,undef,$predicate)->hashes->to_array;
	} else {
		return $self->sql->db->select($self->table)->hashes->to_array;
	}
}

sub delete($self,$id){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->update($self->table,{active => 0},{id => $id},{returning => '*'});
	return $self->sql->db->update($self->table,{active => 0},{id => $id});
}

1;