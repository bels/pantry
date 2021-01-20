package pantry::Model::Recipe;
use Mojo::Base -base, -signatures;

use Role::Tiny::With;

has 'pg';
has 'table' => 'recipe';

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject';

has 'id';
has 'genesis';
has 'modified';
has 'name';
has 'items';

1;