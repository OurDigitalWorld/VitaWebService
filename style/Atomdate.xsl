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
		<date name="madePublic">
			<xsl:value-of select="substring(.,0,17)" />
			<xsl:text>:00Z</xsl:text>
		</date>
	</xsl:template>

</xsl:stylesheet>