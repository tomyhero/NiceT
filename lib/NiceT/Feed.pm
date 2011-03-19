package NiceT::Feed;
use warnings;
use strict;
use XML::Feed;
use URI;

my $map = {
    livedoor => {
        url => 'http://news.livedoor.com/topics/rss.xml',
    },
    'yahoo'  =>  {
        url => 'http://dailynews.yahoo.co.jp/fc/rss.xml',
    },
    'goo' => {
        url => 'http://news.goo.ne.jp/rss/topstories/gootop/index.rdf',
    },
    'infoseek' => {
        url => 'http://news2.www.infoseek.co.jp/rss/top.xml',
    },
};


sub new {
    my $class = shift;;
    return bless {},$class;
}


sub get {
    my $self = shift;
    my $name = shift;
    $self->parse($map->{$name}{url});
}

sub parse {
    my $self = shift;
    my $url  = shift;
    my $feed = XML::Feed->parse(URI->new( $url )) or return [];

    my @items = ();
    for my $entry ($feed->entries) {
        my $item = {
            url => $entry->link,
            title => $entry->title,
        };
        push @items,$item;
    }
    return \@items;
}




1;
