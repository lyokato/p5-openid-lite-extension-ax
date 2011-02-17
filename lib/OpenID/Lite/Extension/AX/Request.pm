package OpenID::Lite::Extension::AX::Request;

use Any::Moose;
extends 'OpenID::Lite::Extension::Request';

use OpenID::Lite::Extension::AX qw(
    AX_NS
    AX_NS_ALIAS
    AX_TYPE_NS_OF
);

has 'mode' => (
    is      => 'rw',
    isa     => 'Str',
    default => q{fetch_request},
);

has 'required' => (
    is      => 'rw',
    isa     => 'Str',
    default => q{country,email,firstname,language,lastname},
);

override 'append_to_params' => sub {
    my ( $self, $params ) = @_;
    $params->register_extension_namespace( AX_NS_ALIAS, AX_NS );
    $params->set_extension( AX_NS_ALIAS, 'mode', $self->mode );
    $params->set_extension( AX_NS_ALIAS, 'required', $self->required );

    for my $type (map { lc } split /\s*,\s*/, $self->required) {
        next unless exists AX_TYPE_NS_OF->{$type};
        $params->set_extension( AX_NS_ALIAS, "type.${type}", AX_TYPE_NS_OF->{$type} );
    }
};

# for OP side
sub from_provider_response {
    my ( $class, $res ) = @_;
    my $message = $res->req_params->copy();
    my $ns_url  = AX_NS;
    my $alias   = $message->get_ns_alias($ns_url);
    return unless $alias;
    my $data = $message->get_extension_args($alias) || {};
    my $obj = $class->new();
    my $result = $obj->parse_extension_args($data);
    return $result ? $obj : undef;
}

sub parse_extension_args {
    my ( $self, $args ) = @_;
    $self->mode( $args->{mode} ) if $args->{mode};
    $self->required( $args->{required} ) if $args->{required};
    return 1;
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;
