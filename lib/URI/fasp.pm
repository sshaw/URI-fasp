package URI::fasp;

use strict;
use warnings;
use base 'URI::ssh';

use URI::QueryParam;

our $VERSION = '0.01';

{
 no strict 'refs';
 for my $attr (qw|bwcap policy httpport targetrate|) {   
   *$attr = sub { 
     shift->query_param($attr, @_); 
   }
 }
}

sub _init {  shift->SUPER::_init(@_); }
sub default_fasp_port { 33001 }

# Aspera uses "port". To avoid conflicting with the URI method of the same name we call 
# this method "fasp_port". Both names are supported as query params.
sub fasp_port
{
    my $self  = shift;
    if(@_) {
      $self->query_param('port', @_);
      return;
    }
    
    $self->query_param('port') or
    $self->default_fasp_port;
}

sub as_ssh
{
    my $self = shift;
    my $ssh = $self->clone;
    $ssh->scheme('ssh');
    $ssh->query(undef);
    $ssh;
}

1;

=pod

=head1 NAME

URI::fasp - URI handler for Aspera's FASP protocol

=head1 SYNOPSIS

   $fasp = URI->new('fasp://example.com:97001?port=33001&bwcap=25000');
   $fasp->targetrate(10_000);

   print $fasp->port;		# 97001
   print $fasp->fasp_port;	# 33001
   print $fasp->bwcap;		# 25000
   # ...
   $ssh = $fasp->as_ssh;	# URI::ssh 
   print $ssh->port;		# 97001	

=head1 DESCRIPTION

Aspera uses seperate control and a data connections. The control connection is a SSH session. 
This class is a subclass of L<< C<URI::ssh>|URI >> and uses the L<< C<URI::QueryParam> >> mixin. 

=head1 METHODS

=head2 C<as_ssh>

L<< C<URI::ssh>|URI >> representation of the instance's control connection

=head2 C<default_fasp_port>

The default FASP port is 33001

=head2 C<fasp_port>

Defaults to L<< C<default_fasp_port> >>

=head2 C<bwcap>

Bandwidth cap

=head2 C<policy>

Transfer policy

=head2 C<httpport>

Fallback HTTP port

=head2 C<targetrate>

Target transfer rate

=head1 SEE ALSO

L<URI>, L<URI::QueryParam>, http://asperasoft.com

=head1 AUTHOR

Skye Shaw (sshaw AT lucas.cis.temple.edu)

=head1 LICENSE

Copyright (c) 2011 Skye Shaw. This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.
