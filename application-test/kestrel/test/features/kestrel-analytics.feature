Feature: Kestrel Analytics
    As a Threat Hunter
    I need Kestrel to analyze data
    So that I can enrich data from other sources like threat intelligence
    And pre-program detection logic (in white-box or black-box)

Scenario: Get Network Traffic before Analytics
    Given a Kestrel session
    And a running instance of Elasticsearch
    And a winlogbeat elastic index
    And a linux sysflow elastic index
    When I get the network traffic from suspicious processes without applying analytics
    Then I should not see x_domain_name and x_domain_organization customized attributes in network traffic
    And close the session

Scenario: Apply Analytics in a Hunt
    Given a Kestrel session
    And a running instance of Elasticsearch
    And a winlogbeat elastic index
    And a linux sysflow elastic index
    When I apply the docker domainnamelookup analysis on the network traffic from suspicious processes
    Then I should see customized attributes x_domain_name and x_domain_organization in network traffic
    And derive new Kestrel variable that captures Github traffic
    And derive new Kestrel variable that captures Amazon traffic
    And derive new Kestrel variable that captures Akamai traffic
    And derive new Kestrel variable that captures Cloudflare traffic
    And close the session