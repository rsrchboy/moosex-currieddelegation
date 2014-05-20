package MooseX::CurriedDelegation::Trait::Attribute;

# ABSTRACT: The great new MooseX::CurriedDelegation!

use Moose::Role;
use namespace::autoclean;
use MooseX::Util 'with_traits';

# debugging...
#use Smart::Comments;

=method method_curried_delegation_metaclass

Returns a class composed of the applied class' delegation metaclass and our
delegation method trait.

=cut


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

__END__

=head1 DESCRIPTION

This is just a trait applied to the delegation method metaclass (generally
L<Moose::Meta::Method::Delegation>).  No user-servicable parts here.

=head1 SEE ALSO

L<MooseX::CurriedDelegation>

=cut

