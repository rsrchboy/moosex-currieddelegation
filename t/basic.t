use strict;
use warnings;

use Test::More;
use Test::Moose;
use Test::Moose::More;

{
    package TestClass::Delagatee;
    use Moose;

    sub curried { shift; return @_ }

    sub foo { }
    sub bar { }
    sub baz { }
}
{
    package TestClass;

    use Moose;
    use MooseX::CurriedDelegation;

    has one => (is => 'ro', isa => 'Str', default => 'default');

    has foo => (

        is      => 'rw',
        isa     => 'TestClass::Delagatee',
        default => sub { TestClass::Delagatee->new() },

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
            # foo_del_one => { remote_method => [ sub { ..gen curry args.. }, qw{ more curry args } ] },

            foo_del_one => { curried => [ sub { shift->one }, qw{ more curry args } ] },

            ## curry_with_self returns: remote_method => sub { shift }
            #baz => { curry_with_self 'remote_method' => qw{ more curry args } },
            #
            #bar => { curry_with 'remote_method' { ..gen curry args.. } qw{ more curry args } },

        },
    );

}

our $tc = 'TestClass';

with_immutable {

    meta_ok $tc;

    has_attribute_ok $tc, 'foo', 'one';
    has_method_ok $tc, 'foo', 'foo_del_one';

    my $test = $tc->new(one => 'not_default');

    is_deeply(
        [ $test->foo_del_one                ],
        [ qw{ not_default more curry args } ],
        'simple method currying works as expected',
    );

} 'TestClass';

done_testing;
