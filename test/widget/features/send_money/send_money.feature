Feature: Send Money

  Scenario: Queues a transfer while offline
    Given the device is offline
    And the wallet balance is {500000} kobo
    And the send money page is displayed
    When I enter {'ACC-001'} as recipient
    And I tap the next button
    And I enter {10000} kobo amount
    And I tap the next button
    And I tap the send button
    Then the queue contains {1} pending item

  Scenario: Idempotency key is not regenerated on rebuild
    Given the wallet balance is {500000} kobo
    And the send money page is displayed
    When I enter {'ACC-001'} as recipient
    And I tap the next button
    And I enter {10000} kobo amount
    And I tap the next button
    And I tap the send button
    Then the queue contains {1} pending item
    When the send money page is rebuilt
    Then the queue still contains {1} pending item
    And the idempotency key has not changed
