#!/usr/bin/ruby -w

# generates core.css, which defines the 'display' property for elements where
# it can guess the correct value

# To use this script, you need to have a copy of the source of 'Docbook, the
# Definative Guide', which you can obtain though CVS like this,
#
#   export CVS_RSH=ssh
#   cvs -z3 -d:pserver:anonymous@cvs.docbook.sourceforge.net:/cvsroot/docbook co defguide
#
# Put this script in the same place as the 'defguide' directory you just
# checked out and run it,
#
#   ./makecss.rb
#
#
# If you make a file called 'extra-block-elements.txt' the script will read
# one element name per line from it, and include these in the list of elements
# marked { display:block; }
#
#							-- David Holroyd


# apt-get install librexml-ruby
require "rexml/document"

require 'date'

$refpath = "defguide/en/refpages/elements"

$block_elements = Array.new
$inline_elements = Array.new
$suppressed_elements = Array.new
$inherit_elements = Array.new
$linespecific_formatted_elements = Array.new
$undefined_elements = Array.new

$all_elements = Hash.new


class ListenerDecorator
  attr_accessor :parent, :listener

  def bind() end

  def unbind() end

  def tag_start(name, attrs) nil end

  def tag_end(name) false end

  def text(text) false end

  def instruction(target, attrs) false end

  def comment(text) false end

  def cdata(text) false end
end

class ExpectationDecorator < ListenerDecorator
  def bind()
    @expectation_text = ""
  end

  def unbind()
    @listener.formatting_expectation += @expectation_text
  end

  def tag_start(name, attrs)
    case name
      when "quote"
        @expectation_text += "'"
      when "sgmltag"
        @expectation_text += "<"
    end
    nil
  end

  def tag_end(name)
    case name
      when "quote"
        @expectation_text += "'"
      when "sgmltag"
        @expectation_text += ">"
    end
    false
  end

  def text(text)
    @expectation_text += text
    true
  end
end

class TitleDecorator < ListenerDecorator
  def text(text)
    if text =~ /Processing expectations/
      parent.processing_expectation = true
    end
    true
  end
end


class Refsect2Decorator < ListenerDecorator
  def bind
    @processing_expectation=false
  end

  attr_accessor :processing_expectation

  def tag_start(name, attrs)
    if name=="title"
      TitleDecorator.new
    elsif name=="para" && @processing_expectation
      ExpectationDecorator.new
    else
      nil
    end
  end
end

class BaseDecorator < ListenerDecorator
  def tag_start(name, attrs)
    if name=="refentry"
      listener.revision = attrs["revision"]
    end
    if name=="refsect2"
      Refsect2Decorator.new
    else
      nil
    end
  end
end


# This listens to parse events coming from ReXML and delegates them off to
# a 'decorator' object.  When a decorator sees a start tag, it may choose to
# push a new decorator object onto the listener's stack (it will pop off again
# when the corresponding close-tag is encountered)
# 
class MyListener
  def initialize
    @stack = Array.new
    @decorator_stack = Array.new
    base_decorator = BaseDecorator.new
    base_decorator.listener = self
    @decorator_stack << base_decorator
    @formatting_expectation = ""
    @revision = nil
  end

  attr_accessor :formatting_expectation, :revision

  def tag_start(name, attrs)
    @stack << name
    decorator = get_decorator.tag_start(name, attrs)
    unless decorator.nil?
      decorator.parent = get_decorator
      decorator.listener = self
      decorator.bind()
    end
    @decorator_stack << decorator
  end

  def tag_end(name)
    decorator = @decorator_stack.pop
    decorator.unbind() unless decorator.nil?
    top = @stack.pop
    raise "found </#{name}>, expecting </#{top}>" unless top==name
    decorate() do |decorator|
      return if decorator.tag_end(name)
    end
  end

  def text(text)
    decorate() do |decorator|
      return if decorator.text(text)
    end
  end

  def instruction(target, attrs)
    decorate() do |decorator|
      return if decorator.instruction(target, attrs)
    end
  end

  def comment(text)
    decorate() do |decorator|
      return if decorator.comment(text)
    end
  end

  def cdata(text)
    decorate() do |decorator|
      return if decorator.cdata(text)
    end
  end

 protected
  def decorate()
    @decorator_stack.reverse_each do |decorator|
      yield decorator unless decorator.nil?
    end
  end

  def get_decorator
    @decorator_stack.reverse_each do |decorator|
      return decorator unless decorator.nil?
    end
    return nil
  end
end

def get_formatting_expectation(ref_file)
  listener = MyListener.new
  file = File.new(ref_file)
  doc = REXML::Document.parse_stream(file, listener)
  return listener
end


# Looks at the XML entities in the given text to determine how to format
# some element.  Also, ASCIfies some character-entities to make aux.css
# comments look purty
# 
def define_formatting(tag, listener)
  return if listener.revision == "EBNF"
  
  options = Array.new
  expectations = listener.formatting_expectation
  if expectations.nil?
    expectations = ""
  else
    expectations.gsub!(/&([^;]+);/) do |match|
      case $1
        when "format.block"
	  options << "block"
	  ""
	when "format.inline"
	  options << "inline"
	  ""
	when "format.context"
	  options << "context"
	  ""
	when "format.suppress"
	  options << "suppress"
	  ""
	when "format.csuppress"
	  options << "csuppress"
	  "Sometimes suppressed."
	when "pexp.linespecific"
	  options << "linespecific"
	  ""
	when "calssemantics"
	  options << "calssemantics"
	  ""
	when "pexp.moreinfo"
	  "The MoreInfo attribute can help generate a link or query to retrieve additional information."
	when "UNIX"
	  "UN*X"
	when "DTD"
	  "DTD"
	when "HTML"
	  "HTML"
	when "XML"
	  "XML"
	when "SGML"
	  "SGML"
	when "CALS"
	  "CALS"
	when "ldquo", "rdquo"
	  "\""
	when "lsquo", "rsquo"
	  "'"
	when "laquo"
	  "<<"
	when "raquo"
	  ">>"
	when "nbsp"
	  " "
	when "copy"
	  "(c)"
	when "hellip"
	  "..."
	when "amp"
	  "&"
	when "lt"
	  "<"
	when "gt"
	  ">"
	else
	  raise "don't know about entity #{match} in processing expectations for <#{tag}>"
      end
    end
    expectations.sub!(/^\s+/, "")
    expectations.sub!(/\s+$/, "")
  end
  if options.include?("inline") && options.include?("block")
    raise "<#{tag}> has inline and block"
  elsif options.include?("inline")
    $inline_elements << tag
  elsif options.include?("block")
    $block_elements << tag
  elsif options.include?("suppress")
    $suppressed_elements << tag
#  elsif options == ["context"]
#    $context_dependant_elements << tag
  elsif options.include?("linespecific")
    $linespecific_formatted_elements << tag
  else
    $undefined_elements << tag
#    puts "<#{tag}> : "+options.join(", ")
  end
  $all_elements[tag] = expectations
end

unless FileTest.directory?($refpath)
  raise "no dir '#{$refpath}'"
end


Dir.foreach($refpath) do |dir|
  next if dir =~ /^\./ || dir == 'CVS'
  ref = "#{$refpath}/#{dir}/refentry.xml"
  if FileTest.exists?(ref)
    listener = get_formatting_expectation(ref)
    define_formatting(dir.sub(/-/, ":"), listener)
  else
    $stderr.puts("no refentry.xml in #{dir}");
  end
end

def make_rule_for_all(io, elements, rule)
  line = ""
  elements.sort!
  last = elements.pop

  elements.each do |tag|
    if block_given?
      tag = yield tag
    end
    if line.size > 0 #(line.size + tag.size + 2) > 79
      io.puts line
      line = ""
    end
    line += tag + ","
  end
  if block_given?
    last = yield last
  end
  if (line.size + last.size + 2) > 79
    io.puts line
    line = ""
  end
  io.puts line + "\n" + last + " {"
  io.puts "	#{rule}"
  io.puts "}"
end

# load any supplementry info

if FileTest.exists?("extra-block-elements.txt")
  File.open("extra-block-elements.txt") do |io|
    io.each_line do |element|
      element.strip!
      if $block_elements.include?(element) || $inline_elements.include?(element) || $suppressed_elements.include?(element)
        raise "<#{element}> already has a display type"
      end
      $block_elements << element
      $undefined_elements.delete(element)
    end
  end
end
if FileTest.exists?("extra-suppressed-elements.txt")
  File.open("extra-suppressed-elements.txt") do |io|
    io.each_line do |element|
      element.strip!
      if $block_elements.include?(element) || $inline_elements.include?(element) || $suppressed_elements.include?(element)
        raise "<#{element}> already has a display type"
      end
      $suppressed_elements << element
      $undefined_elements.delete(element)
    end
  end
end
if FileTest.exists?("extra-inline-elements.txt")
  File.open("extra-inline-elements.txt") do |io|
    io.each_line do |element|
      element.strip!
      if $block_elements.include?(element) || $inline_elements.include?(element) || $suppressed_elements.include?(element)
        raise "<#{element}> already has a display type"
      end
      $inline_elements << element
      $undefined_elements.delete(element)
    end
  end
end
if FileTest.exists?("extra-inherit-elements.txt")
  File.open("extra-inherit-elements.txt") do |io|
    io.each_line do |element|
      element.strip!
      if $block_elements.include?(element) || $inline_elements.include?(element) || $suppressed_elements.include?(element)
        raise "<#{element}> already has a display type"
      end
      $inherit_elements << element
      $undefined_elements.delete(element)
    end
  end
end
if FileTest.exists?("table-elements.txt")
  # we don't auto-generate CSS for these; just don't report problems with them
  File.open("table-elements.txt") do |io|
    io.each_line do |element|
      element.strip!
      if $block_elements.include?(element) || $inline_elements.include?(element) || $suppressed_elements.include?(element)
        raise "<#{element}> already has a display type"
      end
      $undefined_elements.delete(element)
    end
  end
end


File.open("core.css", File::CREAT|File::WRONLY|File::TRUNC) do |io|
  io.puts("/* Generated #{Date.today} */")
  make_rule_for_all(io, $inline_elements, "display: inline;")
  io.puts
  make_rule_for_all(io, $block_elements, "display: block;")
  io.puts
  make_rule_for_all(io, $suppressed_elements, "display: none;")
  io.puts
  make_rule_for_all(io, $inherit_elements, "display: inherit;")
  io.puts
  make_rule_for_all(io, $linespecific_formatted_elements, "white-space: pre;\n\tfont-family: monospace;\n\tdisplay: block;")
end


# not sure what this will be good for -- room for future expansion
#
File.open("aux.css", File::CREAT|File::WRONLY|File::TRUNC) do |io|
  $all_elements.each do |key, val|
    unless val==""
      io.puts "/*"
      io.puts val
      io.puts "*/"
    end
    io.puts "#{key} {"
    io.puts "}"
    io.puts
  end
end

unless $undefined_elements.empty?
  puts "These elements have no display-type defined:"
  print "  "
  len = 2
  $undefined_elements.each do |el|
    if len + (el.size + 2) >=79
      puts
      print "  "
      len=2
    end
    print el
    print ", "
    len += (el.size + 2)
  end
end
puts
