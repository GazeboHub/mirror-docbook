Building with ant
-----------------

Create English Output
~~~~~~~~~~~~~~~~~~~~~

HTML::
  ant html.en

PDF::
  ant pdf.en


Create Simplified Chinese Output
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create or Update PO Template file::
  ant pot

Translate by zh_CN.po::
  ant translate

Create HTML Output::
  ant html

Create PDF Output::
  ant pdf


Building with make
------------------

Setup entironment
~~~~~~~~~~~~~~~~~
  export DOCBOOK_SVN=/home/cauchy/wc/svn/docbook

  export CLASSPATH=/home/cauchy/wc/svn/i18n-zh/trunk/lib/docbook
  export JARDIR=/home/cauchy/pool
  export CLASSPATH=$CLASSPATH:$JARDIR/xml-commons-resolver-1.2.jar
  export CLASSPATH=$CLASSPATH:$JARDIR/resolver.jar
  export CLASSPATH=$CLASSPATH:$JARDIR/xml-apis.jar
  export CLASSPATH=$CLASSPATH:$JARDIR/xercesImpl.jar
  export CLASSPATH=$CLASSPATH:$JARDIR/saxon.jar
  export CLASSPATH=$CLASSPATH:$JARDIR/saxon8.jar

Create ~/.xmlrc
~~~~~~~~~~~~~~~
--------------------------------------
<?xml version='1.0' encoding='utf-8'?>
<config>
  <java classpath-separator=":" xml:id="java">
    <system-property name="javax.xml.parsers.DocumentBuilderFactory"
      value="org.apache.xerces.jaxp.DocumentBuilderFactoryImpl"/>
    <system-property name="javax.xml.parsers.SAXParserFactory"
      value="org.apache.xerces.jaxp.SAXParserFactoryImpl"/>
    <classpath path="/home/cauchy/pool/resolver.jar"/>
    <classpath path="/home/cauchy/pool/xercesImpl.jar"/>
  </java>

  <java xml:id="bigmem">
    <java-option name="Xmx512m"/>
  </java>

  <saxon xml:id="saxon" extends="java">
    <classpath path="/home/cauchy/pool/resolver.jar"/>
    <arg name="x" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
    <arg name="y" value="org.apache.xml.resolver.tools.ResolvingXMLReader"/>
    <arg name="r" value="org.apache.xml.resolver.tools.CatalogResolver"/>
    <param name="use.extensions" value="1"/>
  </saxon>

  <saxon xml:id="saxon-6" extends="saxon" class="com.icl.saxon.StyleSheet">
    <classpath path="/home/cauchy/pool/saxon.jar"/>
    <classpath path="/home/cauchy/pool/saxon-dbxsl-extensions.jar"/>
  </saxon>

  <saxon xml:id="saxon-8a" extends="saxon" class="net.sf.saxon.Transform">
    <classpath path="/home/cauchy/pool/saxon8.jar"/>
  </saxon>
</config>
--------------------------------------
