package OpenID::Lite::Extension::AX;

use strict;
use warnings;
use base 'Exporter';

our $VERSION = '0.01';
our @EXPORT_OK = qw(
                       AX_NS
                       AX_NS_ALIAS
                       AX_TYPE_NS_OF
                  );

use constant AX_NS           => q{http://openid.net/srv/ax/1.0};
use constant AX_NS_ALIAS     => q{ax};
use constant AX_TYPE_NS_OF => {
    country   => q{http://axschema.org/contact/country/home},
    email     => q{http://axschema.org/contact/email},
    firstname => q{http://axschema.org/namePerson/first},
    language  => q{http://axschema.org/pref/language},
    lastname  => q{http://axschema.org/namePerson/last},
};

1;

=head1 NAME

OpenID::Lite::Extension::AX - Attribute exchange extension plugin for OpenID::Lite

=head1 SYNOPSIS

RP side

    sub login {
        ...
        my $checkid_req = $rp->begin( $identifier )
            or $your_app->error( $rp->errstr );

        $ax_req = OpenID::Lite::Extension::AX::Request->new;
        $ax_req->required('email');
        $checkid_req->add_extension( $ax_req );

        $your_app->redirect_to( $checkid_req->redirect_url( ... ) );
    }

OP side (!!NOT TESTED!!)

    my $res = $op->handle_request( $your_app->request );

    if ( $res->is_for_setup ) {

        my %option;
        my $ax_req = OpenID::Lite::Extension::AX::Request->from_provider_response($res);
        if ($ax_req) {
            if ($ax_req->mode eq 'fetch_request') {
                ...
            }
        }
        $your_app->render( %option );
    }...

=head1 DESCRIPTION

This module is plugin for OpenID::Lite to acomplish Attribute exchange extension flow on easy way.

http://openid.net/specs/openid-attribute-exchange-1_0.html
http://code.google.com/intl/ja/apis/accounts/docs/OpenID.html

=head1 SEE ALSO

L<OpenID::Lite::Extension::AX::Request>

L<OpenID::Lite::RelyingParty>
L<OpenID::Lite::Provider>

=head1 AUTHOR

HIROSE Masaaki, E<lt>hirose31@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright HIROSE Masaaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
