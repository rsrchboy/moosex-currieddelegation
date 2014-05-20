#
# This file is part of MooseX-CurriedDelegation
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::CurriedDelegation::Trait::Attribute;
{
  $MooseX::CurriedDelegation::Trait::Attribute::VERSION = '0.001';
}

# ABSTRACT: The great new MooseX::CurriedDelegation!

use Moose::Role;
use namespace::autoclean;
use Moose::Util 'with_traits';

# debugging...
#use Smart::Comments;



sub method_curried_delegation_metaclass {
    return with_traits
        shift->delegation_metaclass,
        'MooseX::CurriedDelegation::Trait::Method::Delegation',
        ;
}

around _make_delegation_method => sub {
    my ($orig, $self) = (shift, shift);
    my ($handle_name, $delegation_hash) = @_;

    ### $delegation_hash
    return $self->$orig(@_)
        unless 'HASH' eq ref $delegation_hash;

    confess "We should never have more than one key when setting up delegation: $handle_name"
        if keys %$delegation_hash > 1;

    my ($method_to_call) = keys %$delegation_hash;
    my @curry_args       = @{ $delegation_hash->{$method_to_call} };
    my $curry_coderef    = shift @curry_args;

    ### $method_to_call
    ### @curry_args

    return $self->method_curried_delegation_metaclass->new(
        name               => $handle_name,
        package_name       => $self->associated_class->name,
        attribute          => $self,
        delegate_to_method => $method_to_call,
        curry_coderef      => $curry_coderef,
        curried_arguments  => \@curry_args,
    );
};

!!42;



=pod

=encoding utf-8

=head1 NAME

MooseX::CurriedDelegation::Trait::Attribute - The great new MooseX::CurriedDelegation!

=head1 VERSION

version 0.001

=head1 DESCRIPTION

This is just a trait applied to the delegation method metaclass (generally
L<Moose::Meta::Method::Delegation>).  No user-servicable parts here.

=head1 METHODS

=head2 method_curried_delegation_metaclass

Returns a class composed of the applied class' delegation metaclass and our
delegation method trait.

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


