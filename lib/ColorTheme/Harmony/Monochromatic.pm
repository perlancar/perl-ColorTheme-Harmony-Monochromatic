package ColorTheme::Harmony::Monochromatic;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;
use parent 'ColorThemeBase::Static::FromObjectColors';

# TODO: allow some colors to have a different saturation, like in
# color.adobe.com

our %THEME = (
    v => 2,
    summary => 'Create a monochromatic color theme',
    description => <<'_',

All the colors in the theme will have the same hue *h*, but different saturation
(between *s1* and *s2*) and brightness (between *v1* and *v2*).

Example to see on the terminal:

    % show-color-theme-swatch Harmony::Monochromatic=h,86

_
    dynamic => 1,
    args => {
        n => {
            summary => 'Number of colors in the theme',
            schema => ['posodd*', max=>99], # give a sane maximum
            default => 5,
        },
        h => {
            summary => 'Hue of the colors',
            schema => ['num*', between=>[0, 360]],
            req => 1,
        },
        s1 => {
            summary => 'The left extreme of saturation',
            schema => ['num*', between=>[0, 1]],
            default => 0.75,
        },
        s2 => {
            summary => 'The right extreme of saturation',
            schema => ['num*', between=>[0, 1]],
            default => 0.25,
        },
        v1 => {
            summary => 'The left extreme of brightness',
            schema => ['num*', between=>[0, 1]],
            default => 1,
        },
        v2 => {
            summary => 'The right extreme of brightness',
            schema => ['num*', between=>[0, 1]],
            default => 0.5,
        },
    },
);

sub new {
    require Color::RGB::Util;

    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my %colors;

    my $n = $self->{args}{n};
    my $h = $self->{args}{h};
    my $s1 = $self->{args}{s1};
    my $s2 = $self->{args}{s2};
    my $v1 = $self->{args}{v1};
    my $v2 = $self->{args}{v2};

    my $j_middle = int($n/2) + 1;

    my $s_dist = $n > 1 ? ($s2 - $s1) / ($n-1) : 0;
    my $v_dist = $n > 1 ? ($v2 - $v1) / ($n-1) : 0;

    for my $i (0..$n-1) {
        my $j = (($j_middle + $i*2 - 1) % $n) + 1;
        my $s = $s1 + $i*$s_dist;
        my $v = $v1 + $i*$v_dist;
        $colors{"color$j"} = Color::RGB::Util::hsv2rgb(sprintf "%d %.4f %.4f", $h, $s, $v);
    }

    $self->{items} = \%colors;
    $self;
}

1;
# ABSTRACT:

=head1 SEE ALSO

Other C<ColorTheme::Harmony::*> modules.
