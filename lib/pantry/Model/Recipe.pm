package pantry::Model::Recipe;
use Mojo::Base -base, -signatures;

use Role::Tiny::With;

has 'sql';
has 'table' => 'recipe';

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject';

has 'id';
has 'genesis';
has 'modified';
has 'name';
has 'description';
has 'items';

1;