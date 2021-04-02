package pantry;
use Mojo::Base 'Mojolicious', -signatures;
use Mojo::SQLite;

use pantry::Model::Item;
use pantry::Model::ItemType;
use pantry::Model::Location;
use pantry::Model::Recipe;

# This method will run once at server start
sub startup ($self) {

	# Load configuration from config file
	my $config = $self->plugin('NotYAMLConfig');
	
	# Configure the application
	$self->secrets($config->{secrets});

	$self->helper(sql => sub{
		my $self = shift;
		state $sql = Mojo::SQLite->new('sqlite:pantry.db');
	});

	foreach my $migration_file (@{$self->config('migration_files')}){
		my $name = $migration_file;
		$name =~ s/\.sql//;
		$self->sql->auto_migrate(1)->migrations->name($name)->from_file($migration_file)->migrate;
	}

	$self->helper(factory => sub{
		my ($self,$object_type) = @_;

		my $objects = {
			item => sub{
				return pantry::Model::Item->new(sql => $self->sql);
			},
			item_type => sub{
				return pantry::Model::ItemType->new(sql => $self->sql);
			},
			location => sub{
				return pantry::Model::Location->new(sql => $self->sql);
			},
			recipe => sub{
				return pantry::Model::Recipe->new(sql => $self->sql);
			}
		};

		return $objects->{$object_type}();
	});

	$self->hook(after_dispatch => sub{
		my $self = shift;
		my $origin = $self->req->headers->origin;
	
		$self->res->headers->header('Access-Control-Allow-Origin' => $origin);
		#$self->res->headers->header('Access-Control-Allow-Credentials' => 'true');
		#$self->res->headers->header('Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT');
		#$self->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type');
	});
	# Router
	my $r = $self->routes;
	
	# Normal route to controller

	$r->options('/*' => sub{
		#allowing cors
		my $self = shift;
		my $origin = $self->req->headers->origin;
	
		$self->res->headers->header('Access-Control-Allow-Origin' => $origin);
		$self->res->headers->header('Access-Control-Allow-Credentials' => 'true');
		$self->res->headers->header('Access-Control-Allow-Methods' => 'GET, OPTIONS, POST, DELETE, PUT');
		$self->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Access-Control-Allow-Origin');
		#$self->res->headers->header('Access-Control-Max-Age' => '1728000');                                                                                                                              
	
		$self->respond_to(any => { data => '', status => 200 });
	});
	$r->post('/item/type')->to(controller => 'generic', action => 'create', object => 'item_type', render_type => 'json', predicate => undef)->name('create_item_type');
	$r->get('/item/types')->to(controller => 'generic', action => 'getAll', object => 'item_type', render_type => 'json', predicate => undef)->name('get_item_types');
	$r->get('/item/:id')->to(controller => 'generic', action => 'getOne', object => 'item', render_type => 'json', predicate => undef)->name('get_item');
	$r->put('/item/:id')->to(controller => 'generic', action => 'update', object => 'item', render_type => 'json', predicate => undef)->name('update_item');
	$r->delete('/item/:id')->to(controller => 'generic', action => 'delete', object => 'item', render_type => 'json')->name('delete_item');
	$r->get('/items')->to(controller => 'generic', action => 'getAll', object => 'item', render_type => 'json', predicate => undef, render_type => 'json')->name('get_all_items');
	$r->post('/item')->to(controller => 'generic', action => 'create', object => 'item', render_type => 'json')->name('create_item');
	
	$r->get('/recipe/:id/items')->to(controller => 'generic', action => 'getAll', object => 'recipe', render_type => 'json', qualifier => 'recipe', predicate => undef)->name('get_recipe_items');
	$r->get('/recipe/:id')->to(controller => 'generic', action => 'getOne', object => 'recipe', render_type => 'json', predicate => undef)->name('get_recipe');
	$r->put('/recipe/:id')->to(controller => 'generic', action => 'update', object => 'recipe', render_type => 'json', predicate => undef)->name('update_recipe');
	$r->delete('/recipe/:id')->to(controller => 'generic', action => 'delete', object => 'recipe', render_type => 'json')->name('delete_item');
	$r->get('/recipes')->to(controller => 'generic', action => 'getAll', object => 'recipe', render_type => 'json', predicate => undef)->name('get_all_recipes');
	$r->post('/recipe')->to(controller => 'generic', action => 'create', object => 'recipe', render_type => 'json', predicate => undef)->name('create_recipe');
	
	$r->get('/location/:id')->to(controller => 'generic', action => 'getOne', object => 'location', render_type => 'json', predicate => undef)->name('get_location');
	$r->put('/location/:id')->to(controller => 'generic', action => 'update', object => 'location', render_type => 'json', predicate => undef)->name('update_location');
	$r->delete('/location/:id')->to(controller => 'generic', action => 'delete', object => 'location', render_type => 'json')->name('delete_item');
	$r->get('/locations')->to(controller => 'generic', action => 'getAll', object => 'location', render_type => 'json', predicate => undef)->name('get_all_locations');
	$r->post('/location')->to(controller => 'generic', action => 'create', object => 'location', render_type => 'json')->name('create_location');
}

1;
