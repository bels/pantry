package pantry::Model::Location;
use Mojo::Base -base, -signatures;

use Role::Tiny::With;

has 'db';
has 'table' => 'item';

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject';

has 'id';
has 'genesis';
has 'modified';
has 'name';
has 'description';
has 'active';

1;