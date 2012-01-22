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

=head1 DESCRIPTION

=head1 SEE ALSO

L<Moose>, L<Moose::Meta::Method::Delegation>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no exception.

Bugs, feature requests and pull requests through GitHub are most welcome; our
page and repo (same URI):

    https://github.com/RsrchBoy/moosex-currieddelegation

=cut

