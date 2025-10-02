# Inheritance Hierarchy Diagram

This file shows the inheritance relationships between the I/O Hook classes.

## Class Hierarchy

```
                    Synergy.SynergyDE.Select.IOHooks
                                 │
                                 │ extends
                                 ↓
                          BaseIOHook
                          (Abstract)
                         /     |     \
                        /      |      \
                       /       |       \
                      /        |        \
                     /         |         \
                    ↓          ↓          ↓
            LoggingIOHook  ValidationIOHook  StatisticsIOHook
                 │
                 │
          CombinedIOHook
```

## Method Override Pattern

```
BaseIOHook (defines structure):
    public override PreRead()
        if (enabled)
            OnPreRead()    ← calls virtual method
    
    protected virtual OnPreRead()
        // Default: do nothing

Derived classes (LoggingIOHook, ValidationIOHook, etc.):
    protected override OnPreRead()
        // Custom implementation
```

## Hook Call Flow

```
Application                     Hook System
     │                               │
     ├──── open("CUSTOMER") ─────────┤
     │                               │
     │                         ┌─────┴─────┐
     │                         │           │
     │                    LoggingHook  ValidationHook
     │                         │           │
     │                    PreOpen()   PreOpen()
     │                         │           │
     │                    PostOpen()  PostOpen()
     │                         │           │
     │                         └─────┬─────┘
     │                               │
     │◄──── file opened ─────────────┤
     │                               │
     ├──── write(record) ────────────┤
     │                               │
     │                         ┌─────┴─────┐
     │                         │           │
     │                    LoggingHook  ValidationHook
     │                         │           │
     │                    PreWrite()  PreWrite()
     │                         │       Validates!
     │                         │           │
     │                    PostWrite() PostWrite()
     │                         │           │
     │                         └─────┬─────┘
     │                               │
     │◄──── write complete ──────────┤
```

## Key Design Features

### 1. Single Inheritance
Each class extends exactly one parent class (except BaseIOHook which extends IOHooks)

### 2. Virtual Methods
Base class defines virtual methods that derived classes override

### 3. Template Method Pattern
Base class defines algorithm structure, derived classes fill in details

### 4. Enable/Disable Support
All hooks inherit enable/disable capability from BaseIOHook

### 5. Concurrent Execution
Multiple hooks can be registered for same channel:
- All hooks receive all events
- Hooks execute in registration order
- Each hook is independent

## Creating New Hooks

To create a new hook:

1. Extend BaseIOHook
2. Override OnXXX methods you need
3. Add custom properties/methods
4. Register with IOHooks.AddHook()

Example:
```dbl
public class MyHook extends BaseIOHook
    
    public method MyHook
        channelName, string
    proc
        parent(channelName)  // Call base constructor
    endmethod
    
    protected override method OnPostRead, void
        channelName, string
        recordArea, a
        direction, IOReadDirection
    proc
        // Your code here
    endmethod
endclass
```

## Benefits of This Architecture

1. **Code Reuse**: Common functionality in BaseIOHook
2. **Consistency**: All hooks follow same pattern
3. **Flexibility**: Easy to add new hooks
4. **Maintainability**: Changes in base affect all hooks
5. **Testability**: Each hook can be tested independently
6. **Composability**: Multiple hooks work together

## Comparison: Individual vs Combined Hooks

### Individual Hooks (Recommended)
```dbl
IOHooks.AddHook("CHANNEL", loggingHook)
IOHooks.AddHook("CHANNEL", validationHook)
IOHooks.AddHook("CHANNEL", statsHook)
```
**Pros:**
- Each hook is independent
- Easy to enable/disable individual hooks
- Clear separation of concerns
- More modular

**Cons:**
- Slight overhead of multiple hook calls
- More objects to manage

### Combined Hook
```dbl
IOHooks.AddHook("CHANNEL", combinedHook)
```
**Pros:**
- Single hook object
- Slightly better performance
- All logic in one place

**Cons:**
- Less flexible
- Harder to enable/disable specific features
- Violates single responsibility principle

## Conclusion

This inheritance hierarchy demonstrates best practices for creating reusable, 
maintainable I/O Hook classes in Synergy DBL. The design allows for maximum 
flexibility while ensuring consistent behavior across all hook implementations.
