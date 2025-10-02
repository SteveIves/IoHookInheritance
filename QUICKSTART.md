# Quick Start Guide

This guide will help you get started with the IoHookInheritance example quickly.

## What You'll Learn

- How to create I/O Hook classes that inherit from a common base
- How to register multiple hooks for the same channel
- How to use hooks to add logging, validation, and statistics to your I/O operations
- How to enable/disable hooks dynamically

## Prerequisites

- Synergy DBL compiler and runtime environment
- Basic understanding of Synergy DBL programming
- Familiarity with object-oriented programming concepts

## Quick Start (5 minutes)

### 1. Clone or Download the Repository

```bash
git clone https://github.com/SteveIves/IoHookInheritance.git
cd IoHookInheritance
```

### 2. Build the Project

**On Linux/Mac:**
```bash
./build.sh
```

**On Windows:**
```cmd
build.bat
```

### 3. Run the Example

```bash
dbr MainProgram.dbr
```

### 4. Review the Output

- Check the console output to see the demonstration
- Open `logging.txt` to see detailed operation logs
- Open `combined.txt` to see the combined hook logs

## Understanding the Code

### The Inheritance Hierarchy

```
BaseIOHook (abstract)
├── LoggingIOHook      - Logs all I/O operations
├── ValidationIOHook   - Validates data before writes
├── StatisticsIOHook   - Tracks operation counts
└── CombinedIOHook     - Combines all features
```

### Key Files to Review

1. **BaseIOHook.dbl** - Start here to understand the base class
2. **LoggingIOHook.dbl** - Simple example of extending the base
3. **MainProgram.dbl** - See how to use the hooks

### Basic Usage Pattern

```dbl
;; 1. Create hook instances
loggingHook = new LoggingIOHook("MYCHANNEL", "mylog.txt")

;; 2. Register the hook
IOHooks.AddHook("MYCHANNEL", loggingHook)

;; 3. Perform normal I/O operations
open(channel = 0, O:I, "MYCHANNEL:myfile.ism")
;; ... your I/O operations ...
close channel

;; 4. Remove hook when done
IOHooks.RemoveHook("MYCHANNEL", loggingHook)
```

## Next Steps

### Customizing the Example

1. **Modify validation rules** in `ValidationIOHook.dbl`
2. **Add new hook types** by creating a new class that extends `BaseIOHook`
3. **Change log format** in `LoggingIOHook.dbl`
4. **Add more statistics** in `StatisticsIOHook.dbl`

### Creating Your Own Hook

Here's a minimal example:

```dbl
public class MyHook extends BaseIOHook
    
    public method MyHook
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
        xcall console("Record read: " + %atrim(recordArea))
    endmethod
    
endclass
```

### Best Practices

1. **Always call parent constructor** in derived classes
2. **Check if hook is enabled** before performing expensive operations
3. **Use appropriate On* methods** for your use case:
   - PreRead/PostRead - Before/after reading data
   - PreWrite/PostWrite - Before/after writing data
   - PreOpen/PostOpen - Before/after opening files
   - PreClose/PostClose - Before/after closing files

4. **Handle exceptions** in your hook code to prevent breaking I/O operations
5. **Clean up resources** in destructor or PreClose/PostClose methods

## Common Issues

### Compilation Errors

**Problem:** "Type 'IOHooks' not found"
**Solution:** Ensure you're using a recent version of Synergy DBL that supports I/O Hooks

**Problem:** "Cannot find dbl compiler"
**Solution:** Add Synergy DBL bin directory to your PATH

### Runtime Issues

**Problem:** Hooks not being called
**Solution:** Make sure you registered the hook with the exact same channel name used in the OPEN statement

**Problem:** Performance degradation
**Solution:** Check if hooks are doing expensive operations. Consider disabling hooks you don't need or optimizing hook code.

## Additional Examples

### Example 1: Temporarily Disable a Hook

```dbl
loggingHook.Enabled = false
;; Perform operations without logging
loggingHook.Enabled = true
```

### Example 2: Multiple Hooks on Same Channel

```dbl
IOHooks.AddHook("DATA", loggingHook)
IOHooks.AddHook("DATA", validationHook)
IOHooks.AddHook("DATA", statsHook)
;; All three hooks will be called for each operation
```

### Example 3: Different Hooks for Different Channels

```dbl
IOHooks.AddHook("CUSTOMER", customerLoggingHook)
IOHooks.AddHook("ORDERS", orderLoggingHook)
;; Each channel gets its own logging
```

## Getting Help

- Review the full README.md for detailed documentation
- Check EXAMPLE_OUTPUT.md to see expected program output
- Examine the source code comments for implementation details

## Further Reading

- [Synergy DBL Documentation](https://www.synergex.com/docs/)
- Object-oriented programming in Synergy DBL
- ISAM file handling in Synergy DBL

---

Happy coding with I/O Hooks!
