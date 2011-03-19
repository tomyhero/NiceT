package NiceT::Controller::API;
use strict;
use warnings;
use parent 'Pickles::Controller';
use JSON::Syck ;
use NiceT::Feed;
use NiceT::DB;

__PACKAGE__->add_trigger( pre_action => sub {
    my ( $self,$c ) = @_;
    $c->res->content_type('application/x-javascript; charset=utf-8');
});
sub list {
    my( $self, $c ) = @_;
    my $name = $c->args->{name};

    my $feed = NiceT::Feed->new();
    my $items = $feed->get($name); 

    my $config = $c->config;
    my %args = %{$config->get('db')} ;
    my $db = NiceT::DB->new( \%args );   

    $db->connect();
    for(@$items){
        $_->{nice} = $db->get_nice($_->{url});
    }
    $db->disconnect();


    my $data = {
        items => $items,
        name => $name,
    };
    my $json = JSON::Syck::Dump($data);
    $c->res->body($json);
    $c->finished(1);
}

sub nice {
    my( $self, $c ) = @_;
    my $url = $c->req->param('url') or die 'omg';

    my $config = $c->config;
    my %args = %{$config->get('db')} ;
    my $db = NiceT::DB->new( \%args );   
    my $nice = $db->do_nice( $url );

    my $json = JSON::Syck::Dump({nice => $nice } );

    $c->res->body($json);
    $c->finished(1);
}

1;

__END__

