package pantry::Model::Recipe;

use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);
use pantry::Model::Item;

use Moose;

has 'sql' => (is => 'rw', isa => 'Mojo::SQLite');
has 'table' => (is => 'ro', isa => 'Str', default => 'recipe');

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject', 'pantry::Role::JSON';

has 'id' => (is => 'rw', isa => 'Maybe[Str]');
has 'genesis' => (is => 'rw', isa => 'Maybe[Str]');
has 'modified' => (is => 'rw', isa => 'Maybe[Str]');
has 'name' => (is => 'rw', isa => 'Maybe[Str]');
has 'description' => (is => 'rw', isa => 'Maybe[Str]');
has 'items' => (is => 'rw', isa => 'Maybe[ArrayRef]');
has 'active' => (is => 'rw', isa => 'Maybe[Bool]');


sub create($self,$data){
	my $recipe = {name => $data->{'name'}, description => $data->{'description'}};
	$self->sql->db->insert($self->table,$recipe);

	my $id = $self->sql->db->query('select last_insert_rowid()')->hash->{'last_insert_rowid()'};

	my $recipe_raw = $self->sql->db->select($self->table,undef,{id => $id})->hash;
	my $items = [];
	foreach my $item (@{$data->{'items'}}){
		my $row = {item => $item->{'itemId'}, recipe => $id};

		$self->sql->db->insert('recipe_items',$row);
		my $item_raw = $self->sql->db->query('select * from item where id = ?',$item->{'itemId'})->hash;

		push(@{$items},pantry::Model::Item->new($item_raw));
	}

	$recipe_raw->{'items'} = $items;

	$self->load_object($recipe_raw);
}
1;