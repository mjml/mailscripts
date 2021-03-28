#!/bin/perl

while (<>) {
    /(\S*\.)?([^\.]+\.[a-zA-Z]\S*)/ and print "$2\n"
}
