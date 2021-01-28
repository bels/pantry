package pantry::Controller::Generic;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub create($self){
	my $object = $self->stash('object');
	my $data = $self->$object->create($self->req->json);

	if(!$data){
		return $self->reply->exception('Bad data');
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $data) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $data) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $data);
		}
	}
}

sub update($self){
	my $object = $self->stash('object');
	my $data = $self->object->update($self->param('id'),$self->req->json);

	if(!$data){
		return $self->reply->exception('Bad data');
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $data) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $data) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $data);
		}
	}
}

sub getOne($self){
	my $object = $self->stash('object');
	my $data = $self->$object->getOne($self->param('id'),$self->stash('predicte'));

	if(!$data){
		return $self->reply->not_found();
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $data) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $data) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $data);
		}
	}
}

sub getAll($self){
	my $object = $self->stash('object');
	my $predicate = undef;
	if($self->stash('qualifier')){
		$predicate = {$self->stash('qualifier') => $self->param('id')};
	}
	if($self->stash('predicate')){
		my $passed_predicate = $self->stash('predicate');
		$predicate = {%{$predicate},%{$passed_predicate}};
	}

	my $data = $self->$object->getAll($predicate);

	if(!$data){
		return $self->reply->not_found();
	} else {
		if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
			$self->render(json => $data) and return;
		}
		if($self->stash('render_type') eq 'template'){
			$self->render(template => $self->stash('template'), object => $data) and return;
		}
		if($self->stash('render_type') eq 'none'){
			$self->stash(object => $data);
		}
	}
}

sub delete($self){
	unless($self->param('id')){
		$self->reply->not_found();
	}

	my $object = $self->stash('object');
	my $data = $self->$object->delete($self->param('id'));

	if(!$data){
		return $self->reply->not_found();
	} else {
		unless($data->active){
			if($self->stash('render_type') eq 'json' || !defined($self->stash('render_type'))){
				$self->render(json => $data) and return;
			}
			if($self->stash('render_type') eq 'template'){
				$self->render(template => $self->stash('template'), object => $data) and return;
			}
			if($self->stash('render_type') eq 'none'){
				$self->stash(object => $data);
			}
		} else {
			#need handler for if it didn't "delete"
		}
	}
}

1;