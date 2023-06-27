Feature: Testing STIX-Shifter with STIX Bundle Connector
 As a Tester
 I need to test that STIX Shifter is running with a STIX Bundle Connector
 So that I can certify my STIX Bundle Connector
Scenario: Ping the STIX Bundle JSON File
 Given a STIX Bundle JSON file URL
 When I ping the URL
 Then I should get a Success return code