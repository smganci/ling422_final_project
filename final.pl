#!/usr/bin/perl
##########################
#
#
# This program should:
# 	filter down to monosyllables
#   determine missing sound
#   input could first be specifically monosyllables with
# goal 1:
# make it filter just monosyllables with I or e
# sort by pronunciation like rhyming dictionary

# goal 2:
# make software take input of two sounds and a *
# TODO: modify script to select min pairs for both I and E
#maybe group by 1st letter and sort by last?

# S. Ganci * UNC-CH Ling 422 * 2018 Sept 10
#
##########################
use warnings;
use utf8;
use strict;
#use List::MoreUtils qw(uniq);

my $search;
my $file_arg;
($file_arg, $search)=@ARGV[0,1];

my $file;
open $file, '<',"$file_arg" or die "can't find file named $file_arg\n";

my @min_pairs;
while(<$file>){
    # chomp;
    # print "NEW WORD \n";
    my $var = $_;
    chomp $var;
    my  %line= processLine($var);

    # foreach my $key (sort keys %line){
    #    print "$key => $line{$key} \n";
    # }

    if(syll_count($line{'cv_skeleton'})==1){
        if(/\[($search)\]/){
           push @min_pairs, $1;
        }
    }


}


@min_pairs = sort { $a cmp $b} @min_pairs;
@min_pairs= remove_duplicates(@min_pairs);

print join "\n", @min_pairs;

###############################################
##Subroutines
###############################################

# name: processLine
# in: takes in a line of text from celex
# out: a hash containing diff features
sub processLine {
    my $line= $_[0];
    my @features=split /\\/,$line;
    my %line_hash;
    $line_hash{'wordform_id'}= $features[0];
    $line_hash{'orthography'}= $features[1];
    $line_hash{'lemma_frequency'}= $features[2];
    $line_hash{'lemma_id'}= $features[3];
    $line_hash{'num_alt_prons'}= $features[4];
    $line_hash{'pron_status'}= $features[5];
    $line_hash{'trans_a'}= $features[6];
    $line_hash{'cv_skeleton'}= $features[7];
    $line_hash{'trans_b'}= $features[8];
    %line_hash;
}

# name: remove_duplicates
# in: takes in an array
# out: the same array with duplicates removed
sub remove_duplicates {
    my @original= @_;
    my @out;
    foreach my $elt (@original){
        if(@out==0){
            push @out, $elt;
        }else{
            #pop and check if new word is in the sorted list already
            my $temp= pop @out;
            if( $elt eq $temp){
                push @out, $temp;
            }else{
                push @out, $temp;
                push @out, $elt;
            }
        }
    }
    @out;
}

# name: processLine
# in: takes the cv feature of a celex row
# out: the number of syllables in that word
sub syll_count {
    my $syll= $_[0];
    my @syll= split /]/, $syll;
    my $count= @syll;
    $count;
}
