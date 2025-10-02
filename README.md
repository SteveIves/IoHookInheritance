# IoHookInheritance

An example of how to use several Synergy DBL I/O Hooks classes concurrently via inheritance.

## Overview

This repository demonstrates how to implement and use multiple I/O Hook classes in Synergy DBL that inherit from a common base class. Each hook provides specialized functionality while sharing common behavior through inheritance.

## Project Structure

### Core Classes

1. **BaseIOHook.dbl** - Abstract base class
   - Provides common functionality for all I/O hooks
   - Defines virtual methods that can be overridden by derived classes
   - Implements the basic IOHooks interface with enable/disable capability
   - Serves as the foundation for inheritance

2. **LoggingIOHook.dbl** - Logging functionality
   - Inherits from BaseIOHook
   - Logs all I/O operations to a file
   - Captures open, close, read, write, update, and delete operations
   - Includes timestamps for each operation

3. **ValidationIOHook.dbl** - Data validation
   - Inherits from BaseIOHook
   - Validates data before write and update operations
   - Checks for minimum/maximum record lengths
   - Detects blank records
   - Tracks validation errors

4. **StatisticsIOHook.dbl** - Operation statistics
   - Inherits from BaseIOHook
   - Tracks counts of all I/O operations
   - Provides methods to display and reset statistics
   - Useful for performance monitoring

5. **CombinedIOHook.dbl** - Combined functionality
   - Inherits from BaseIOHook
   - Demonstrates how to combine multiple features in one class
   - Includes logging, validation, and statistics in a single hook
   - Shows advanced inheritance patterns

### Supporting Files

- **Customer.def** - Sample record structure for demonstration
- **MainProgram.dbl** - Main program demonstrating concurrent hook usage

## Key Concepts Demonstrated

### 1. Inheritance Hierarchy

All hook classes inherit from `BaseIOHook`, which in turn extends the Synergy `IOHooks` class:

```
IOHooks (Synergy built-in)
    ↓
BaseIOHook (abstract base)
    ↓
    ├── LoggingIOHook
    ├── ValidationIOHook
    ├── StatisticsIOHook
    └── CombinedIOHook
```

### 2. Concurrent Hook Usage

Multiple hooks can be registered for the same channel and will all execute for each I/O operation:

```dbl
;; Register multiple hooks for the same channel
IOHooks.AddHook("CUSTOMER", loggingHook)
IOHooks.AddHook("CUSTOMER", validationHook)
IOHooks.AddHook("CUSTOMER", statisticsHook)
```

### 3. Virtual Method Overriding

Each derived class can override specific virtual methods to provide custom behavior:

```dbl
protected override method OnPostRead, void
    channelName, string
    recordArea, a
    direction, IOReadDirection
proc
    ;; Custom implementation
endmethod
```

### 4. Common Functionality

The base class provides:
- Enable/disable capability for all hooks
- Channel name tracking
- Consistent method signatures
- Default implementations (do nothing)

## How to Build and Run

### Prerequisites

- Synergy DBL compiler (dbl)
- Synergy runtime environment

### Building the Project

```bash
# Compile all source files
dbl -o BaseIOHook.dbo BaseIOHook.dbl
dbl -o LoggingIOHook.dbo LoggingIOHook.dbl
dbl -o ValidationIOHook.dbo ValidationIOHook.dbl
dbl -o StatisticsIOHook.dbo StatisticsIOHook.dbl
dbl -o CombinedIOHook.dbo CombinedIOHook.dbl
dbl -o MainProgram.dbo MainProgram.dbl

# Link the program
dblink -o MainProgram.dbr MainProgram.dbo BaseIOHook.dbo LoggingIOHook.dbo ValidationIOHook.dbo StatisticsIOHook.dbo CombinedIOHook.dbo

# Or use dbr directly
dbl MainProgram.dbl BaseIOHook.dbl LoggingIOHook.dbl ValidationIOHook.dbl StatisticsIOHook.dbl CombinedIOHook.dbl -o MainProgram.dbr
```

### Running the Program

```bash
dbr MainProgram.dbr
```

### Expected Output

The program will:
1. Register all I/O hooks
2. Perform various I/O operations (open, write, read, update, delete, close)
3. Display statistics from each hook
4. Show validation errors (if any)
5. Create log files (`logging.txt` and `combined.txt`)

## Use Cases

### When to Use I/O Hooks

- **Auditing**: Track all database operations for compliance
- **Logging**: Record detailed operation logs for debugging
- **Validation**: Enforce business rules before data operations
- **Performance Monitoring**: Track operation counts and patterns
- **Security**: Monitor and control data access
- **Encryption**: Encrypt/decrypt data transparently
- **Caching**: Implement read-ahead or write-behind caching

### Benefits of Inheritance-Based Approach

1. **Code Reuse**: Common functionality is implemented once in the base class
2. **Consistency**: All hooks follow the same pattern and interface
3. **Maintainability**: Changes to common behavior only need to be made in one place
4. **Extensibility**: Easy to create new hooks by deriving from the base class
5. **Flexibility**: Hooks can be enabled/disabled individually
6. **Composition**: Multiple hooks can work together on the same channel

## Advanced Topics

### Creating Your Own Hook

To create a new hook:

1. Create a class that inherits from `BaseIOHook`
2. Override the virtual `OnXXX` methods you need
3. Add any additional properties or methods
4. Register your hook with `IOHooks.AddHook()`

Example:

```dbl
public class MyCustomHook extends BaseIOHook
    
    public method MyCustomHook
        channelName, string
    proc
        parent(channelName)
    endmethod
    
    protected override method OnPostRead, void
        channelName, string
        recordArea, a
        direction, IOReadDirection
    proc
        ;; Your custom logic here
    endmethod
    
endclass
```

### Enabling/Disabling Hooks

All hooks derived from `BaseIOHook` support enabling/disabling:

```dbl
loggingHook.Enabled = false  ;; Temporarily disable
loggingHook.Enabled = true   ;; Re-enable
```

### Multiple Channels

Different hooks can be registered for different channels:

```dbl
IOHooks.AddHook("CUSTOMER", customerLoggingHook)
IOHooks.AddHook("ORDERS", orderLoggingHook)
```

## License

This is example code provided for educational purposes.

## Author

Steve Ives

## Additional Resources

- [Synergy DBL Documentation](https://www.synergex.com/docs/)
- [IOHooks Class Reference](https://www.synergex.com/docs/)

## Contributing

This is a demonstration repository. Feel free to use this code as a starting point for your own implementations.