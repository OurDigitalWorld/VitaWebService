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
		<response>PD test</response>
		<publicIndex>${publicIndex}</publicIndex>
		<dmIndex>${dmIndex}</dmIndex>
		<appPath>${appPath}</appPath>
		<queryPath>http://localhost:8080/${publicIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDelete.asp?ID=${id}</queryPath>
		<!-- Execute the cinclude query to public index  -->
		<cinclude:includexml ignoreErrors="false">
			<cinclude:src>http://localhost:8080/${publicIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDelete.asp?ID=${id}</cinclude:src>
		</cinclude:includexml>
	</document>
</xsl:template>
</xsl:stylesheet>
