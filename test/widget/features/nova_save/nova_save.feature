Feature: NovaSave Contribution

  Scenario Outline: Progress percentage is correct at boundaries
    Given a savings goal with target <target> kobo and current <current> kobo
    When the nova save page is displayed
    Then I see <progressText> text

    Examples:
    | target | current | progressText |
    | 100000 |       0 |        '0%' |
    | 100000 |   50000 |       '50%' |
    | 100000 |  100000 |      '100%' |
    | 100000 |    1000 |        '1%' |

  Scenario: Contribution is queued while offline
    Given the device is offline
    And a savings goal of {100000} kobo target and {50000} kobo current
    When the nova save page is displayed
    And I contribute {10000} kobo
    Then the queue contains {1} pending item
