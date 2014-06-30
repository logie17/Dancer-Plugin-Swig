use strict;
use warnings;

use Test::More tests => 1;

use WebService::SwigClient;

{
    no warnings 'redefine';

    sub WebService::SwigClient::render {
        "asked for template $_[1] with tokens " . join ' ', %{$_[2]};
    }
}

{
    package MyApp;

    use Dancer;

    set logger => 'console';

    config->{engines}{swig} = {
        service_url => 'http://localhost:8081'
    };

    set template => 'swig';

    get '/' => sub {
        template 'hello_world';
    };

}

use Dancer::Test;

response_status_is '/' => 200;
response_content_like '/' => qr/hello_world/;

