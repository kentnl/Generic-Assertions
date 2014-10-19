use strict;
use warnings;

use Test::More;
use Test::Warnings qw( warning );
use Test::Fatal qw( exception );

# FILENAME: construction.t
# CREATED: 10/19/14 15:57:49 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Test basic construction

use Generic::Assertions;
my $tb = Test::Builder->new();

sub eok($$) {
  if ( not defined $_[0] ) {
    return $tb->ok( 1, $_[1] );
  }
  $tb->diag("Exception: $_[0]");
  return $tb->ok( 0, $_[1] );
}

sub eok_like($$$) {
  if ( not defined $_[0] ) {
    $tb->diag( "Expected exception like: $_[1]\n" . "                    got: undef" );
    return $tb->ok( 0, $_[2] );
  }
  if ( $_[0] !~ $_[1] ) {
    $tb->diag( "Expected exception like: $_[1]\n" . "                    got: $_[0]" );

    return $tb->ok( 0, $_[2] );
  }
  return $tb->ok( 1, $_[2] );
}

eok( exception { my $ass = Generic::Assertions->new() }, 'No args => no problem' );

eok_like( exception { my $ass = Generic::Assertions->new('foo') }, qr/even/, 'Odd args bad' );

eok_like( exception { my $ass = Generic::Assertions->new( x => 'y' ) }, qr/must be a CodeRef/, 'two args badder' );

eok(
  exception {
    my $ass = Generic::Assertions->new( x => sub { } );
    $ass->_test('x');
  },
  'two args but sub is good'
);

eok_like( exception { my $ass = Generic::Assertions->new( 'foo', 'foo', 'foo' ) }, qr/even/, 'Three args bad' );

eok_like(
  exception { my $ass = Generic::Assertions->new( '-tests' => { x => 'y' } ) },
  qr/must be a CodeRef/,
  'strings instead of coderefs in hashes are also bad'
);

eok_like(
  exception { my $ass = Generic::Assertions->new( { '-tests' => { x => 'y' } } ) },
  qr/must be a CodeRef/,
  'strings instead of coderefs in hashes are also bad, even when constructed via hashes'
);
eok(
  exception {
    my $ass = Generic::Assertions->new(
      {
        x => sub { }
      }
    );
    $ass->_test('x');
  },
  'sub is good in a top level test set'
);
eok(
  exception {
    my $ass = Generic::Assertions->new(
      -tests => {
        x => sub { }
      }
    );
    $ass->_test('x');
  },
  'sub is good in a hash test set'
);
eok(
  exception {
    my $ass = Generic::Assertions->new(
      {
        -tests => {
          x => sub { }
        }
      }
    );
    $ass->_test('x');
  },
  'sub is good in a hash test set when constructed as hashes'
);

done_testing;

