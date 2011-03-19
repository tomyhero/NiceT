use Test::More;


use_ok('NiceT::Feed');

my $feed = NiceT::Feed->new();

for(qw/livedoor yahoo goo infoseek/){ 
    my $items = $feed->get($_);
    ok(scalar @$items);
}


done_testing();
