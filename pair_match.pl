#!/usr/bin/perl
##########################
#
# hw5.pl
#
# This program should:
# 	filter down to monosyllables
#   determine missing sound
#   input could first be specifically monosyllables with
# min pairs by first and last letter with only i and e
# have a hash of first and last letter
# hash from first and last to list of words
# remove duplicates from the list
# only output the hash lists with more than one

# S. Ganci * UNC-CH Ling 422 * 2018 Sept 10
#
##########################
use warnings; 
use utf8;
use strict;

my $file_arg;
($file_arg)=$ARGV[0];

my $file;
open $file, '<',"$file_arg" or die "can't find file named $file_arg\n";

my @min_pairs;
my %mp_hash;
my %cons_hash;
while(<$file>){
 
    my $var = $_;
    chomp $var;
    my  %line= processLine($var);
    
    
##consonant clusters
# another if
##idea: could store hash of every first letter
#add in some sort of class to account for the clusters igrnor other vowels
#add more than just mono syllables
#maybe gives actual word
    if(syll_count($line{'cv_skeleton'})==1){
        # my $_=$line{'trans_b'}
        #change to trans]
        # print $line{'trans_b'};
        if($line{'trans_b'}=~/\[((.*)[IE]:?([nm]))\]/){
            # print $1;
            if(exists $mp_hash{"$2\_$3"}){
                my $len= @{$mp_hash{"$2\_$3"}};
                if($len == 1){
                    my $temp= @{$mp_hash{"$2\_$3"}}[$len-1];
                    if($temp ne $1){
                        push @{$mp_hash{"$2\_$3"}}, $1; 
                    }
                }
               
            }else{
                push @{$mp_hash{"$2\_$3"}}, $1; 
            }
            
          # push @min_pairs, $1;
        }

         if($line{'trans_b'}=~/\[((.*)[IE]:?(.*))\]/){
            # print $1;
            if(exists $cons_hash{"$2\_$3"}){
                my $len= @{$cons_hash{"$2\_$3"}};
                if($len == 1){
                    my $temp= @{$cons_hash{"$2\_$3"}}[$len-1];
                    if($temp ne $1){
                        push @{$cons_hash{"$2\_$3"}}, $1; 
                    }
                }
               
            }else{
                push @{$cons_hash{"$2\_$3"}}, $1; 
            }
            
          # push @min_pairs, $1;
        }
    }


}

foreach my $key (sort keys %mp_hash){
    my $len=@{$mp_hash{$key}};
    if($len>1){
        print join ",\t", sort @{$mp_hash{$key}};
        print "\n";
    }
    
}

print "cons hash below\n";

foreach my $key (sort keys %cons_hash){
    my $len=@{$cons_hash{$key}};
    if($len>1){
        print join ",\t", sort @{$cons_hash{$key}};
        print "\n";
    }
    
}




# @min_pairs = sort { $-a cmp $b} @min_pairs;
# @min_pairs= remove_duplicates(@min_pairs);

# print join "\n", @min_pairs;

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
