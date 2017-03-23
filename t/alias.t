use strict;
use warnings;

use Test::More;
use Test::Moose::More;

{
    package TestClass;
    use Moose;
    use MooseX::CurriedDelegation;
}

# Simple check to ensure our shortcut is exported

can_ok TestClass => 'CurriedDelegation';
is TestClass::CurriedDelegation() =>
    'MooseX::CurriedDelegation::Trait::Attribute',
    'CurriedDelegation() correct',
    ;

done_testing;
