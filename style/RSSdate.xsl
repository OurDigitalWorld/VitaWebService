<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:java="http://xml.apache.org/xslt/java">

	<xsl:output method="xml"/>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="date[@name='madePublic']">
		<xsl:variable name="isoformat">
			<xsl:text>yyyy-MM-dd'T'HH:mm'Z'</xsl:text>
			<!--<xsl:text>yyyy-MM-dd'T'HH:mm:ss'Z'</xsl:text>-->
		</xsl:variable>
		<xsl:variable name="theDate">
			<xsl:value-of select="substring(.,0,16)" />
			<xsl:text>Z</xsl:text>
		</xsl:variable>

		<xsl:variable name="rssformat">
			<xsl:text>EEE, dd MMM yyyy HH:mm 'GMT'</xsl:text>
		</xsl:variable>

		<date name="madePublic">
			<xsl:value-of select="java:dateUtil.reFormat($isoformat, $rssformat, $theDate)" /> 
		</date>
	</xsl:template>

</xsl:stylesheet>