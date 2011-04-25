<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <style type="text/css">html,body{background:#ffc;font-family:helvetica,arial,sans-serif;font-size:0.8em}caption,thead{background:#700;color:#fff}caption,thead th{margin:0;padding:2px}a{color:#a00}a:hover{color:#aaa}.tr1{background:#ffd}.tr2{background:#ffb}tr{vertical-align:top}</style>
        <title>ProServer: Entry Points for <xsl:value-of select="/DASEP/ENTRY_POINTS/@href"/></title></head>
      <body>
        <div id="header"><h4>ProServer: Entry Points for <xsl:value-of select="/DASEP/ENTRY_POINTS/@href"/></h4></div>
        <div id="mainbody">
          <p>Format:
            <input type="radio" name="format" onclick="document.getElementById('table').style.display='block';document.getElementById('xml').style.display='none';" value="Table" checked="checked"/>Table
            <input type="radio" name="format" onclick="document.getElementById('xml').style.display='block';document.getElementById('table').style.display='none';" value="XML"/>XML
          </p>
          <div id="table" style="display:block;">
            <xsl:apply-templates select="/DASEP/ENTRY_POINTS" mode="table"/>
          </div>
          <div id="xml" style="font-family:courier;display:none;">
            <xsl:apply-templates select="*" mode="xml-main"/>
          </div>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="ENTRY_POINTS" mode="table">

    <table class="z" id="data_all">
      <caption>
        Entry Points
        <xsl:value-of select="@start" />
        to
        <xsl:value-of select="@end" />
        of <xsl:value-of select="@total" />
      </caption>

      <thead>
        <tr>
          <th>Segment ID</th>
          <th>Segment Label</th>
          <th>Start</th>
          <th>Stop</th>
          <th>Orientation</th>
          <th>Has Subparts?</th>
        </tr>
      </thead>
      <tbody>
    <xsl:for-each select="SEGMENT">
      <xsl:sort select="@id"/>
      <tr>
        <td><xsl:value-of select="@id"/></td>
        <td><xsl:value-of select="."/></td>
        <td><xsl:value-of select="@start"/></td>
        <td><xsl:value-of select="@stop"/></td>
        <td style="text-align: center">
          <xsl:choose>
            <xsl:when test="@orientation"><xsl:value-of select="@orientation"/></xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </td>
        <td style="text-align: center">
          <xsl:choose>
            <xsl:when test="@subparts"><xsl:value-of select="@subparts"/></xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </xsl:for-each>
    </tbody>
    </table>
  </xsl:template>
  
  <xsl:template match="@*" mode="xml-att">
    <span style="color:purple"><xsl:text>&#160;</xsl:text><xsl:value-of select="name()"/>=&quot;</span><span style="color:red"><xsl:value-of select="."/></span><span style="color:purple">&quot;</span>
  </xsl:template>
  
  <xsl:template match="*" mode="xml-main">
    <xsl:choose>
      <xsl:when test="*">
        <span style="color:blue">&lt;<xsl:value-of select="name()"/></span><xsl:apply-templates select="@*" mode="xml-att"/><span style="color:blue">&gt;</span>
        <div style="margin-left: 1em"><xsl:apply-templates select="*" mode="xml-main"/></div>
        <span style="color:blue">&lt;/<xsl:value-of select="name()"/>&gt;</span><br/>
      </xsl:when>
      <xsl:when test="text()">
        <span style="color:blue">&lt;<xsl:value-of select="name()"/></span><xsl:apply-templates select="@*" mode="xml-att"/><span style="color:blue">&gt;</span><xsl:apply-templates select="text()" mode="xml-text"/><span style="color:blue">&lt;/<xsl:value-of select="name()"/>&gt;</span><br/>
      </xsl:when>
      <xsl:otherwise>
        <span style="color:blue">&lt;<xsl:value-of select="name()"/></span><xsl:apply-templates select="@*" mode="xml-att"/><span style="color:blue"> /&gt;</span><br/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="text()" mode="xml-text">
    <div style="margin-left: 1em; color:black"><xsl:value-of select="."/></div>
  </xsl:template>
  
</xsl:stylesheet>
