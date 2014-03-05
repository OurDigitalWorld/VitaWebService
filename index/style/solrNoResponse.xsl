<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:cinclude="http://apache.org/cocoon/include/1.0">

<xsl:output method="xml"/>
<xsl:template match="/">


	<document>
		<IPAddress>${IPAddress}</IPAddress>
		<IPAddressCheck>${IPAddressCheck}</IPAddressCheck>
		<pubdisplay>${pubdisplay}</pubdisplay>
		<text>Not doing nothing for nobody from this IP Address</text>
	</document>
</xsl:template>
</xsl:stylesheet>