package Sequence;

use Moose;


# --------------------------------------------
# ATTRIBUTES

has "id" => (
	isa => "Str",
	is  => "rw",
	required => 1
	);

has "seq" => (
	isa => "Str",
	is  => "rw",
	required => 1
	);

# --------------------------------------------
# METHODS
sub length {
	my $self   = shift;
	my $length = length($self->seq);

	return($length);
}

# --------------------------------------------
sub match {
	my $self  = shift;
	my $motif = shift;

	return $self =~ /$motif/ ? 1 : 0;
}



__PACKAGE__->meta->make_immutable;
1;