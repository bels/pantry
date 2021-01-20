package pantry::Role::CRUD;
use Mojo::Base -role, -signatures;

requires 'pg';
requires 'table';


sub create($self,$data){
	
}

sub update($self,$id,$data){
	
}

sub getOne($self,$id,$predicate){
	
}

sub getAll($self,$predicate){
	
}

sub delete($self,$id){
	
}

1;