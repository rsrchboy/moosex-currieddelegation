#
# This file is part of MooseX-CurriedDelegation
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package MooseX::CurriedDelegation;
{
  $MooseX::CurriedDelegation::VERSION = '0.001';
}

# ABSTRACT: Curry your delegations with methods

use strict;
use warnings;

use Moose ( );
use Moose::Exporter;

my $trait = 'MooseX::CurriedDelegation::Trait::Attribute';

Moose::Exporter->setup_import_methods(
    trait_aliases => [ $trait => 'CurriedDelegation' ],

    as_is => [ qw{ curry_to_self } ],
    class_metaroles => { attribute         => [ $trait ] },
    role_metaroles  => { applied_attribute => [ $trait ] },
);

sub curry_to_self() { sub { shift } }

!!42;



=pod

=encoding utf-8

=head1 NAME

MooseX::CurriedDelegation - Curry your delegations with methods

=head1 VERSION

version 0.001

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
            #   Note the hashref, not arrayref, we employ
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

            # curry_to_self() always returns: sub { shift }
            foo_del_two => { other_method => [ curry_to_self ] },
        },
    );

=head1 DESCRIPTION

Method delegation is awfully handy -- but sometimes it'd be awfully handier if
it was a touch more dynamic.  This is an attribute trait that provides for a
curried, delegated method to be provided anyna

=head1 USAGE

Using this package will cause the relevant attribute trait to be applied
without requiring further intervention.  We use the standard

    handles => { local_method => delegate_info, ... }

delegation methodology, however our currying is invoked when delegate_info is
a hashref.  We expect delegate info to look like:

    { remote_method => [ $coderef, @more_curry_args ] }

Only $coderef is ever executed by the delegation.  This means that it is safe
to have any number of additional coderefs in @more_curry_args: they will be
passed through to remote_method without additional manipulation.

=head1 ADDITIONAL SUGAR

In addition, we export a number of helper functions.

=head2 curry_to_self()

This function always returns a coderef like "sub { shift }".  That is, this:

    local => { remote => [ curry_to_self ] }

is equivalent to:

    local => { remote => [ sub { shift } ] }

=head1 TRAIT ALIASES

=head2 CurriedDelegation

Resolves out to the full name of our attribute trait; you can use it as:

    has foo => (traits => [CurriedDelegation], ...)

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Moose>

=item *

L<Moose::Meta::Method::Delegation>

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

