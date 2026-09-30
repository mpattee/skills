# Test examples: Rust

Good and bad tests, and how to set up the code so the boundaries can be faked.

## Assert on outcomes, not calls

```rust
// Bad: checks how the work was done. Breaks when the internals change,
// even if checkout still behaves the same.
#[test]
fn checkout_asks_the_calculator_for_a_total() {
    let mut calculator = MockPriceCalculator::new();
    calculator.expect_total().times(1).returning(|_| 1500);
    checkout(&cart(), &calculator, &FakePayments::accepting()).unwrap();
}

// Good: checks what the caller gets.
#[test]
fn checkout_with_a_valid_cart_is_confirmed() {
    let order = checkout(&cart_with(&[("book", 1500)]), &FakePayments::accepting()).unwrap();
    assert_eq!(order.status, Status::Confirmed);
}
```

Warning signs: mocking your own types, testing private functions, asserting on call counts or order, a test name that says how rather than what.

## Read writes back through the interface

```rust
// Bad: goes around the interface to look at the storage.
#[test]
fn create_user_inserts_a_row() {
    let store = Store::in_memory();
    store.create_user("Alice").unwrap();
    let name: String = store
        .connection()
        .query_row("SELECT name FROM users", [], |row| row.get(0))
        .unwrap();
    assert_eq!(name, "Alice");
}

// Good: the interface that wrote it also reads it.
#[test]
fn a_created_user_can_be_fetched() {
    let store = Store::in_memory();
    let id = store.create_user("Alice").unwrap();
    assert_eq!(store.user(id).unwrap().name, "Alice");
}
```

## Expected values from an independent source

```rust
// Bad: recomputes the answer the way the code does, so it can't disagree.
#[test]
fn total_sums_the_line_items() {
    let items = [item(1000), item(500)];
    let expected: u32 = items.iter().map(|i| i.price).sum();
    assert_eq!(total(&items), expected);
}

// Good: a known literal.
#[test]
fn total_sums_the_line_items() {
    assert_eq!(total(&[item(1000), item(500)]), 1500);
}
```

## Making boundaries fakeable

Fake the network, the clock and randomness, and sometimes the database or file system. Two design choices make that easy.

**Pass the dependency in** instead of building it inside:

```rust
// Easy to fake: the caller chooses the implementation.
fn sync(api: &impl IssueApi, cache: &Cache) -> Result<Summary> { /* ... */ }

// Hard to fake: the real client is baked in.
fn sync(cache: &Cache) -> Result<Summary> {
    let api = GitHubClient::new(std::env::var("GITHUB_TOKEN")?);
    /* ... */
}
```

**One method per operation** instead of one generic request method:

```rust
// Each fake method returns one kind of result, and a test shows which calls it relies on.
trait IssueApi {
    fn issues(&self, repo: &str) -> Result<Vec<Issue>>;
    fn create_issue(&self, repo: &str, new: &NewIssue) -> Result<Issue>;
}

// A fake of this has to branch on the method and path to decide what to return.
trait Http {
    fn request(&self, method: Method, path: &str, body: Option<&str>) -> Result<Response>;
}
```

A hand-written fake that implements the trait with fixed data is usually simpler to read than a mocking library's expectations.
