#!/usr/bin/perl -w

use Test::Inter;
$t = new Test::Inter 'next';
$testdir = '';
$testdir = $t->testdir();

use Date::Manip;
if (DateManipVersion() >= 6.00) {
   $t->feature("DM6",1);
}

$t->skip_all('Date::Manip 6.xx required','DM6');


sub test {
  (@test)=@_;
  my $date = shift(@test);
  $obj->set("date",$date);
  $err = $obj->next(@test);
  if ($err) {
     return $obj->err();
  } else {
     return [ $obj->value() ];
  }
}

$obj = new Date::Manip::Date;
$obj->config("forcedate","now,America/New_York");

$tests="

[ 1996 11 22 17 49 30 ] 6         0                            => [ 1996 11 23 17 49 30 ]

[ 1996 11 22 17 49 30 ] 6         1                            => [ 1996 11 23 17 49 30 ]

[ 1996 11 22 17 49 30 ] 5         0                            => [ 1996 11 29 17 49 30 ]

[ 1996 11 22 17 49 30 ] 5         0                            => [ 1996 11 29 17 49 30 ]

[ 1996 11 22 17 49 30 ] 5         1                            => [ 1996 11 22 17 49 30 ]


[ 1996 11 22 17 49 30 ] 5         0 [ 18 30 ]                  => [ 1996 11 29 18 30 0 ]


[ 1996 11 22 17 49 30 ] 5         0 [ 18 30 45 ]               => [ 1996 11 29 18 30 45 ]

[ 1996 11 22 17 49 30 ] 5         1 [ 14 30 45 ]               => [ 1996 11 22 14 30 45 ]

[ 1996 11 22 17 49 30 ] 5         2 [ 14 30 45 ]               => [ 1996 11 29 14 30 45 ]


[ 1996 11 22 17 49 30 ] __undef__ 0 [ 18 __undef__ __undef__ ] => [ 1996 11 22 18 0 0 ]

[ 1996 11 22 17 49 33 ] __undef__ 0 [ 18 30 __undef__ ]        => [ 1996 11 22 18 30 0 ]

[ 1996 11 22 17 49 33 ] __undef__ 0 [ 18 30 45 ]               => [ 1996 11 22 18 30 45 ]

[ 1996 11 22 17 49 33 ] __undef__ 0 [ 18 __undef__ 45 ]        => [ 1996 11 22 18 0 45 ]


[ 1996 11 22 17 0 0 ]   __undef__ 0 [ 17 __undef__ __undef__ ] => [ 1996 11 23 17 0 0 ]

[ 1996 11 22 17 0 0 ]   __undef__ 1 [ 17 0 0 ]                 => [ 1996 11 22 17 0 0 ]

[ 1996 11 22 17 49 0 ]  __undef__ 0 [ 17 49 0 ]                => [ 1996 11 23 17 49 0 ]

[ 1996 11 22 17 49 0 ]  __undef__ 1 [ 17 49 0 ]                => [ 1996 11 22 17 49 0 ]

[ 1996 11 22 17 49 33 ] __undef__ 0 [ 17 49 33 ]               => [ 1996 11 23 17 49 33 ]

[ 1996 11 22 17 49 33 ] __undef__ 1 [ 17 49 33 ]               => [ 1996 11 22 17 49 33 ]

[ 1996 11 22 17 0 33 ]  __undef__ 0 [ 17 __undef__ 33 ]        => [ 1996 11 23 17 0 33 ]

[ 1996 11 22 17 0 33 ]  __undef__ 1 [ 17 __undef__ 33 ]        => [ 1996 11 22 17 0 33 ]

[ 1996 11 22 17 49 30 ] __undef__ 0 [ __undef__ 30 0 ]         => [ 1996 11 22 18 30 0 ]

[ 1996 11 22 17 49 30 ] __undef__ 0 [ __undef__ 30 45 ]        => [ 1996 11 22 18 30 45 ]

[ 1996 11 22 17 49 30 ] __undef__ 0 [ __undef__ __undef__ 30 ] => [ 1996 11 22 17 50 30 ]

[ 1996 11 22 17 30 0 ]  __undef__ 0 [ __undef__ 30 0 ]         => [ 1996 11 22 18 30 0 ]

[ 1996 11 22 17 30 0 ]  __undef__ 1 [ __undef__ 30 0 ]         => [ 1996 11 22 17 30 0 ]

[ 1996 11 22 17 30 45 ] __undef__ 0 [ __undef__ 30 45 ]        => [ 1996 11 22 18 30 45 ]

[ 1996 11 22 17 30 45 ] __undef__ 1 [ __undef__ 30 45 ]        => [ 1996 11 22 17 30 45 ]

[ 1996 11 22 17 30 45 ] __undef__ 0 [ __undef__ __undef__ 45 ] => [ 1996 11 22 17 31 45 ]

[ 1996 11 22 17 30 45 ] __undef__ 1 [ __undef__ __undef__ 45 ] => [ 1996 11 22 17 30 45 ]

[ 2002 11 22 18 15 0 ]  4         0                            => [ 2002 11 28 18 15 0 ]

[ 2002 11 22 18 15 0 ]  4         0 [ 12 30 ]                  => [ 2002 11 28 12 30 0 ]

[ 2002 11 22 18 15 0 ]  5         0                            => [ 2002 11 29 18 15 0 ]

[ 2002 11 22 18 15 0 ]  5         1                            => [ 2002 11 22 18 15 0 ]

[ 2002 11 22 18 15 0 ]  5         2                            => [ 2002 11 29 18 15 0 ]

[ 2002 11 22 18 15 0 ]  5         0 [ 12 30 ]                  => [ 2002 11 29 12 30 0 ]

[ 2002 11 22 18 15 0 ]  5         1 [ 12 30 ]                  => [ 2002 11 22 12 30 0 ]

[ 2002 11 22 18 15 0 ]  5         2 [ 12 30 ]                  => [ 2002 11 29 12 30 0 ]

[ 2002 11 22 18 15 0 ]  5         0 [ 19 30 ]                  => [ 2002 11 29 19 30 0 ]

[ 2002 11 22 18 15 0 ]  5         1 [ 19 30 ]                  => [ 2002 11 22 19 30 0 ]

[ 2002 11 22 18 15 0 ]  5         2 [ 19 30 ]                  => [ 2002 11 22 19 30 0 ]
";

$t->tests(func  => \&test,
          tests => $tests);
$t->done_testing();

#Local Variables:
#mode: cperl
#indent-tabs-mode: nil
#cperl-indent-level: 3
#cperl-continued-statement-offset: 2
#cperl-continued-brace-offset: 0
#cperl-brace-offset: 0
#cperl-brace-imaginary-offset: 0
#cperl-label-offset: 0
#End:
