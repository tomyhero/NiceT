use Test::More;
use NiceT::DB;
use NiceT::Config;

my $config = NiceT::Config->construct();
my %args = %{$config->get('db')} ;

my $db =NiceT::DB->new( \%args );

ok($db->connect());
$db->disconnect();

$db->do_nice('nice_topic');

$db->connect();
my $nice = $db->get_nice('nice_topic');
$db->disconnect();
ok($nice );

done_testing();
