package MooseX::CurriedDelegation::Trait::Method::Delegation;

# ABSTRACT: The great new MooseX::CurriedDelegation!

use Moose::Role;
use namespace::autoclean;
use Moose::Util 'with_traits';

# debugging...
#use Smart::Comments;

has curry_coderef => (is => 'ro', isa => 'Coderef', required => 1);

# _initialize_body() is largely lifted right from
# Moose::Meta::Method::Delegation

sub _initialize_body {
    my $self = shift;

    my $method_to_call = $self->delegate_to_method;
    # XXX
    #return $self->{body} = $method_to_call
    #    if ref $method_to_call;

    my $accessor      = $self->_get_delegate_accessor;
    my $handle_name   = $self->name;

    return $self->{body} = sub {

        my $instance      = shift;
        my $proxy         = $instance->$accessor();
        my $curry_coderef = $self->curry_coderef;

        ### $curry_coderef

        my $error
            = !defined $proxy                 ? ' is not defined'
            : ref($proxy) && !blessed($proxy) ? qq{ is not an object (got '$proxy')}
            : undef;

        if ($error) {
            $self->throw_error(
                "Cannot delegate $handle_name to $method_to_call because "
                    . "the value of "
                    . $self->associated_attribute->name
                    . $error,
                method_name => $method_to_call,
                object      => $instance
            );
        }
        unshift @_, @{ $self->curried_arguments };
        unshift @_, $instance->$curry_coderef();
        $proxy->$method_to_call(@_);
    };
}

!!42;

__END__

=head1 DESCRIPTION

This is just a trait applied to the delegation method metaclass (generally
L<Moose::Meta::Method::Delegation>).  No user-servicable parts here.

=head1 SEE ALSO

L<MooseX::CurriedDelegation>

=cut
