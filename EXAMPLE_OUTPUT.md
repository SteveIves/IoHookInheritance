# Example Output

This file shows the expected output when running the IoHookInheritance demonstration program.

## Console Output

```
=========================================================
I/O Hook Inheritance Demonstration
=========================================================

This program demonstrates how to use multiple I/O Hook
classes concurrently through inheritance.

Step 1: Registering I/O Hooks...

  - LoggingIOHook registered
  - ValidationIOHook registered
  - StatisticsIOHook registered
  - CombinedIOHook registered (separate channel)

Step 2: Performing I/O operations with individual hooks...

  File opened (all hooks triggered)

  Writing valid records...
    5 records written

  Attempting to write invalid (blank) record...
VALIDATION ERROR: Record too short (minimum 50 bytes)
VALIDATION ERROR: Record too long (maximum 200 bytes)
VALIDATION ERROR: Record is blank
VALIDATION: PreWrite validation failed for channel CUSTOMER
    Invalid record written (see validation warnings)

  Reading records back...
    All records read

  Updating a record...
    Record updated

  Deleting a record...
    Record deleted

  File closed (all hooks triggered)

Step 3: Displaying hook statistics...


=== I/O Statistics for Channel: CUSTOMER ===
  Opens:   1
  Closes:  1
  Reads:   6
  Writes:  6
  Updates: 1
  Deletes: 1
===========================================


Validation errors detected: 3

Step 4: Demonstrating combined hook...

  Writing records with combined hook...
  Reading records with combined hook...
  Combined hook operations complete


=== Combined I/O Hook Statistics ===
  Channel: CUSTOMER_COMBINED
  Reads:            3
  Writes:           3
  Updates:          0
  Deletes:          0
  Validation Errors: 0
====================================


Step 5: Cleaning up...

  All hooks removed

=========================================================
Demonstration Complete!
=========================================================

Key Points Demonstrated:
  1. Multiple I/O hooks can be registered for the same
     channel and work concurrently
  2. All hooks inherit from a common base class
  3. Each hook provides specialized functionality:
     - Logging
     - Validation
     - Statistics
  4. Hooks can be combined into a single class
  5. Hooks can be enabled/disabled individually

Check the following files for detailed logs:
  - logging.txt (LoggingIOHook output)
  - combined.txt (CombinedIOHook output)

```

## Log File Examples

### logging.txt

```
[20250102171530000000] OPEN: Channel=CUSTOMER, Mode=0, File=customer.ism
[20250102171530100000] WRITE: Channel=CUSTOMER, Record=0000000001Customer 1             Address 1                       555-0001
[20250102171530200000] WRITE: Channel=CUSTOMER, Record=0000000002Customer 2             Address 2                       555-0002
[20250102171530300000] WRITE: Channel=CUSTOMER, Record=0000000003Customer 3             Address 3                       555-0003
[20250102171530400000] WRITE: Channel=CUSTOMER, Record=0000000004Customer 4             Address 4                       555-0004
[20250102171530500000] WRITE: Channel=CUSTOMER, Record=0000000005Customer 5             Address 5                       555-0005
[20250102171530600000] WRITE: Channel=CUSTOMER, Record=
[20250102171530700000] READ: Channel=CUSTOMER, Direction=0, Record=0000000001Customer 1             Address 1                       555-0001
[20250102171530800000] READ: Channel=CUSTOMER, Direction=0, Record=0000000002Customer 2             Address 2                       555-0002
[20250102171530900000] READ: Channel=CUSTOMER, Direction=0, Record=0000000003Customer 3             Address 3                       555-0003
[20250102171531000000] READ: Channel=CUSTOMER, Direction=0, Record=0000000004Customer 4             Address 4                       555-0004
[20250102171531100000] READ: Channel=CUSTOMER, Direction=0, Record=0000000005Customer 5             Address 5                       555-0005
[20250102171531200000] READ: Channel=CUSTOMER, Direction=0, Record=
[20250102171531300000] UPDATE: Channel=CUSTOMER, Record=0000000001Updated Customer 1   Address 1                       555-0001
[20250102171531400000] DELETE: Channel=CUSTOMER, Record=0000000002Customer 2             Address 2                       555-0002
[20250102171531500000] CLOSE: Channel=CUSTOMER
```

### combined.txt

```
[20250102171532000000] OPEN: Channel=CUSTOMER_COMBINED, Mode=0, File=customer2.ism
[20250102171532100000] WRITE: Channel=CUSTOMER_COMBINED, Record validated
[20250102171532200000] WRITE: Channel=CUSTOMER_COMBINED, Record validated
[20250102171532300000] WRITE: Channel=CUSTOMER_COMBINED, Record validated
[20250102171532400000] READ: Channel=CUSTOMER_COMBINED, Count=1
[20250102171532500000] READ: Channel=CUSTOMER_COMBINED, Count=2
[20250102171532600000] READ: Channel=CUSTOMER_COMBINED, Count=3
[20250102171532700000] CLOSE: Channel=CUSTOMER_COMBINED
```

## Generated Files

After running the program, you will find the following files created:

1. **logging.txt** - Detailed log of all operations on the CUSTOMER channel
2. **combined.txt** - Detailed log of all operations on the CUSTOMER_COMBINED channel
3. **customer.ism** - ISAM data file with test customer records
4. **customer2.ism** - ISAM data file for combined hook demonstration

These files can be examined to see the hook behavior in detail.
