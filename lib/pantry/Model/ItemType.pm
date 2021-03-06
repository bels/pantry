package pantry::Model::ItemType;

use Moose;

has 'sql' => (is => 'rw', isa => 'Mojo::SQLite');
has 'table' => (is => 'ro', isa => 'Str', default => 'item_type');

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject', 'pantry::Role::JSON';

has 'id' => (is => 'rw', isa => 'Maybe[Str]');
has 'genesis' => (is => 'rw', isa => 'Maybe[Str]');
has 'modified' => (is => 'rw', isa => 'Maybe[Str]');
has 'name' => (is => 'rw', isa => 'Maybe[Str]');
has 'active' => (is => 'rw', isa => 'Maybe[Bool]');

1;