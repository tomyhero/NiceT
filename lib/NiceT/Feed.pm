package NiceT::Feed;
use warnings;
use strict;
use XML::Feed;
use URI;
use URI::QueryParam;

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
    my $items =$self->parse($map->{$name}{url});

    if($name eq 'infoseek'){

        for(@$items){
            my $xxx = URI->new($_->{url});
            my $url = $xxx->query_param('rd');
            $url =~ s/\?.+//;
            $_->{url} = $url;
        }
    }
    elsif($name eq 'livedoor'){
        #for(@$items){
            #$_->{url} =~ s/topics/article/;
        #}

    }
    elsif($name eq 'goo'){
        for(@$items){
            $_->{url} =~ s/\?.+//;
        }

    }
    elsif($name eq 'yahoo'){
        #for(@$items){
            #my $a= 'http://rd.yahoo.co.jp/rss/l/topics/topics/\*';
            #$_->{url} =~ s/$a//;
        #}

    }
    return $items;
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
