package Fasta::Reader;

use Moose;

# --------------------------------------------
# ATTRIBUTES

has "file" => (
	isa => "Str",
	is => "rw",
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
	my $self 	 = shift;
	my %seq_info = ();

	my $in_fh = $self->open;

	local $/ = ">";

	while (<$in_fh>) {
		chomp;
		my ($id, @seq) = split /\n/, $_;
		next unless $id;

		$seq_info{$id} = join "\n", @seq;
	} # while

	return \%seq_info;

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

	my @ids = keys %{ $self->seqs };

	return \@ids;
}

# --------------------------------------------
sub longer_than {
	my $self  = shift;
	my $value = shift;

	die "You have to give me a minimum sequence length!\n" 
		unless $value;

	my $seqs = $self->seqs;
	my %filtered_seqs  = map {$_, $seqs->{$_}} 
                         grep { length($seqs->{$_}) > $value } keys %{$seqs};

	return \%filtered_seqs;
}

1;