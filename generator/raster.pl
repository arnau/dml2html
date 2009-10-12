#!/usr/bin/env perl -w

use strict;

my $batik_path = "/Library/Java/Extensions/batik-1.7";

my $base_path = "../temp/figures/";
my @source = qw(
  ../temp/figures/*.svg
  ../temp/figures/ca/*.svg
  );
my $output_path_base = "png/";

foreach (@source) {
  (my $output_path = $_) =~ s/($base_path)(.*)[^\/]+\.svg/$1$output_path_base$2/;
  print `java -Dapple.awt.graphics.UseQuartz=false -jar $batik_path/batik-rasterizer.jar -w 800 -dpi 72 -bg 255.255.255.255 -d $output_path -m image/png $_`;
}
