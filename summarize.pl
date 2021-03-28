#!/bin/perl

while (<>) {
    chomp;
    open(FILE, '<', "$_") or die "couldn't open $_ $!";
    while (<FILE>) {
	(/Subject/ or /Received/ or /Date/) and print;
    }
    close(FILE);
}
