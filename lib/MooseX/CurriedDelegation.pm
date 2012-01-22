package MooseX::CurriedDelegation;

# ABSTRACT: Curry your delegations with methods

use strict;
use warnings;

use Moose ( );
use Moose::Exporter;

my $trait = 'MooseX::CurriedDelegation::Trait::Attribute';

Moose::Exporter->setup_import_methods(
    trait_aliases => [ $trait => 'CurriedDelegation' ],

    class_metaroles => { attribute         => [ $trait ] },
    role_metaroles  => { applied_attribute => [ $trait ] },
);

!!42;

__END__

=head1 SYNOPSIS

    use Moose;
    use MooseX::CurriedDelegation;

    has one => (is => 'ro', isa => 'Str', default => 'default');

    has foo => (

        is      => 'rw',
        isa     => 'TestClass::Delagatee', # has method curried()
        default => sub { TestClass::Delagatee->new },

        handles => {

            # method-curry
            #   triggered by hashref, not arrayref
            #   first arg is the remote method to delegate to
            #   second is an arrayref comprising:
            #       coderef to call as a method on the instance, followed by
            #       "static" curry args
            #
            # so, essentially:
            #   $self->foo->remote_method($self->$coderef(), @remaining_args);
            #
            # foo_del_one => {
            #   remote_method => [ sub { ... }, qw{ static args } ],
            # },

            foo_del_one => { curried => [ sub { shift->one }, qw{ more curry args } ] },

        },
    );


=head1 DESCRIPTION

Method delegation is awfully handy -- but sometimes it'd be awfully handier if
it was a touch more dynamic.  This is an attribute trait that provides for a
curried, delegated method to be provided anyna

=head1 TRAIT ALIASES

=head2 CurriedDelegation

Resolves out to the full name of our attribute trait; you can use it as:

    has foo => ( traits => [CurriedDelegation], ...)

=head1 SEE ALSO

L<Moose>, L<Moose::Meta::Method::Delegation>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Bugs, feature requests and pull requests through GitHub are most welcome; our
page and repo (same URI):

    https://github.com/RsrchBoy/moosex-currieddelegation

=cut

