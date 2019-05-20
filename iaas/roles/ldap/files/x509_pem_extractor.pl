#!/usr/bin/perl

use strict;
use warnings;
use POSIX;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "\nUsage: ./plx509_signature.pl path_to_idpsso_file.xml\n";
    exit;
}

my $filename = $ARGV[0];
open(my $fh, '<:encoding(UTF-8)', $filename)
    or die "Could not open file '$filename' $!";

my $result;

while (my $row = <$fh>) {
    chomp $row;
    #print $line, "\n";
    if($row =~ /<dsig:X509Certificate>(.*)<\/dsig:X509Certificate>/){
        $result = $1
    }
}
my $start = "-----BEGIN CERTIFICATE-----";
my $end = "-----END CERTIFICATE-----";
my $count = floor((length $result)/64);
for (my $i = 0; $i <= $count; $i++) {
    my $str = substr $result, ($i*64), 64;
    $start = $start . "\n" . $str 
}

$start = $start . "\n" . $end . "\n";
print $start;