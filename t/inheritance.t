use strict;
use warnings;

use Test::More;
use Test::Moose::More;

my $trait; # = 'MooseX::CurriedDelegation::Trait::Attribute';

{
    package TestBase;
    use Moose;
    has base  => (is => 'ro');
    has base2 => (is => 'ro');
    no Moose;
}

{
    package TestClass;
    use Moose;
    use MooseX::CurriedDelegation;
    use Moose::Util;
    $trait = CurriedDelegation; # Moose::Util::resolve_metatrait_alias Attribute => CurriedDelegation();
    extends 'TestBase';
    has tc_att => (is      => 'ro');
    has '+base'  => (default =>   1 );
    has '+base2'  => (traits => [CurriedDelegation], default => 1 );
    no Moose;
}
{
    package TestClass::OneMoreTime;
    use Moose;
    extends 'TestClass';
    has omt => (is => 'ro');
    no Moose;
}


validate_class TestBase => (
    -subtest => q{Sanity check TestBase's base doesn't have our trait},
    # attributes => [ base => { -does_not => ['MooseX::CurriedDelegation::Trait::Attribute'] }],
    attributes => [ base => { -isa => ['Moose::Meta::Attribute'], -does_not => [$trait] }],
);

validate_class TestClass => (
    -subtest => q{Inherited attributes do not have the trait applied unless applied manually},

    isa => ['TestBase'],

    attributes => [

        tc_att => { -does => [$trait] },
        base   => { -does_not         => [$trait] },
        base2  => { -does        => [$trait] },
    ],
);

validate_class 'TestClass::OneMoreTime' => (
    -subtest => 'New attributes in child classes do our trait',
    
    isa => ['TestClass'],

    attributes => [ omt => { -does => [$trait] } ],
);

done_testing;
