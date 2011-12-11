use strict;
use warnings;

use URI;
use Test::More tests => 19;

my $uri = URI->new('fasp://example.com');
isa_ok($uri, 'URI::fasp');
is($uri->port, 22);
is($uri->default_fasp_port, 33001);
is($uri->fasp_port, 33001);
is("$uri", 'fasp://example.com');

# Like URI we only show the port if it's explicitly set
$uri->fasp_port(33001);
is("$uri", 'fasp://example.com?port=33001');

$uri = URI->new('fasp://example.com:33001?port=5000&bwcap=1000&policy=fair&httpport=8080&targetrate=50000');
is($uri->fasp_port, 5000);
is($uri->port, 33001);
is($uri->bwcap, 1000);
is($uri->policy, 'fair');
is($uri->httpport, 8080);
is($uri->targetrate, 50000);

$uri->fasp_port(33001);
is($uri->fasp_port, 33001);

$uri->bwcap(25000);
is($uri->bwcap, 25000);

$uri->policy('unlimited');
is($uri->policy, 'unlimited');

$uri->targetrate(100000);
is($uri->targetrate, 100000);

my $ssh = $uri->as_ssh;
isa_ok($ssh, 'URI::ssh');
is($ssh->port, 33001);
is($ssh->query, undef);



