# Test examples: Ruby

Good and bad tests, and how to set up the code so the boundaries can be faked. Examples use Minitest as Rails sets it up; the same shapes work in RSpec.

## Assert on outcomes, not calls

```ruby
# Bad: checks how the work was done. Breaks when the internals change,
# even if publishing still behaves the same.
test "publish asks the slugger for a slug" do
  slugger = Minitest::Mock.new
  slugger.expect(:slug_for, "spring-concert", ["Spring Concert"])
  news_items(:draft).publish!(slugger: slugger)
  slugger.verify
end

# Good: checks what the caller gets.
test "publishing a draft makes it visible" do
  item = news_items(:draft)
  item.publish!
  assert_includes NewsItem.visible, item
end
```

Warning signs: mocking your own classes, calling private methods with `send`, asserting on call counts or order, a test name that says how rather than what.

## Read writes back through the interface

In an integration test the seam is HTTP, so check the result over HTTP too.

```ruby
# Bad: goes around the interface to look at the storage.
test "creating a news item inserts a row" do
  post news_items_path, params: { news_item: { title: "Spring Concert", published: true } }
  count = ActiveRecord::Base.connection.select_value(
    "SELECT COUNT(*) FROM news_items WHERE title = 'Spring Concert'"
  )
  assert_equal 1, count
end

# Good: the page a reader sees shows it.
test "a created news item shows on the news page" do
  post news_items_path, params: { news_item: { title: "Spring Concert", published: true } }
  get news_path
  assert_select "h2", text: "Spring Concert"
end
```

## Expected values from an independent source

```ruby
# Bad: recomputes the answer the way the code does, so it can't disagree.
test "total sums the line items" do
  items = [item(1000), item(500)]
  assert_equal items.sum(&:price), Order.total(items)
end

# Good: a known literal.
test "total sums the line items" do
  assert_equal 1500, Order.total([item(1000), item(500)])
end
```

## Making boundaries fakeable

Fake the network, the clock and randomness, and sometimes the file system. For the clock, use Rails' `travel_to` rather than stubbing `Time.now`. Two design choices make the rest easy.

**Pass the dependency in**, with the real one as the default:

```ruby
# Easy to fake: a test passes its own api.
class Syncer
  def initialize(api: GitHubClient.new, cache: Cache.new)
    @api = api
    @cache = cache
  end
end

# Hard to fake: the real client is baked in.
class Syncer
  def sync
    api = GitHubClient.new(ENV.fetch("GITHUB_TOKEN"))
    # ...
  end
end
```

**One method per operation** instead of one generic request method:

```ruby
# Each fake method returns one kind of result, and a test shows which calls it relies on.
class IssueApi
  def issues(repo)
    # ...
  end

  def create_issue(repo, attributes)
    # ...
  end
end

# A fake of this has to branch on the verb and path to decide what to return.
class Http
  def request(verb, path, body = nil)
    # ...
  end
end
```

A small plain-Ruby fake that responds to the same methods with fixed data is usually easier to read than a `Minitest::Mock` full of expectations.
