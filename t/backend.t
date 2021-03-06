#!/usr/bin/env perl

use strict;
use Test::More;
use Test::Mojo;
use Mojo::JSON qw /encode_json/;

use FindBin;
require "$FindBin::Bin/../backend.pl";


my $t = new Test::Mojo;

$t->get_ok('/')->status_is(200);

my %first = (
  firstkey => 5,
  secondkey => 2
);

my %second = (
  firstkey => 3,
  secondkey => 100500
);

$t->post_ok('/stats.json' => form =>
    {json => encode_json(\%first)})->status_is(200);

my @res = Model::Stats->select('where key=?', 'firstkey');
is($res[0]->count, 5);

$t->post_ok('/stats.json' => form =>
    {json => encode_json(\%second)})->status_is(200);

$t->get_ok('/stats.json')->json_is([
        {secondkey  => 100502},
        {firstkey   => 8}
    ]
);

done_testing();