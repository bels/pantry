package pantry::Model::ItemType;
use Mojo::Base -base, -signatures;

use Role::Tiny::With;

has 'sql';
has 'table' => 'item_type';

with 'pantry::Role::CRUD', 'pantry::Role::LoadObject';

has 'id';
has 'genesis';
has 'modified';
has 'name';
has 'active';

1;