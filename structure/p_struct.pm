#! /usr/bin/perl

package p_struct;

use strict;
use warnings;
use 5.10.0;
use DDP;

sub p_struct($);

sub p_struct($) 
{
	my $struct = shift;
	my $array_or_hash;
	my %ref_ex = ( 	HASH => sub {my @temp; while ((my $key, my $value ) = each(%{$_[0]})) 
				    {push @temp, [$key, $value];}; @temp;},
			ARRAY => sub {my @temp; while ((my $key, my $value ) = each(@{$_[0]}))
				     {push @temp, [$key, $value];}; @temp;});
 
	return $struct if (!ref($struct));
	return undef if (ref($struct) eq "CODE");

 	if (ref($struct) eq "ARRAY") {
		$array_or_hash = [];
	}
	else {
		$array_or_hash = {};
	}
		
	my @struct_values = $ref_ex{ref($struct)}($struct);
	for my $t_value (@struct_values) {
		if (ref($t_value->[1])) {
			if (ref($struct) eq "HASH") {
				$$array_or_hash{$t_value->[0]} = p_struct($t_value->[1]);
			}
			elsif (ref($struct) eq "ARRAY") {
				$$array_or_hash[$t_value->[0]] = p_struct($t_value->[1]);
			}
		}
		else {
			if (ref($struct) eq "HASH") {
				$$array_or_hash{$t_value->[0]} = $t_value->[1];
			}
			elsif (ref($struct) eq "ARRAY") {
				$$array_or_hash[$t_value->[0]] = $t_value->[1];
			}
		}
	}

	return $array_or_hash;
}
1;	
