package Geo::Format::HTTP;
use strict;
use warnings;
our $VERSION = '1.0';
use Exporter::Lite;

our @EXPORT = qw(
    get_location_from_req
);

sub get_location_from_req ($) {
    my $req = shift;
    no warnings 'uninitialized';
    
    my ($lat, $lon);
    if (my $pos = $req->param('pos')) {
        # Softbank
        $pos =~ /^([NS])([0-9]+)\.([0-9]+)\.([0-9]+)\.(?:[0-9]+)([EW])([0-9]+)\.([0-9]+)\.([0-9]+)\.(?:[0-9]+)$/;

        $lat = $2 + ($3 / 60) + ($4 / 60 / 60);
        $lat *= -1 if $1 eq 'S';
        $lon = $6 + ($7 / 60) + ($8 / 60 / 60);
        $lon *= -1 if $5 eq 'W';

    } elsif (my $ll = $req->param('ll')) {
        my @latlon = split ',' ,  $ll;
        $lat = $latlon[0] || 0;
        $lon = $latlon[1] || 0;
    } else {
        $lat = $req->param('lat') || 0;
        $lon = $req->param('lon') || 0;

        # Fraction part of second is not support at the moment.

        if ($lat =~ /([+-]?[0-9]+)\.([0-9]+)\.([0-9.]+)/) {
            # au, docomo (au's non-GPS data does not have leading "+")
            $lat = $1 + ($2 / 60) + ($3 / 60 / 60);
        } else {
            $lat += 0;
        }
        
        if ($lon =~ /([+-]?[0-9]+)\.([0-9]+)\.([0-9.]+)/) {
            $lon = $1 + ($2 / 60) + ($3 / 60 / 60);
        } else {
            $lon += 0;
        }
    }

    if ($lat > +90) {
        $lat = +90;
    } elsif ($lat < -90) {
        $lat = -90;
    }
    
    if ($lon > +180) {
        $lon = +180;
    } elsif ($lon < -180) {
        $lon = -180;
    }

    # It returns false values if the position cannot be retrieved from
    # $pos.
    return ($lat, $lon);
}

1;
