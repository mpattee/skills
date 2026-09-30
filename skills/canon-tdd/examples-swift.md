# Test examples: Swift

Good and bad tests, and how to set up the code so the boundaries can be faked. Examples use Swift Testing; the same shapes work in XCTest.

## Assert on outcomes, not calls

```swift
// Bad: checks how the work was done. Breaks when the internals change,
// even if checkout still behaves the same.
@Test func checkoutAsksTheCalculatorForATotal() throws {
    let calculator = SpyPriceCalculator(total: 1500)
    _ = try checkout(cart(), calculator: calculator, payments: FakePayments.accepting)
    #expect(calculator.totalCallCount == 1)
}

// Good: checks what the caller gets.
@Test func checkoutWithAValidCartIsConfirmed() throws {
    let order = try checkout(cart(with: [("book", 1500)]), payments: FakePayments.accepting)
    #expect(order.status == .confirmed)
}
```

Warning signs: faking your own types, testing private methods, asserting on call counts or order, a test name that says how rather than what.

## Read writes back through the interface

```swift
// Bad: goes around the interface to look at the storage.
@Test func createUserInsertsARow() throws {
    let store = try Store.inMemory()
    try store.createUser(name: "Alice")
    let name = try store.connection.scalar("SELECT name FROM users")
    #expect(name == "Alice")
}

// Good: the interface that wrote it also reads it.
@Test func aCreatedUserCanBeFetched() throws {
    let store = try Store.inMemory()
    let id = try store.createUser(name: "Alice")
    #expect(try store.user(id: id).name == "Alice")
}
```

## Expected values from an independent source

```swift
// Bad: recomputes the answer the way the code does, so it can't disagree.
@Test func totalSumsTheLineItems() {
    let items = [item(1000), item(500)]
    let expected = items.map(\.price).reduce(0, +)
    #expect(total(items) == expected)
}

// Good: a known literal.
@Test func totalSumsTheLineItems() {
    #expect(total([item(1000), item(500)]) == 1500)
}
```

## Making boundaries fakeable

Fake the network, the clock and randomness, and sometimes the database or file system. Two design choices make that easy.

**Pass the dependency in** instead of building it inside:

```swift
// Easy to fake: the caller chooses the implementation.
struct Syncer {
    let api: any IssueAPI
    let cache: Cache
    func sync() async throws -> Summary { /* ... */ }
}

// Hard to fake: the real client is baked in.
struct Syncer {
    let cache: Cache
    func sync() async throws -> Summary {
        let api = GitHubClient(token: try Keychain.token())
        /* ... */
    }
}
```

**One method per operation** instead of one generic request method:

```swift
// Each fake method returns one kind of result, and a test shows which calls it relies on.
protocol IssueAPI {
    func issues(in repo: String) async throws -> [Issue]
    func createIssue(_ new: NewIssue, in repo: String) async throws -> Issue
}

// A fake of this has to branch on the method and path to decide what to return.
protocol HTTP {
    func request(_ method: Method, path: String, body: Data?) async throws -> Response
}
```

A small hand-written fake that conforms to the protocol with fixed data is usually easier to read than a spy that records calls.
