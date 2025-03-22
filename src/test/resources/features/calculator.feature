@acceptance
Feature: Calculator Operations

  Scenario: Adding two numbers
    Given I have a calculator
    When I add 2 and 3
    Then the result should be 5
