<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <meta name="date" content="$Date: 2005/11/19 05:06:38 $"/>
    <meta name="version" content="$Revision: 1.5 $"/>
    <meta name="source" content="$Source: /cvsroot/docbook/sourceforge-webpages/index.html,v $"/>
    <link href="style.css" media="all" rel="Stylesheet" type="text/css"/>
    <!-- * the Prototype and Rico libraries are needed for -->
    <!-- * enabling the "accordian menu" behavior. -->
    <script src="lib/prototype.js" type="text/javascript"></script>
    <script src="lib/rico.js" type="text/javascript"></script>

    <title>The DocBook Project</title>
  </head>

  <!-- * The following "onload" and Javascript code are needed for -->
  <!-- * enabling the "accordian menu" behavior. -->
  <body onload="javascript:bodyOnLoad()">
    <script type="text/javascript">
      <!--
          var onloads = new Array();
          function bodyOnLoad() {
          for ( var i = 0 ; i < onloads.length ; i++ )
          onloads[i]();
          }
      -->
    </script>

          <p align="center"><a
            href="text.php"
            style="
            font-weight: normal;"
            >text-only version</a></p>

    <?php include("body-content.html") ?>

    <script type="text/javascript">
      onloads.push( accord );
      function accord() { new Rico.Accordion( 'accordionMenu', {panelHeight:200} ); }
    </script>
  </body>
</html>
