
use strict;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir( dirname(__FILE__), 'lib' );

use Plack::Builder;
use NiceT;

my $webapp = NiceT->new;
my $app = $webapp->handler;
my $config = $webapp->config;

builder {
    enable 'StackTrace';
    enable 'Static',
        path => qr{^/static/}, root => $config->path_to('htdocs');
    $app;
};


