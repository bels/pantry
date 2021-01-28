package pantry;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');
	
	# Configure the application
	$self->secrets($config->{secrets});
	
	# Router
	my $r = $self->routes;
	
	# Normal route to controller
	
	$r->get('/item/:id')->to(controller => 'generic', action => 'getOne', object => 'item', render_type => 'json', predicate => undef)->name('get_item');
	$r->put('/item/:id')->to(controller => 'generic', action => 'update', object => 'item', render_type => 'json', predicate => undef)->name('update_item');
	$r->delete('/item/:id')->to(controller => 'generic', action => 'delete', object => 'item', render_type => 'json')->name('delete_item');
	$r->get('/items')->to(controller => 'generic', action => 'getAll', object => 'item', render_type => 'json', predicate => undef)->name('get_all_items');
	$r->post('/item')->to(controller => 'generic', action => 'create', object => 'item', render_type => 'json')->name('create_item');
	
	$r->get('/recipe/:id/items')->to(controller => 'generic', action => 'getAll', object => 'item', render_type => 'json', qualifier => 'recipe', predicate => undef)->name('get_recipe_items');
	$r->get('/recipe/:id')->to(controller => 'generic', action => 'getOne', object => 'recipe', render_type => 'json', predicate => undef)->name('get_recipe');
	$r->put('/recipe/:id')->to(controller => 'generic', action => 'update', object => 'recipe', render_type => 'json', predicate => undef)->name('update_recipe');
	$r->delete('/recipe/:id')->to(controller => 'generic', action => 'delete', object => 'item', render_type => 'json')->name('delete_item');
	$r->get('/recipes')->to(controller => 'generic', action => 'getAll', object => 'recipe', render_type => 'json', predicate => undef)->name('get_all_recipes');
	$r->post('/recipe')->to(controller => 'generic', action => 'create', object => 'recipe', render_type => 'json', predicate => undef)->name('create_recipe');
	
	$r->get('/location/:id')->to(controller => 'generic', action => 'getOne', object => 'location', render_type => 'json', predicate => undef)->name('get_location');
	$r->put('/location/:id')->to(controller => 'generic', action => 'update', object => 'location', render_type => 'json', predicate => undef)->name('update_location');
	$r->delete('/location/:id')->to(controller => 'generic', action => 'delete', object => 'item', render_type => 'json')->name('delete_item');
	$r->get('/locations')->to(controller => 'generic', action => 'getAll', object => 'location', render_type => 'json', predicate => undef)->name('get_all_locations');
	$r->post('/location')->to(controller => 'generic', action => 'create', object => 'location', render_type => 'json')->name('create_location');
}

1;
