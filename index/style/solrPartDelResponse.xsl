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
		<response>Part</response>
		<partsIndex>${partsIndex}</partsIndex>
		<request>http://localhost:8080/${partsIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDeletePart.asp?ID=${id}</request>
		<!-- parts index  -->
		<cinclude:includexml ignoreErrors="false">
			<cinclude:src>http://localhost:8080/${partsIndex}/update?stream.url=http://data.ourontario.ca/${appPath}/indexDeletePart.asp?ID=${id}</cinclude:src>
		</cinclude:includexml>
	</document>
</xsl:template>
</xsl:stylesheet>
