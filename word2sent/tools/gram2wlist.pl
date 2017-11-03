#! /usr/bin/env perl
#
# gram2wlist.pl < input.grm > output.lst
# or
# gram2wlist.pl input.grm [input2.grm...] > output.lst
#
# Extract a list of terminal symbols from KTH grammar definition file
#
# (C) 2012, Giampiero Salvi <giampi@kth.se>
 
use List::MoreUtils qw/ uniq /;

$out = "";

while (<>) {    # for every line in the input file (or stdin)
    $out .= $_; # append line to out
}

# convert language definition characters into new lines
$out =~ s/[\[\]\{\}| =;()]/\n/g;
# remove empty lines
$out =~ s/\n\n+/\n/g;
# remove non-terminal symbols (starting with "$")
$out =~ s/\$.*\n//g;
# sort and uniq
$out = join("\n", uniq(sort(split("\n", $out))));
# print to stdout
print $out, "\n";
