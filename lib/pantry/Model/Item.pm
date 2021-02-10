package pantry::Model::Item;
use Mojo::Base -base, -signatures;

use Role::Tiny::With;

has 'db';
has 'table' => 'item';

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject';

has 'id';
has 'genesis';
has 'modified';
has 'name';
has 'type';
has 'amount';
has 'location';
has 'active';

1;