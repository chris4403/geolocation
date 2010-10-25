#!/usr/bin/env perl
use strict;
use warnings;

use LWP::Simple qw(get);
use Data::Dumper;
use Perl6::Say;
use JSON::XS;

my $url = sprintf "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&language=ja&address=%s", shift;

my $res = get $url;
$res = decode_json $res;
my $results = $res->{results};
foreach my $result (@$results) {
    say "----------";
    say $result->{formatted_address};
    say $result->{geometry}->{location}->{lat} . "," .$result->{geometry}->{location}->{lng};
}

