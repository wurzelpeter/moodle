@ewallah @availability @availability_language
Feature: availability_language
  In order to control student access to activities
  As a admin
  I need to add language
  As a teacher
  I need to set language conditions which prevent student access

  Background:
    Given the following "courses" exist:
      | fullname | shortname | format | enablecompletion |
      | Course 1 | C1        | topics | 1                |
    And the following "users" exist:
      | username |
      | teacher1 |
      | student1 |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |

  @javascript
  Scenario: Only one language pack installed
    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | P1 |
      | Description  | x  |
      | Page content | x  |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    Then "Language" "button" should not exist in the "Add restriction..." "dialogue"
    And I click on "Cancel" "button" in the "Add restriction..." "dialogue"
    And I log out

  @javascript
  Scenario: Two language packs installed

    # Basic setup.
    When I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I log out
    And I log in as "admin"
    And I navigate to "Language > Language packs" in site administration
    And I set the field "Available language packs" to "en_ar"
    And I press "Install selected language pack(s)"
    Then I should see "Language pack 'en_ar' was successfully installed"
    And the "Installed language packs" select box should contain "en_ar"
    And I log out

    # Page P1 for English users only.
    And I log in as "teacher1"
    And I am on "Course 1" course homepage with editing mode on
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | P1 |
      | Description  | x  |
      | Page content | x  |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    Then "Language" "button" should exist in the "Add restriction..." "dialogue"
    And I click on "Language" "button" in the "Add restriction..." "dialogue"
    Then I should see "Please set" in the "region-main" "region"
    And I set the field "Language" to "en"
    Then I should not see "Please set" in the "region-main" "region"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I click on "Save and return to course" "button"

    # Page P2 for pirate English users only.
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | P2 |
      | Description  | x  |
      | Page content | x  |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Language" "button"
    And I set the field "Language" to "en_ar"
    And I click on ".availability-item .availability-eye img" "css_element"
    And I click on "Save and return to course" "button"

    # Page P3 for English users hidden.
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | P3 |
      | Description  | x  |
      | Page content | x  |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Language" "button"
    And I set the field "Language" to "en"
    And I click on "Save and return to course" "button"

    # Page P4 for pirate English users hidden.
    And I add a "Page" to section "1"
    And I set the following fields to these values:
      | Name         | P4 |
      | Description  | x  |
      | Page content | x  |
    And I expand all fieldsets
    And I click on "Add restriction..." "button"
    And I click on "Language" "button"
    And I set the field "Language" to "en_ar"
    And I click on "Save and return to course" "button"

    # Log back in as student.
    When I log out
    And I log in as "student1"
    And I am on "Course 1" course homepage
    Then I should see "P1" in the "region-main" "region"
    And I should not see "P2" in the "region-main" "region"
    And I should see "P3" in the "region-main" "region"
    And I should see "P4" in the "region-main" "region"
    And I should see "Not available unless: The student's language is English - Pirate ‎(en_ar)" in the ".availabilityinfo" "css_element"

    When I follow "Preferences" in the user menu
    And I follow "Preferred language"
    And I set the field "lang" to "en_ar"
    And I click on "Save changes" "button"
    And I log out

    When I log in as "student1"
    And I am on "Course 1" course homepage
    Then I should not see "P1" in the "region-main" "region"
    And I should see "P2" in the "region-main" "region"
    And I should see "P3" in the "region-main" "region"
    And I should see "P4" in the "region-main" "region"
    And I should see "Not available unless: The student's language is English ‎(en)‎" in the ".availabilityinfo" "css_element"