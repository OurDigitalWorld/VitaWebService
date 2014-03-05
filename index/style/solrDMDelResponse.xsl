<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:cinclude="http://apache.org/cocoon/include/1.0">

<xsl:output method="xml"/>
<xsl:template match="/">


	<document>
		<IPAddress>${IPAddress}</IPAddress>
		<IPAddressCheck>${IPAddressCheck}</IPAddressCheck>
		<id>${id}</id>
		<pd>${pd}</pd>
		<pubdisplay>${pubdisplay}</pubdisplay>
		<response>DM</response>
		<pubdisplay>${pubdisplay}</pubdisplay>
		<publicIndex>${publicIndex}</publicIndex>
		<partsIndex>${partsIndex}</partsIndex>
		<dmIndex>${dmIndex}</dmIndex>
		<!-- DM index  -->
		<cinclude:includexml ignoreErrors="true">
			<cinclude:src>http://localhost:8080/${dmIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDelete.asp?ID=${id}</cinclude:src>
			
		</cinclude:includexml>
		<!-- public index  -->
		<cinclude:includexml ignoreErrors="false">
			<cinclude:src>http://localhost:8080/${publicIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDelete.asp?ID=${id}</cinclude:src>
		</cinclude:includexml>
		<!-- parts index  -->
		<cinclude:includexml ignoreErrors="false">
			<cinclude:src>http://localhost:8080/${partsIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDeleteDocParts.asp?ID=${id}</cinclude:src>
		</cinclude:includexml>
	</document>
</xsl:template>
</xsl:stylesheet>
