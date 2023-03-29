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
    Then I should export the Kestrem variable to python
    And close the session