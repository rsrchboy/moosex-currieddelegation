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
BEGIN {
  $MooseX::CurriedDelegation::Trait::Method::Delegation::AUTHORITY = 'cpan:RSRCHBOY';
}
$MooseX::CurriedDelegation::Trait::Method::Delegation::VERSION = '0.002';
# ABSTRACT: A trait for curried delegation methods

use Moose::Role;
use namespace::autoclean;

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

=pod

=encoding UTF-8

=for :stopwords Chris Weyl

=for :stopwords Wishlist flattr flattr'ed gittip gittip'ed

=head1 NAME

MooseX::CurriedDelegation::Trait::Method::Delegation - A trait for curried delegation methods

=head1 VERSION

This document describes version 0.002 of MooseX::CurriedDelegation::Trait::Method::Delegation - released May 19, 2014 as part of MooseX-CurriedDelegation.

=head1 DESCRIPTION

This is just a trait applied to the delegation method metaclass (generally
L<Moose::Meta::Method::Delegation>).  No user-serviceable parts here.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<MooseX::CurriedDelegation|MooseX::CurriedDelegation>

=item *

L<MooseX::CurriedDelegation>

=back

=head1 SOURCE

The development version is on github at L<http://https://github.com/RsrchBoy/moosex-currieddelegation>
and may be cloned from L<git://https://github.com/RsrchBoy/moosex-currieddelegation.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/moosex-currieddelegation/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head2 I'm a material boy in a material world

=begin html

<a href="https://www.gittip.com/RsrchBoy/"><img src="https://raw.githubusercontent.com/gittip/www.gittip.com/master/www/assets/%25version/logo.png" /></a>
<a href="http://bit.ly/rsrchboys-wishlist"><img src="http://wps.io/wp-content/uploads/2014/05/amazon_wishlist.resized.png" /></a>
<a href="https://flattr.com/submit/auto?user_id=RsrchBoy&url=https%3A%2F%2Fgithub.com%2FRsrchBoy%2Fmoosex-currieddelegation&title=RsrchBoy's%20CPAN%20MooseX-CurriedDelegation&tags=%22RsrchBoy's%20MooseX-CurriedDelegation%20in%20the%20CPAN%22"><img src="http://api.flattr.com/button/flattr-badge-large.png" /></a>

=end html

Please note B<I do not expect to be gittip'ed or flattr'ed for this work>,
rather B<it is simply a very pleasant surprise>. I largely create and release
works like this because I need them or I find it enjoyable; however, don't let
that stop you if you feel like it ;)

L<Flattr this|https://flattr.com/submit/auto?user_id=RsrchBoy&url=https%3A%2F%2Fgithub.com%2FRsrchBoy%2Fmoosex-currieddelegation&title=RsrchBoy's%20CPAN%20MooseX-CurriedDelegation&tags=%22RsrchBoy's%20MooseX-CurriedDelegation%20in%20the%20CPAN%22>,
L<gittip me|https://www.gittip.com/RsrchBoy/>, or indulge my
L<Amazon Wishlist|http://bit.ly/rsrchboys-wishlist>...  If you so desire.

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut
