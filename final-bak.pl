#!/usr/bin/perl
##########################
#
# hw5.pl
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

# S. Ganci * UNC-CH Ling 422 * 2018 Sept 10
#
##########################
use warnings; 
use utf8;
use strict;
my $wordform_ID;
my $orthography;
my $lemma_frequency;
my $lemma_ID;
my $num_alt_prons;
my $pron_status;
my $transcription_A;
my $cv_skeleton;
my $transcription_B;

my $in= "p*n";
my @min_pair;
my $line;

# idea:
# based on number of pronuncations loop and add each trans b to the desired list
# then for each prons in list check for match
# while(<>){
#     my %line= processLine($_);
     
#     #for the length of all the trans bs
#     # for (my $i=0; $i < $line{'num_alt_prons'} $i++) {
#     #     my $temp= $line{'trans_b'}[$i];
#     #     if(syll_count($temp==1)&&)
#     # }
#     # if(syll_count(%line{''}))

#     # ($wordform_ID, $orthography, $lemma_frequency, $lemma_ID, $num_alt_prons, $pron_status, $transcription_A, $cv_skeleton, $transcription_B)
#     # ($orthography, $lemma_frequency, $transcription_A, $cv_skeleton)= (split /\\/, $_)[1,2,6,7];
# #    ($num_alt_prons)= (split /\\/, $_)[4];
# #     if($num_alt_prons >2){
# #        print $_;
# #     }

# #     # if(/$in/){

# #     #     push(@min_pair, $_);
# #     #     print $_;
# #     # }
# }

##each line has at least 9 items, extra's mult by 3

# name: processLine
# in: takes in a line of text from celex
# out: a hash containing interval, xmin, xmax, and text values
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
    for (my $i=6; $i < @features; $i=$i+3) {
        push @{$line_hash{'trans_a'}}, $features[$i]; 
        print "$i\n";
        push @{$line_hash{'cv_skeleton'}}, $features[$i+1]; 
        push @{$line_hash{'trans_b'}}, $features[8+ $i+2]; 
        #   $line_hash{'trans_a'}= $features[6+ $i];
        #   $line_hash{'cv_skeleton'}= $features[7+ $i];
        #   $line_hash{'trans_b'}= $features[8+$i];
        #   push @{$prons{$trans}}, $orth;
    }
    %line_hash;
}

while(<>){
    print "NEW WORD \n";
    my  %line= processLine($_);
    
    foreach my $key (sort keys %line){
       print "$key => $line{$key} \n"; 
    }
    # while((my $key, my $val)=each %line){
    #     print "$key => $val \n";
    # }

    foreach my $trans (sort @{$line{'trans_a'}}){
        print "trans_a: $trans \n"
    }

    foreach my $cv (sort @{$line{'cv_skeleton'}}){
        print("cv: $cv\n")
    }

    foreach my $trans (sort @{$line{'trans_b'}}){
        print "trans_b: $trans \n"
    }
    # for (my $i=0; $i < $line{'num_alt_prons'}; $i++) {
    #     my $tran_a= @{$line{'trans_a'}}[$i];
    # }

    # print "wordform_id: $line_hash{'wordform_id'} \n";
    # print "orth: $line_hash{'orthography'}\n";

    # print $line_hash{'lemma_frequency'};
    # print $line_hash{'lemma_id'};
    # print $line_hash{'num_alt_prons'};
    # print $line_hash{'pron_status'};
}



sub syll_count {
    my $transb= $_[0];
    my @syl= split /]/, $transb;

}
