package Dancer::Template::Swig;

use strict;
use warnings;

use WebService::SwigClient;
use Dancer::Config qw/ setting /;

use Moo;

extends 'Dancer::Template::Abstract';

sub _build_name { 'Dancer::Template::Swig' };

has 'default_tmpl_ext' => (
    is => 'ro',
    default => sub { 'html' },
);

has swig => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my %plugin_settings = %{ $_[0]->config || {} };

        my $service_url = $plugin_settings{service_url}
            or die "A service url is required in order to use this plugin";

        return WebService::SwigClient->new(service_url => $service_url);
    },
    clearer => 'reinitialize',
);



sub render {
    my( $self, $template, $tokens ) = @_;

    return $self->swig->render( $template => $tokens );
}

# those last two subs are to override the default
# behavior of Dancer::Template::Abstract, which 
# assumes that the templates are files on disk

sub view {
    my( $self, $view ) = @_;
    return $view;
}

sub view_exists {
    1;
}

1;

__END__
