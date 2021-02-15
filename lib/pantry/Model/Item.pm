package pantry::Model::Item;

use Moose;

has 'sql' => (is => 'rw', isa => 'Mojo::SQLite');
has 'table' => (is => 'ro', isa => 'Str', default => 'item');

with 'pantry::Role::LoadObject', 'pantry::Role::JSON', 'pantry::Role::CRUD';

has 'id' => (is => 'rw', isa => 'Maybe[Str]');
has 'genesis' => (is => 'rw', isa => 'Maybe[Str]');
has 'modified' => (is => 'rw', isa => 'Maybe[Str]');
has 'name' => (is => 'rw', isa => 'Maybe[Str]');
has 'type' => (is => 'rw', isa => 'Maybe[Str]');
has 'amount' => (is => 'rw', isa => 'Maybe[Str]');
has 'location' => (is => 'rw', isa => 'Maybe[Str]');
has 'active' => (is => 'rw', isa => 'Maybe[Bool]');

1;