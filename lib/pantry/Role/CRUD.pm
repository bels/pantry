package pantry::Role::CRUD;
use Mojo::Base -role, -signatures;

requires 'sql';
requires 'table';


sub create($self,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->insert($self->table,$data,{returning => '*'})->hash; #returning is not supported in sqlite yet but it is coming
	return $self->sql->db->insert($self->table,$data)->hash;
}

sub update($self,$id,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	#return $self->sql->db->update($self->table,$data,{id => $id}, {returning => '*'})->hash;
	return $self->sql->db->update($self->table,$data,{id => $id})->hash;
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