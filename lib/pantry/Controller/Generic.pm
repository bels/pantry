package pantry::Controller::Generic;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub create($self){
	my $object = $self->factory($self->stash('object'));
	my $json = $self->req->json;
	unless($object->validate_json($json)){
		return $self->reply->exception('Bad data');
	}
	$object->load_object($json);
	$object->create($json); #TODO maybe add the ability to just call ->create

	if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
		$self->render(json => {test => 'test'});
		$self->render(json => $object) and return;
	}
	if($self->stash('render_type') eq 'template'){
		$self->render(template => $self->stash('template'), object => $object) and return;
	}
	if($self->stash('render_type') eq 'none'){
		$self->stash(object => $object);
	}

}

sub update($self){
	my $object = $self->factory($self->stash('object'));
	my $data = $object->update($self->param('id'),$self->req->json);

	if(!$data){
		return $self->reply->exception('Bad data');
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $object) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $object) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $object);
		}
	}
}

sub getOne($self){
	my $object = $self->factory($self->stash('object'));
	my $data = $object->getOne($self->param('id'),$self->stash('predicte'));

	if(!$data){
		return $self->reply->not_found();
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $object) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $object) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $object);
		}
	}
}

sub getAll($self){
	my $object = $self->factory($self->stash('object'));
	my $predicate = undef;
	if($self->stash('qualifier')){
		$predicate = {$self->stash('qualifier') => $self->param('id')};
	}
	if($self->stash('predicate')){
		my $passed_predicate = $self->stash('predicate');
		$predicate = {%{$predicate},%{$passed_predicate}};
	}

	my $objects = $object->getAll($predicate);

	if(scalar @{$objects} == 0){
		return $self->reply->not_found();
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $objects) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $objects) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $objects);
		}
	}
}

sub delete($self){
	unless($self->param('id')){
		$self->reply->not_found();
	}

	my $object = $self->factory($self->stash('object'));
	my $data = $object->delete($self->param('id'));

	if(!$data){
		return $self->reply->not_found();
	} else {
		unless($data->active){
			if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
				$self->render(json => $object) and return;
			}
			if($self->stash('render_type') eq 'template'){
				$self->render(template => $self->stash('template'), object => $object) and return;
			}
			if($self->stash('render_type') eq 'none'){
				$self->stash(object => $object);
			}
		} else {
			#need handler for if it didn't "delete"
		}
	}
}

1;