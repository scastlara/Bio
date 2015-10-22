package Bio::Fasta;

use Moose;
use Bio::Sequence;

# --------------------------------------------
# ATTRIBUTES

has "file" => (
	isa => "Str",
	is => "ro",
	required => 1
	);

# --------------------------------------------
# METHODS

sub open {
	my $self = shift;
	open my $in_fh, '<', $self->file
		or die "Can't open $self->file : $!\n";

	return $in_fh;
}

# --------------------------------------------
sub seqs {
	my $self 	   = shift;
	my @sequences = ();

	my $in_fh = $self->open;

	local $/ = ">";

	while (<$in_fh>) {
		chomp;
		my ($id, @seq) = split /\n/, $_;
		next unless $id;
		my $sequence = Sequence->new(id => $id, seq => join("", @seq));
		push @sequences, $sequence;
	} # while

	return \@sequences;

}

# --------------------------------------------
sub count {
	my $self = shift;

	my $in_fh = $self->open;
	my $count = grep {$_ =~ m/^>/;} <$in_fh>;

	return $count;
}

# --------------------------------------------
sub ids {
	my $self = shift;
	my @ids  = ();
	my $seqs = $self->seqs;

	foreach my $sequence (@$seqs) {
		print $sequence->id, "\n";
		push @ids, $sequence->id;
	}

	return \@ids;
}

# --------------------------------------------
sub longerthan {
	my $self  = shift;
	my $value = shift;

	die "You have to give me a minimum sequence length!\n" 
		unless $value;

	my $seqs = $self->seqs;
	my @filtered_seqs  = grep { $_->length > $value } @{$seqs};

	return \@filtered_seqs;
}

__PACKAGE__->meta->make_immutable;
1;