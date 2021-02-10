package pantry::Role::CRUD;
use Mojo::Base -role, -signatures;

requires 'db';
requires 'table';


sub create($self,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	return $self->pg->db->insert($self->table,$data,{returning => '*'})->hash;
}

sub update($self,$id,$data){
	return 'Setting table before use is required.' unless defined $self->table;

	return $self->pg->db->update($self->table,$data,{id => $id}, {returning => '*'})->hash;
}

sub getOne($self,$id,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	if ($predicate) {
		my $where = [{id => $id}, $predicate];
		return $self->pg->db->select($self->table,undef,$where)->hash;
	} else {
		return $self->pg->db->select($self->table,undef,{id => $id})->hash;
	}
}

sub getAll($self,$predicate){
	return 'Setting table before use is required.' unless defined $self->table;

	if ($predicate) {
		return $self->pg->db->select($self->table,undef,$predicate)->hashes->to_array;
	} else {
		return $self->pg->db->select($self->table)->hashes->to_array;
	}
}

sub delete($self,$id){
	return 'Setting table before use is required.' unless defined $self->table;

	return $self->pg->db->update($self->table,{active => 0},{id => $id},{returning => '*'});
}

1;