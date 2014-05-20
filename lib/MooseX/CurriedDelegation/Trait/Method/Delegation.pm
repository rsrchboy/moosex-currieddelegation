#
# This file is part of MooseX-CurriedDelegation
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::CurriedDelegation::Trait::Method::Delegation;
{
  $MooseX::CurriedDelegation::Trait::Method::Delegation::VERSION = '0.001';
}

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



=pod

=encoding utf-8

=head1 NAME

MooseX::CurriedDelegation::Trait::Method::Delegation - The great new MooseX::CurriedDelegation!

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This is just a trait applied to the delegation method metaclass (generally
L<Moose::Meta::Method::Delegation>).  No user-servicable parts here.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<MooseX::CurriedDelegation|MooseX::CurriedDelegation>

=item *

L<MooseX::CurriedDelegation>

=back

=head1 SOURCE

The development version is on github at L<http://github.com/RsrchBoy/moosex-currieddelegation>
and may be cloned from L<git://github.com/RsrchBoy/moosex-currieddelegation.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/moosex-currieddelegation/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__

