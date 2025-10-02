# Architecture Documentation

## Overview

This document describes the architecture and design decisions behind the IoHookInheritance example project.

## Design Goals

1. **Demonstrate inheritance** in Synergy DBL I/O Hooks
2. **Show concurrent hook usage** with multiple hooks on the same channel
3. **Provide reusable components** through base class abstraction
4. **Illustrate best practices** for hook implementation
5. **Create educational examples** that are easy to understand and extend

## Architecture Layers

```
┌─────────────────────────────────────────────┐
│          Application Layer                   │
│         (MainProgram.dbl)                    │
└──────────────────┬──────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────┐
│        I/O Hook Layer                        │
│  ┌──────────────────────────────────────┐   │
│  │  LoggingIOHook                       │   │
│  │  ValidationIOHook                    │   │
│  │  StatisticsIOHook                    │   │
│  │  CombinedIOHook                      │   │
│  └─────────────┬────────────────────────┘   │
└────────────────┼────────────────────────────┘
                 │ inherits from
                 ↓
┌─────────────────────────────────────────────┐
│      Base Hook Layer                         │
│         (BaseIOHook.dbl)                     │
└──────────────────┬──────────────────────────┘
                   │ extends
                   ↓
┌─────────────────────────────────────────────┐
│    Synergy Runtime Layer                     │
│       (IOHooks class)                        │
└─────────────────────────────────────────────┘
```

## Core Components

### 1. BaseIOHook (Abstract Base Class)

**Purpose:** Provides common infrastructure for all I/O hooks

**Key Features:**
- Implements the IOHooks interface
- Provides enable/disable functionality
- Defines virtual methods for derived classes
- Handles channel name management
- Filters hook calls when disabled

**Design Pattern:** Template Method Pattern
- Base class defines the algorithm structure (IOHooks overrides)
- Derived classes implement specific steps (OnXXX methods)

```dbl
public abstract class BaseIOHook extends IOHooks
    protected mChannelName, string
    protected mEnabled, boolean
    
    ;; Template methods (final)
    public override method PreRead, void
    proc
        if (mEnabled)
            this.OnPreRead(...)  ;; Call virtual method
    endmethod
    
    ;; Virtual methods (overridable)
    protected virtual method OnPreRead, void
    proc
        ;; Default: do nothing
    endmethod
endclass
```

### 2. Specialized Hooks (Concrete Classes)

Each specialized hook extends BaseIOHook and overrides specific virtual methods:

#### LoggingIOHook
- **Purpose:** Audit trail and debugging
- **Overridden Methods:** OnPostOpen, OnPostRead, OnPreWrite, OnPreUpdate, OnPreDelete, OnPostClose
- **State:** Log file channel, log file name
- **Resource Management:** Opens log file in constructor, closes in destructor

#### ValidationIOHook
- **Purpose:** Data quality assurance
- **Overridden Methods:** OnPreWrite, OnPreUpdate
- **State:** Min/max length constraints, error counter
- **Validation Rules:** Length checks, blank record detection

#### StatisticsIOHook
- **Purpose:** Performance monitoring and metrics
- **Overridden Methods:** OnPostOpen, OnPostClose, OnPostRead, OnPostWrite, OnPostUpdate, OnPostDelete
- **State:** Operation counters
- **Features:** Reset capability, formatted output

#### CombinedIOHook
- **Purpose:** Shows how to combine multiple concerns
- **Features:** Logging + Validation + Statistics in one class
- **Design Note:** Alternative to registering multiple separate hooks

## Hook Lifecycle

```
Application Code                    Hook System
     |                                   |
     |------ open(channel) ------------->|
     |                                   |
     |                            [PreOpen hook]
     |                                   |
     |                           [PostOpen hook]
     |                                   |
     |<------ open complete -------------|
     |                                   |
     |------ write(channel) ------------>|
     |                                   |
     |                           [PreWrite hook]
     |                                   |
     |                          [PostWrite hook]
     |                                   |
     |<------ write complete ------------|
     |                                   |
     |------ close(channel) ------------>|
     |                                   |
     |                           [PreClose hook]
     |                                   |
     |                          [PostClose hook]
     |                                   |
     |<------ close complete ------------|
```

## Method Call Sequence

When multiple hooks are registered for the same channel, they are called in registration order:

```
Operation: write(channel, record)

1. PreWrite phase:
   Hook1.PreWrite()
   Hook2.PreWrite()
   Hook3.PreWrite()

2. Actual write operation
   (Synergy runtime writes data)

3. PostWrite phase:
   Hook1.PostWrite()
   Hook2.PostWrite()
   Hook3.PostWrite()
```

## Design Patterns Used

### 1. Template Method Pattern
- **Where:** BaseIOHook class
- **Why:** Allows derived classes to customize behavior while maintaining consistent structure
- **Implementation:** PreXXX/PostXXX methods call OnXXX virtual methods

### 2. Strategy Pattern
- **Where:** Different hook implementations
- **Why:** Allows swapping hook behavior at runtime
- **Implementation:** Each hook provides different strategy for handling I/O

### 3. Observer Pattern
- **Where:** IOHooks mechanism
- **Why:** Hooks observe I/O operations without modifying core logic
- **Implementation:** Hooks registered as observers, notified of I/O events

### 4. Null Object Pattern
- **Where:** BaseIOHook virtual methods
- **Why:** Provides default "do nothing" implementation
- **Implementation:** Empty virtual method bodies

## Thread Safety Considerations

**Current Implementation:** Not thread-safe

**Considerations for Production:**
1. Hook registration/removal should be synchronized
2. Shared state (like statistics counters) needs protection
3. Log file access should be synchronized
4. Consider using thread-local storage for per-thread hooks

**Recommendation:** If using in multi-threaded environment:
- Add locking mechanisms to shared resources
- Use atomic operations for counters
- Consider per-thread hook instances

## Performance Considerations

### Hook Overhead

Each hook adds overhead to I/O operations:
- Method call overhead
- Conditional checks (if enabled)
- Hook-specific processing

**Mitigation Strategies:**
1. Disable hooks when not needed
2. Optimize hook code for performance
3. Avoid expensive operations in hooks
4. Use combined hooks instead of multiple separate hooks
5. Consider filtering at hook level rather than processing

### Memory Usage

- Each hook instance maintains its own state
- Log files consume disk space
- Statistics counters use minimal memory

**Best Practices:**
1. Close log files when not needed
2. Rotate log files periodically
3. Reset statistics counters when appropriate
4. Clean up hooks when done

## Extension Points

### Adding New Hooks

To add a new hook type:

1. Create a class extending BaseIOHook
2. Override relevant OnXXX methods
3. Add any specific state/properties
4. Implement constructor and destructor

Example skeleton:

```dbl
public class MyNewHook extends BaseIOHook
    
    private mMyState, int
    
    public method MyNewHook
        channelName, string
    proc
        parent(channelName)
        ;; Initialize state
    endmethod
    
    protected override method OnPostRead, void
        channelName, string
        recordArea, a
        direction, IOReadDirection
    proc
        ;; Custom logic
    endmethod
    
endclass
```

### Extending the Base Class

To add common functionality to all hooks:

1. Add protected methods/properties to BaseIOHook
2. Update existing hooks to use new functionality
3. Document changes in this file

## Testing Strategy

### Unit Testing
- Test each hook class independently
- Verify hook methods are called at correct times
- Test enable/disable functionality
- Verify state management

### Integration Testing
- Test multiple hooks on same channel
- Verify hook order is preserved
- Test hook removal
- Verify no interference between hooks

### Performance Testing
- Measure overhead of hooks
- Test with large numbers of operations
- Profile hook execution time

## Known Limitations

1. **No built-in error handling:** Hooks should handle their own exceptions
2. **No hook priorities:** Hooks execute in registration order
3. **No filtering:** All hooks receive all events for their channel
4. **No async support:** All hooks execute synchronously
5. **Single-threaded design:** Not thread-safe without modifications

## Future Enhancements

Possible improvements:

1. **Hook priorities:** Allow specifying execution order
2. **Event filtering:** Let hooks specify which events they want
3. **Async hooks:** Support for asynchronous hook execution
4. **Hook chains:** Allow hooks to modify data passed to next hook
5. **Configuration:** External configuration for hook settings
6. **Dependency injection:** Support for constructor injection
7. **Metrics:** Built-in performance metrics for hooks

## Conclusion

This architecture provides a solid foundation for using I/O hooks in Synergy DBL through inheritance. The design is extensible, maintainable, and demonstrates best practices for object-oriented programming in Synergy DBL.
