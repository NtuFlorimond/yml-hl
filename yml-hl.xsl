<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:fo="http://www.w3.org/1999/XSL/Format" 
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:str="http://exslt.org/strings"
                exclude-result-prefixes="d str" 
                version="1.0">

  <!-- Formatting of elements -->
  <xsl:attribute-set name="yml.properties">
    <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="yml.default.properties">
  </xsl:attribute-set>

  <xsl:attribute-set name="yml.comment.properties" use-attribute-sets="yml.default.properties">
    <xsl:attribute name="color">orange</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="yml.attribute.properties" use-attribute-sets="yml.default.properties">
    <xsl:attribute name="color">blue</xsl:attribute>
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="yml.value.properties" use-attribute-sets="yml.default.properties">
    <xsl:attribute name="color">green</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

<!-- Entry point template -->
  <xsl:template match="d:programlisting[@language = 'yml']">
    <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
<fo:block id="{$id}" background-color="#E0E0E0">

    <xsl:variable name="tokens" select="str:tokenize(., '&#xA;&#xD;')" />

    <xsl:for-each select="$tokens">
      <xsl:call-template name="yml_line">
        <xsl:with-param name="content" select="."/>
      </xsl:call-template>
    </xsl:for-each>
</fo:block>
  </xsl:template>

  <xsl:template name="yml_line">
    <xsl:param name="content"/>
    <fo:block xsl:use-attribute-sets="yml.properties">
      <xsl:choose>
        <xsl:when test="contains($content,'#')">
          <xsl:call-template name="lineWithComment">
            <xsl:with-param name="content" select="$content"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="attributeValue">
            <xsl:with-param name="content" select="$content"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
  </xsl:template>

  <!-- Take care of the comment as a line -->
  <xsl:template name="comment">
    <xsl:param name="comment"/>
<fo:inline xsl:use-attribute-sets="yml.comment.properties"><xsl:value-of select="$comment"/></fo:inline>
  </xsl:template>

  <!-- Take care of the comment in a line -->
  <xsl:template name="lineWithComment">
    <xsl:param name="content"/>

    <xsl:variable name="before" select="substring-before($content, '#')"/>
    <xsl:variable name="attributeBeforeComment" select="string-length($before)"/>
    <xsl:variable name="yml.comment" select="concat('#',substring-after( $content , '#'))"/>

    <xsl:if test="string-length(normalize-space($before)) != 0">
      <xsl:call-template name="attributeValue">
        <xsl:with-param name="content" select="substring($before,1,$attributeBeforeComment)"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:call-template name="comment">
      <xsl:with-param name="comment" select="$yml.comment"/>
    </xsl:call-template>
  </xsl:template>

  <!-- Take care of the pair attribute and value - if any -->
  <xsl:template name="attributeValue">
    <xsl:param name="content"/>

    <xsl:variable name="yml.attribute" select="substring-before($content, ':')"/>
    <xsl:variable name="yml.value" select="substring-after( $content , ':')"/>

    <xsl:choose>
      <xsl:when test="string-length(normalize-space($yml.attribute)) &gt; 0">
<fo:inline xsl:use-attribute-sets="yml.attribute.properties"><xsl:value-of select="$yml.attribute"/></fo:inline><xsl:text>:</xsl:text>
        <xsl:if test="string-length(normalize-space($yml.value)) &gt; 0">
<fo:inline xsl:use-attribute-sets="yml.value.properties"><xsl:value-of select="$yml.value"/></fo:inline>
        </xsl:if>
      </xsl:when>
<!-- Particular cases -->
      <xsl:when test="normalize-space($content) = '{}'">
<fo:inline xsl:use-attribute-sets="yml.default.properties"><xsl:value-of select="$content"/></fo:inline>
      </xsl:when>
      <xsl:when test="normalize-space($content) = '-'">
<fo:inline xsl:use-attribute-sets="yml.default.properties"><xsl:value-of select="$content"/></fo:inline>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
