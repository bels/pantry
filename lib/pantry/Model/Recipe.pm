package pantry::Model::Recipe;

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

1;