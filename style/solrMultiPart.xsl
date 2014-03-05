<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:java="http://xml.apache.org/xslt/java" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">

<xsl:output method="xml"/>

<xsl:variable name="query" select="//document/query" />
<xsl:variable name="partsQ" select="//document/partsQ" />
<xsl:variable name="Q">
	<xsl:choose>
		<xsl:when test="string-length($partsQ &gt; 0)">q=(<xsl:value-of select="$partsQ" />)+AND+</xsl:when>
		<xsl:otherwise>q=</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:param name="solrParts"/>

<xsl:template match="*">

	  <xsl:copy>
	  		<xsl:copy-of select="@*" />
	  		<xsl:apply-templates />
	  </xsl:copy>
	
</xsl:template>

<xsl:template match="//document/response/result/doc">
	<xsl:choose>
		<xsl:when test="./bool[@name='multiPart']='true' and string-length($partsQ) &gt; 0">
			<doc>
			<xsl:copy-of select="*"/>
			<parts>
			<cinclude:includexml>
				<cinclude:src>
				<xsl:value-of select="$solrParts" /><xsl:value-of select="$Q" />docid:<xsl:value-of select="./str[@name='id']" />&amp;sort=partSort+asc&amp;rows=10&amp;fl=id,docid,partURL,label,partSort&amp;hl=on&amp;hl.fl=text&amp;hl.fragsize=75
				</cinclude:src>
			</cinclude:includexml>
			</parts>
			</doc>
		</xsl:when>
		<xsl:otherwise>
			<doc>
			<xsl:copy-of select="*"/>
			</doc>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!---->
</xsl:stylesheet>

