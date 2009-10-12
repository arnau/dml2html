#!/usr/bin/env perl -w

use strict;
{
  my $xsl = "../dml2html.xsl";
  my $input = "../temp/example.xml";
  my $output = "../temp/example.html";
  my $params = "";
  # $params .= "debug=false";
  # $params .= " toc.skipped.sections=0";
  # $params .= " status.hidden.values='xxx yyy zzz'";
  `java net.sf.saxon.Transform -dtd:off -versionmsg:off -s:$input -xsl:$xsl -o:$output $params`;
}