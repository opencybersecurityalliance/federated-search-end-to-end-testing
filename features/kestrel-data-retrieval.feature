Feature: Kestrel Data Retrieval
    As a Threat Hunter
    I need Kestrel and STIX-Shifter to retrieve data
    So that I can match patterns
    And get directions to investigate
    And identify suspicious entities
    And group them by Kestrel variables

Scenario: Start Hunt from TTPs
    Given a Kestrel session
    And a running instance of Elasticsearch
    And a winlogbeat elastic index
    And a linux sysflow elastic index
    When I start hunt from TTPs with Kestrel
    Then I should find user processes (T1057)
    And identify local users (T1087.001)
    And discover antivirus programs (T1518.001)
    And match multiple related/similar TTPs (T1570 and T1021.006)
    And identify phishing candidates on windows
    And identify exploit candidates on linux
    And close the session

Scenario: Cross-Host Campaign Discovery
    Given a Kestrel session
    And a running instance of Elasticsearch
    And a winlogbeat elastic index
    And a linux sysflow elastic index
    When I start a cross-host campaign discovery with Kestrel
    Then I should find successful attacks led by phishing activities
    And reveal malicious activities on compromised host
    And identify hosts targetted in lateral movement by the attacker
    And identify attacker activities on windows hosts
    And identify attacker activities on linux hosts
    And discover the C2 host / IP address if any
    And close the session