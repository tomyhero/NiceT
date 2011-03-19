package NiceT::DB;
use warnings;
use strict;
use DBI;

sub new {
    my $class = shift;
    my $args = shift || {};
    my $self = bless $args,$class;
    return $self;
}

sub connect {
    my $self = shift;
    my $dbh = DBI->connect( $self->{dsn},$self->{user},$self->{password});
    $dbh->ping or die 'fail to connect';
    $self->{dbh} = $dbh;

    1;
}

sub disconnect {
    shift->{dbh}->disconnect();
}

sub do_nice {
    my $self = shift;
    my $url = shift;
    $self->connect();

    my $sth = $self->dbh->prepare('SELECT * FROM nice WHERE url = ?');
    $sth->execute($url);
    my $item = $sth->fetchrow_hashref;
    $sth->finish();

    my $nice ;
    if($item){
        # update
        $self->_update_nice($url);  
        $nice = $item->{nice}+1;
    }
    else {
        # create 
        $nice = 1;
        $self->_insert_nice($url);  

    }

    $self->disconnect();

    return $nice;
}

sub _update_nice {
    my $self =shift;
    my $url = shift;
    my $sql = 'UPDATE nice SET nice = nice + 1 WHERE url = ?';
    my $sth = $self->dbh->prepare($sql);
    $sth->execute($url);
    $sth->finish();
}
sub _insert_nice {
    my $self =shift;
    my $url = shift;
    my $sql = 'INSERT INTO nice(url,nice) values(?,1)';
    my $sth = $self->dbh->prepare($sql);
    $sth->execute($url);
    $sth->finish();
}

sub get_nice {
    my $self = shift;
    my $url = shift;

    my $sth = $self->dbh->prepare('SELECT * FROM nice WHERE url = ?');
    $sth->execute($url);
    my $item = $sth->fetchrow_hashref;
    $sth->finish();


    if($item){
        return $item->{nice};
    }
    else {
        return 0;
    }

}

sub dbh { shift->{dbh} };

1;
