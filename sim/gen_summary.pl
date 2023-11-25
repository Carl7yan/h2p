#!/bin/perl

my @logfiles = `find ../sim/LOG -name "*.log"`;
my $logcount = $#logfiles+1;
if ( $logcount==0 ) {
  die "Cannot find VCS log files, report cannot be generated!\n";
}
my $pass_total, $fail_total, $other_total, $test_total = 0;
my @results_array;

foreach (@logfiles) {
  my $pass = `egrep \"Pkt comparing correct!\" $_`;
  my $fail = `egrep \"Pkt comparing FAILED!\" $_`;
  my $test_seed;
  if($pass){
    $pass_total++;
  } elsif ($fail){
    $fail_total++;
  } else {
    $other_total++;
  }
  $test_total++;
}

my $pass_percent  = ($pass_total/$test_total)*100;
my $fail_percent  = ($fail_total/$test_total)*100;
my $other_percent = ($other_total/$test_total)*100;

printf ("\n");
printf ("===============================================================================\n");
printf ("                             REGRESSION SUMMARY\n");
printf ("===============================================================================\n");
printf ("      TESTCASES THAT PASSED         :  %d [%d\%]\n", $pass_total, $pass_percent);
printf ("      TESTCASES THAT FAILED         :  %d [%d\%]\n", $fail_total, $fail_percent);
printf ("      TESTCASES WITH UNKNOWN STATUS :  %d [%d\%]\n", $other_total, $other_percent);
printf ("      TOTAL NUMBER OF TESTCASES     :  %d\n", $test_total);
printf ("===============================================================================\n");
printf ("\n");
foreach (@results_array) {
  print ($_);
}
printf ("\n");
printf ("===============================================================================\n");
printf ("\n");
