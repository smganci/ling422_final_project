#!/usr/bin/perl
################################################################################
#
# Name: pair_match
#
# Purpose:
#
# Usage:
#   to run this program you must have an EPW.CD file in the same folder
#
#
# S. Ganci K. K. Elhajoui * UNC-CH Ling 422 * 2018 Dec 98
#
################################################################################
use warnings;
use utf8;
use strict;



# Open the EPW.CD file
my $file;
open $file, '<',"EPW.CD" or die "can't find file named EPW.CD\n";

# $cons stores all consonents for futer use
# Note: to avoid redundancy, does not include nasal consonants
my $cons = "pbfvwfvTDtdszlSZrjkgh*\'";

# %mp_hash will store a hash:
#   keys: onset_coda of monosyllable word
#   value: an array of all of the words containing [IE] with that onset & coda
# Note: coda can only be nasal
my %mp_hash;

# %cons_hash will store a hash:
#   keys: onset_coda of monosyllable word
#   value: an array of all of the words containing [IE] with that onset & coda
# Note: coda can only be non nasal
my %cons_hash;

# Loop through entire file
while(<$file>){

    my $var = $_;
    chomp $var;

    # Call processLine to generate a feature hash
    my  %line= processLine($var);

    # Check to see if monosyllable
    if(syll_count($line{'cv_skeleton'})==1){

        # Check match for mp_hash
        if($line{'trans_b'}=~/\[(([$cons]*)[IE]:?([nmN][$cons]*?))\]/){

            # Check if key is already in hash
            if(exists $mp_hash{"$2\_$3"}){

                # Check the length of array in hash
                my $len= @{$mp_hash{"$2\_$3"}};
                if($len == 1){

                    # Check to see if item has already been entered
                    my $temp= @{$mp_hash{"$2\_$3"}}[$len-1];
                    if($temp ne $1){
                        push @{$mp_hash{"$2\_$3"}}, $1;
                    }
                }

            }else{
                # Push entry on list for key
                push @{$mp_hash{"$2\_$3"}}, $1;
            }

        }

        # Check match for cons_hash
        if($line{'trans_b'}=~/\[(([$cons]*)[IE]:?([$cons*]))\]/){

            # Check if key is already in hash
            if(exists $cons_hash{"$2\_$3"}){

                # Check the length of array in hash
                my $len= @{$cons_hash{"$2\_$3"}};
                if($len == 1){
                    my $temp= @{$cons_hash{"$2\_$3"}}[$len-1];

                    # Check to see if item has already been entered
                    if($temp ne $1){
                        push @{$cons_hash{"$2\_$3"}}, $1;
                    }
                }

            }else{
                # Push entry on list for key
                push @{$cons_hash{"$2\_$3"}}, $1;
            }
        }
    }
}


# For every key in mp_hash
my $count=1;
foreach my $key (sort keys %mp_hash){

    # Check to see if there is more than one item in the array
    my $len=@{$mp_hash{$key}};
    if(($len>1)){

        # Store onset for future comparison
        my $ons;
        if($key=~/(.*_)/){
            $ons=$1;
        }


        my $out="";

        # For every key in cons hash
        foreach my $key2 (sort keys %cons_hash){
            my $len2=@{$cons_hash{$key2}};

            # Check if length is more than one
            if($len2>1){

                # Check to see if onset matches key
                if($key2=~"^$ons" && $key ne $key2){
                    # Add to output
                    $out.="--------------------\n";
                    $out.= join ",\t", sort @{$cons_hash{$key2}};
                    $out.="\n"

                }
            }
        }

        # If there are matches to the nasal pair (len(out)>0) then print
        if(length($out)>0){
            print("$count.\n");
            print("~~~~ Nasal Pair ~~~~\n--------------------\n");
            print join ",\t", sort @{$mp_hash{$key}};
            print "\n\n";
            print"~~~~~~ Matches ~~~~~\n";
            print $out;
            print "\n\n\n";
            $count++;
        }

    }
}


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

# name: syll_count
# in: takes the cv feature of a celex row
# out: the number of syllables in that word
sub syll_count {
    my $syll= $_[0];
    my @syll= split /]/, $syll;
    my $count= @syll;
    $count;
}
