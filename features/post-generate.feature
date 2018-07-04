Feature: Generate new WordPress posts

  Background:
    Given a WP install

  Scenario: Generating posts
    When I run `echo "Content generated by wp post generate" | wp post generate --count=1 --post_content`
    And I run `wp post list --field=post_content`
    Then STDOUT should contain:
      """
      Content generated by wp post generate
      """
    And STDERR should be empty

  Scenario: Generating posts by a specific author

    When I run `wp user create dummyuser dummy@example.com --porcelain`
    Then save STDOUT as {AUTHOR_ID}

    When I run `wp post generate --post_author={AUTHOR_ID} --post_type=post --count=16`
    And I run `wp post list --post_type=post --author={AUTHOR_ID} --format=count`
    Then STDOUT should contain:
      """
      16
      """

  Scenario: Generating pages
    When I run `wp post generate --post_type=page --max_depth=10`
    And I run `wp post list --post_type=page --field=post_parent`
    Then STDOUT should contain:
      """
      1
      """

  Scenario: Generating posts and outputting ids
    When I run `wp post generate --count=1 --format=ids`
    Then save STDOUT as {POST_ID}

    When I run `wp post update {POST_ID} --post_title="foo"`
    Then STDOUT should contain:
      """
      Success:
      """

  Scenario: Generating post and outputting title and name
    When I run `wp post generate --count=3 --post_title=Howdy!`
    And I run `wp post list --field=post_title --posts_per_page=3`
    Then STDOUT should contain:
      """
      Howdy!
      Howdy! 2
      Howdy! 3
      """
    And STDERR should be empty
    And I run `wp post list --field=post_name --posts_per_page=3`
    Then STDOUT should contain:
      """
      howdy
      howdy-2
      howdy-3
      """
    And STDERR should be empty

  Scenario: Generating posts with post_date argument without time
    When I run `wp post generate --count=1 --post_date="2018-07-01"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-01 00:00:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-01 00:00:00
      """

  Scenario: Generating posts with post_date argument with time
    When I run `wp post generate --count=1 --post_date="2018-07-02 00:00:00"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-02 00:00:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-02 00:00:00
      """

  Scenario: Generating posts with post_date_gmt argument without time
    When I run `wp post generate --count=1 --post_date_gmt="2018-07-03"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-03 00:00:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-03 00:00:00
      """

  Scenario: Generating posts with post_date_gmt argument with time
    When I run `wp post generate --count=1 --post_date_gmt="2018-07-04 00:00:00"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-04 00:00:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-04 00:00:00
      """

  Scenario: Generating posts with post_date argument with hyphenated time
    When I run `wp post generate --count=1 --post_date="2018-07-05-17:17:17"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-05 17:17:17
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-05 17:17:17
      """

  Scenario: Generating posts with post_date_gmt argument with hyphenated time
    When I run `wp post generate --count=1 --post_date_gmt="2018-07-06-12:12:12"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      2018-07-06 12:12:12
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2018-07-06 12:12:12
      """

  Scenario: Generating posts with different post_date & post_date_gmt argument without time
    When I run `wp post generate --count=1 --post_date="1999-12-31" --post_date_gmt="2000-01-01"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      1999-12-31 00:00:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2000-01-01 00:00:00
      """

	Scenario: Generating posts with different post_date & post_date_gmt argument with time
    When I run `wp post generate --count=1 --post_date="1999-12-31 11:11:00" --post_date_gmt="2000-01-01 02:11:00"`
    And I run `wp post list --field=post_date`
    Then STDOUT should contain:
      """
      1999-12-31 11:11:00
      """
    And I run `wp post list --field=post_date_gmt`
    Then STDOUT should contain:
      """
      2000-01-01 02:11:00
      """
