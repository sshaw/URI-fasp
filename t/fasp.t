use strict;
use warnings;

use URI;
use Test::More tests => 17;

my $uri = URI->new('fasp://example.com');
isa_ok($uri, 'URI::fasp');
is($uri->port, 22);
is($uri->default_faspport, 33001);
is($uri->faspport, 33001);

$uri = URI->new('fasp://example.com:33001?port=5000&bwcap=1000&policy=fair&httpport=8080&targetrate=50000');
is($uri->faspport, 5000);
is($uri->bwcap, 1000);
is($uri->policy, 'fair');
is($uri->httpport, 8080);
is($uri->targetrate, 50000);

$uri->faspport(33001);
is($uri->faspport, 33001);

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

# Aspera uses "port", we use that and "faspport"
$uri = URI->new('fasp://example.com:33001?faspport=5000');
is($uri->faspport, 5000);

