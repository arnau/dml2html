#!/usr/bin/env ruby

LOGFILE = "generator.log"
@xsl = "../dml2html.xsl"

@input = "../temp/example.xml"
@output = "../temp/example.html"

begin
  system "java -jar /Library/Java/Extensions/saxon91005/saxon9.jar -dtd:off -versionmsg:off -s:#{@input} -xsl:#{@xsl} -o:#{@output} 2>> #{LOGFILE}"
  
rescue => err
  puts "Exception: #{err}"
  err
end