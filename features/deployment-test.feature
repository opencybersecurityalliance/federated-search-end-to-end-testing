Feature: Kestrel STIX-Shifter Environment for Integration Testing
    As a Tester
    I need an evironment including Kestrel, STIX-Shifter and Elasticsearch
    So that I can perform Integration Testing

Scenario: A non-interactive execution of a huntflow
    Given a Kestrel session
    And a huntbook named "kestrel-test.hf"
    And a running instance of Elasticsearch
    When I read with Kestrel the huntbook "kestrel-test.hf"
    Then I should see the execution results
    And close the session

Scenario: Export Kestrel variable to Python
    Given a Kestrel session
    And a hunt flow
    And a running instance of Elasticsearch
    When I execute the hunt flow with Kestrel
    Then I should export the Kestrel variable to python
    And close the session

Scenario: Start Hunt from TTPs
    Given a Kestrel session
    And a running instance of Elasticsearch
    And a winlogbeats elastic index
    And a linux sysflow elastic index
    When I start hunt from TTPs with Kestrel
    Then I should find user processes (T1057)
    And identify local users (T1087.001)
    And discover antivirus programs (T1518.001)
    And match multiple related/similar TTPs (T1570 and T1021.006)
    And identify phishing candidates on windows
    And identify exploit candidates on linux
    And close the session