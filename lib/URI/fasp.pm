package URI::fasp;

#https://support.asperasoft.com/entries/20153151-http-fallback-configuration-testing-and-troubleshooting

use strict;
use warnings;
use base 'URI::ssh';

use URI::QueryParam;

our $VERSION = '0.01';

sub _init
{
    my $class = shift;
    my $self  = $class->SUPER::_init(@_);    
    $self->faspport($self->default_faspport) unless defined $self->faspport;
    # Other defaults
    $self;
}

sub bwcap { shift->_query_param('bwcap', @_); }
sub policy { shift->_query_param('policy', @_); }
sub httpport { shift->_query_param('httpport', @_); }
sub targetrate { shift->_query_param('targetrate', @_); }
sub default_faspport { 33001 }

sub faspport
{
    my $self = shift;
    return $self->_query_param('port', @_) if @_;
    my $port = $self->query_param('port') || 
      	       $self->query_param('faspport');
    $port;
}

sub as_ssh
{
    my $self = shift;
    my $ssh = $self->clone;
    $ssh->scheme('ssh');
    $ssh->query(undef);
    $ssh;
}

sub _query_param
{
    my ($self, $param, $value) = @_;

    # Do we need to accept multiple args here?
    if($value) {
	$self->query_param($param, $value);
	return;
    }
        
    $self->query_param($param);
}

1;

=pod

=head1 NAME

URI::fasp - URI handler for Aspera's FASP protocol

=head1 SYNOPSIS

   $fasp = URI->new('fasp://example.com:97001?port=33001&bwcap=25000');
   $fasp->targetrate(10_000);

   print $fasp->port;		# 97001
   print $fasp->faspport;	# 33001
   print $fasp->bwcap;		# 25000
   # ...
   $ssh = $fasp->as_ssh;	# URI::ssh 
   print $ssh->port;		# 97001	

=head1 METHODS


       
=head1 SEE ALSO

L<URI>, http://asperasoft.com

