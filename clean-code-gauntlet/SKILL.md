---
name: clean-code-gauntlet
description: 'Generates production-grade code in C#, C++, JavaScript, and Python. Enforces Clean Code, anti-mutation testing, and QA metrics with smart applicability rules. Cuándo usarla: For production components, business logic, and performance-critical features. NOT for prototypes, scripts, or experimental code.'
---

# Clean Code Gauntlet v2.0

**CORE DIRECTIVE:** Generate production-ready code with verifiable quality. Apply constraints intelligently based on context. ALWAYS output all 3 blocks when applicable.

---

## 1. Smart Applicability Filter (Decide First)

**✅ GENERATE WITH FULL GAUNTLET:**
- Business logic and domain models
- API endpoints and service layers
- Data processing pipelines
- Cryptography, security-critical code
- Performance-sensitive algorithms
- Shared libraries and SDKs
- Code that handles financial, medical, or safety-critical data

**❌ SKIP GAUNTLET (Explain why to user):**
- Prototypes and MVP code
- Scripts and one-off utilities (< 50 lines)
- Experimental/proof-of-concept features
- Configuration files or DSL
- Auto-generated or templated code
- Throwaway debugging tools
- Frontend UI components with minimal logic
- Installation/setup scripts

**⚠️ ADAPT GAUNTLET (Reduce scope):**
- CLI tools (95% coverage instead of 100%, fewer edge cases)
- Performance-critical loops (focus on mutation testing over coverage)
- Data layer code (100% coverage; DI optional if performance-critical)

---

## 2. Language-Specific Adaptations

### **C# (.NET Framework / .NET Core)**
- **Exception Handling:** Use typed exceptions, avoid catch-all
- **DI Container:** Leverage built-in DI (Microsoft.Extensions.DependencyInjection)
- **Testing Framework:** xUnit (modern standard)
- **Anti-Mutation Tools:** Stryker.NET for automated mutation testing
- **Code Style:** Follow Microsoft naming conventions (PascalCase for public)
- **Async/Await:** Handle async code paths explicitly in tests

### **C++ (C++17 or later)**
- **Exception Handling:** Minimize exceptions in performance code; use `std::optional` / `std::expected`
- **DI:** Use factory patterns or simple composition (no heavy frameworks)
- **Testing Framework:** Google Test (gtest) + Google Mock (gmock)
- **Anti-Mutation:** Manual mutation testing (C++ lacks mature automated tools)
- **Memory Safety:** Emphasize RAII, smart pointers; validate all allocations
- **Edge Cases:** Double-check integer overflow, null pointers, buffer bounds
- **Coverage Tool:** gcov + lcov for branch/statement coverage

### **JavaScript (ES6+, Node.js)**
- **Exception Handling:** Promise rejection handling + try/catch for async
- **DI:** Dependency injection via function parameters or modules
- **Testing Framework:** Jest (standard; includes coverage reporting)
- **Anti-Mutation:** Stryker.js for automated mutation testing
- **Type Safety:** Use JSDoc or TypeScript (TS recommended for production)
- **Async/Await:** Native first-class support; test both happy path and rejection scenarios
- **Edge Cases:** Null/undefined handling, type coercion pitfalls, async race conditions

### **Python (3.9+)**
- **Exception Handling:** Custom exceptions for domain logic
- **DI:** Constructor injection or dataclasses with defaults
- **Testing Framework:** pytest (more flexible than unittest)
- **Anti-Mutation:** mutmut for automated mutation testing
- **Type Safety:** Type hints + mypy for static analysis
- **Code Style:** PEP 8 compliance
- **Edge Cases:** Integer division, string encoding, mutable default args

---

## 3. Mandatory Output Format

### [GHERKIN]
```gherkin
Feature: [Feature Name]
  Scenario: [Happy path / primary use case]
    Given [precondition]
    When [action]
    Then [expected outcome]
  
  Scenario: [Edge case / boundary]
    Given [precondition]
    When [edge case trigger]
    Then [expected behavior]
  
  # Additional scenarios for error conditions, state transitions
```
**Scope:** Cover happy paths, boundary conditions, and error scenarios. Minimum 3-5 scenarios per feature.

---

### [CODE]
Production-ready, language-idiomatic code with:
- ✅ **Clean Code Principles:**
  - Revealing variable/function names (no abbreviations)
  - Single Responsibility Principle (micro-functions)
  - DRY (no duplication)
  - No magic numbers/strings (use constants)
  - Exception-based error handling (not error codes)

- ✅ **Architecture:**
  - Minimize cyclomatic complexity (target: ≤ 3 per function)
  - High cohesion, low coupling
  - Dependency Injection where applicable
  - Strict input validation at boundaries

- ✅ **Language Idioms:**
  - Leverage language-specific patterns
  - Use standard library functions
  - Follow naming conventions (PascalCase for C#, snake_case for Python, etc.)

---

### [TESTS]
Unit test suite with:
- ✅ **Coverage Target:** 90-100% branch and statement coverage
  - 100% for business logic, crypto, safety-critical
  - 95% for data layers, algorithms
  - 90% for CLI tools, service utilities

- ✅ **Anti-Mutation Assertions:**
  - Tests MUST fail if logical operators mutate (`<` → `<=`, `&&` → `||`)
  - Tests MUST fail if math operators mutate (`+` → `-`, `*` → `/`)
  - Tests MUST fail if boundary constants mutate (e.g., `MAX_RETRIES: 3` → `2`)
  - Include off-by-one checks for loops and comparisons

- ✅ **Test Structure:**
  - Arrange/Act/Assert pattern
  - One assertion per logical concept (multiple assertions okay if related)
  - Descriptive test names: `[MethodName]_[Condition]_[Expected]`
  - No test interdependencies; tests run in any order

- ✅ **Edge Cases Covered:**
  - Null/empty inputs
  - Boundary values (min/max)
  - Type coercion edge cases (language-specific)
  - State transitions
  - Error paths and exceptions

---

## 4. Execution & Verification

**If execution tools available (CLI/bash):**
- Run all tests with coverage report
- Validate 90%+ branch coverage minimum
- Fix any failing tests before output
- Report: `[✓ 156 tests passed | ✓ 94% coverage | ✓ Mutation score: 88%]`

**If no execution tools:**
- Simulate strict step-by-step execution mentally
- Verify logic paths exhaustively
- Flag any uncertainty to user: `[⚠ Manual verification recommended for: X]`

---

## 5. Output Checklist

Before finalizing output, verify:

- [ ] Applicability filter passed (not a prototype/script)
- [ ] All 3 blocks present: [GHERKIN], [CODE], [TESTS]
- [ ] Language-specific patterns applied
- [ ] Code follows Clean Code principles (no magic numbers, revealing names)
- [ ] Cyclomatic complexity ≤ 3 per function
- [ ] All inputs validated at boundaries
- [ ] Anti-mutation assertions present in tests
- [ ] Test coverage meets target (90-100%)
- [ ] No test interdependencies
- [ ] Async/concurrent paths tested (if applicable)
- [ ] Error scenarios covered

---

## 6. Examples by Language

### Example: C# (PaymentProcessor)
```csharp
// CODE BLOCK (simplified)
public class PaymentProcessor
{
    private readonly IPaymentGateway gateway;
    private const decimal MinimumAmount = 0.01m;
    
    public PaymentProcessor(IPaymentGateway gateway)
    {
        this.gateway = gateway ?? throw new ArgumentNullException(nameof(gateway));
    }
    
    public async Task<PaymentResult> ProcessAsync(decimal amount)
    {
        ValidateAmount(amount);
        return await gateway.ChargeAsync(amount);
    }
    
    private void ValidateAmount(decimal amount)
    {
        if (amount < MinimumAmount)
            throw new InvalidOperationException($"Amount must be at least {MinimumAmount}");
    }
}
```

```csharp
// TESTS BLOCK (anti-mutation examples)
[Fact]
public async Task ProcessAsync_ValidAmount_ChargesSuccessfully()
{
    // Arrange
    var mockGateway = new Mock<IPaymentGateway>();
    mockGateway.Setup(g => g.ChargeAsync(It.IsAny<decimal>()))
        .ReturnsAsync(new PaymentResult { Success = true });
    var processor = new PaymentProcessor(mockGateway.Object);
    
    // Act
    var result = await processor.ProcessAsync(10.00m);
    
    // Assert
    Assert.True(result.Success);
    mockGateway.Verify(g => g.ChargeAsync(10.00m), Times.Once);
}

[Fact]
public void ProcessAsync_BelowMinimumAmount_ThrowsException()
{
    // Arrange
    var processor = new PaymentProcessor(new Mock<IPaymentGateway>().Object);
    
    // Act & Assert
    var ex = Assert.Throws<InvalidOperationException>(() => 
        processor.Process(0.001m));
    
    // Anti-mutation: Verifies boundary is exactly MinimumAmount (0.01), not >= or <=
    Assert.Contains("0.01", ex.Message);
}

[Fact]
public void ProcessAsync_ExactlyMinimumAmount_Succeeds()
{
    // Edge case: off-by-one protection
    var processor = new PaymentProcessor(new Mock<IPaymentGateway>().Object);
    Assert.DoesNotThrow(() => processor.Process(0.01m));
}
```

---

## 7. Anti-Mutation Testing Deep Dive

### Why It Matters
Traditional coverage (95%) can miss bugs. Mutation testing catches logic errors:

```javascript
// Example: Bad test (doesn't catch mutation)
function discount(price, percentage) {
    if (percentage < 0) throw new Error("Invalid");
    return price * (1 - percentage / 100);
}

// Weak test (passes even if < mutates to <=)
test('rejects negative percentage', () => {
    expect(() => discount(100, -5)).toThrow();
});

// Strong test (catches mutation)
test('boundary: zero percentage is valid', () => {
    expect(discount(100, 0)).toBe(100); // FAILS if < mutates to <=
});

test('boundary: just below zero is invalid', () => {
    expect(() => discount(100, -0.01)).toThrow(); // FAILS if < mutates to <=
});
```

### Required Patterns
1. **Boundary Testing:** Always test both sides of comparison operators
2. **Operator Mutations:** Explicit tests for `<`, `>`, `<=`, `>=`, `==`, `!=`
3. **Math Mutations:** Tests for `+`, `-`, `*`, `/`, `%`
4. **Constant Mutations:** Tests that verify exact constant values

---

## 8. When NOT to Use This Skill

**Explicitly skip if:**
- User asks for "quick prototype" or "throwaway code"
- Script < 50 lines of code
- Configuration or template code
- UI component with no business logic
- Installation/deployment scripts
- Code exploration or learning exercises

**User message examples to skip:**
- "Help me test this script"
- "I need a quick function to..."
- "Generate sample data for..."
- "Create a utility to parse..."

**Response:** "This is a script/utility, not production code. I'll generate it simply without the full Gauntlet."

---

## 9. Performance & Pragmatism

- **Don't over-engineer:** DI adds value to large systems, not 20-line helpers
- **Balance testing:** 100% coverage is ideal; 95%+ is acceptable for utilities
- **Use language strengths:** C++'s performance > perfect testing in hot loops
- **Communicate trade-offs:** "I've prioritized performance here; coverage is 88% vs. 100%"

---

## Summary Table

| Scenario | Gauntlet? | Coverage | Notes |
|----------|-----------|----------|-------|
| Payment processor | ✅ Full | 100% | Safety-critical |
| REST API service | ✅ Full | 100% | Production layer |
| CLI utility | ⚠️ Adapted | 90% | Less critical |
| Prototype/MVP | ❌ Skip | None | Explain reasoning |
| UI component | ⚠️ Adapted | 80% | Focus on logic |
| Configuration parser | ❌ Skip | None | DSL-like |
| Data model | ✅ Full | 100% | Shared/core |

