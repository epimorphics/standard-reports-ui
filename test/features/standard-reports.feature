@ci-exclude
Feature: standard-reports

	As a visitor

	I want to retrieve a standard report

    @javascript
    Scenario:
      Given I am a visitor
      When I retrieve the page "/app/standard-reports"
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\.css$"
      And it should have an image matching "lr_logo.*\.png$"b
      When I click on the "create a standard report" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\.css$"
      And it should have an image matching "lr_logo.*\.png$"b
      When I choose the "report_avgPrice" radio button
      And  I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\.css$"
      And it should have an image matching "lr_logo.*\.png$"b
      When I choose the "areaType_pcSector" radio button
      And  I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\.css$"
      And it should have an image matching "lr_logo.*\.png$"b
      When I enter "BS20 6" in the "area" field
      And  I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\\.css$"
      And it should have an image matching "lr_logo.*\\.png$"
      When I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\\.css$"
      And it should have an image matching "lr_logo.*\\.png$"b
      When I click on the "More dates" text
      And  I click on a random checkbox
      And  I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\.css$"
      And it should have an image matching "lr_logo.*\.png$"
      Then I select a random radio button
      And  I click on the "Next" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\\.css$"
      And it should have an image matching "lr_logo.*\\.png$"
      Then I click on the "Generate report" button
      Then I should retrieve a web page
      And it should have rules from stylesheet matching ".*application.*\\.css$"
      And it should have an image matching "lr_logo.*\\.png$"
      And  I wait upto 60 seconds for the link "open-data (csv) format" to appear




