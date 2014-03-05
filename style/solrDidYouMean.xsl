<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:java="http://xml.apache.org/xslt/java" 
	xmlns:cinclude="http://apache.org/cocoon/include/1.0">

<xsl:output method="xml"/>

	<xsl:variable name="start" select="//document/start" />
	<xsl:variable name="query" select="//document/query" />
	<xsl:variable name="spellQ" select="//document/spellQ" />
	<xsl:variable name="rows" select="//document/rows" />
	<xsl:variable name="decodeQ" select="//document/decodeQ" />
	<xsl:variable name="bl" select="//document/boolean" />
	<xsl:variable name="collation" select="java:java.net.URLEncoder.encode(//str[@name='collation'])" />
	

<xsl:template match="*">

	  <xsl:copy>
	  		<xsl:copy-of select="@*" />
	  		<xsl:apply-templates />
	  </xsl:copy>
	
</xsl:template>

	<xsl:template match="//document/response">
	<xsl:choose>
		<xsl:when test="//document/response/result[@numFound='0'] and //lst[@name='spellcheck']/lst/str[@name='collation']">
			<!--pass forward the unencoded version-->
			<xsl:choose>
				<xsl:when test="contains($query, ' ')">
					<xsl:variable name="queryString2" select="java:java.lang.String.new($query)"/>
					<xsl:variable name="queryString1" select="java:replaceAll($queryString2, '[^A-Za-z0-9 ]', '')" />
					<xsl:variable name="queryString" select="java:replaceAll($queryString1, '(\+| )+', ' ')" /> 
					<altTermFromCollation><xsl:value-of select="java:replaceAll($queryString,' ', ' OR  ')" /></altTermFromCollation>
				</xsl:when>
				<xsl:otherwise>
					<altTermFromCollation><xsl:value-of select="//str[@name='collation']" /></altTermFromCollation>
				</xsl:otherwise>
			</xsl:choose>
			<!-- collations may contain hypens-->
			<xsl:variable name="collationString" select="java:java.lang.String.new($collation)" />
			<cinclude:includexml>
				<cinclude:src>
					cocoon:/solrDidYouMean-<xsl:value-of select="$start" />-<xsl:value-of select="$rows" />-<xsl:value-of select="$decodeQ" />-<xsl:value-of select="$bl" />-<xsl:value-of select="java:replaceAll($collationString, '-', 'ZZhyphenZZ')" />-<xsl:value-of select="$spellQ" />
				</cinclude:src>
			</cinclude:includexml>
		</xsl:when>
		<xsl:otherwise>
			<response>
			<xsl:copy-of select="*"/>
			</response>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
<!---->
</xsl:stylesheet>

