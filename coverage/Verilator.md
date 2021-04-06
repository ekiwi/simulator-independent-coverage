# Verilator Coverage


Verilator creates a function to declare coverage, like this:

```.cpp
void VTest1Module::__vlCoverInsert(uint32_t* countp, bool enable, const char* filenamep, int lineno, int column,
    const char* hierp, const char* pagep, const char* commentp, const char* linescovp) {
    uint32_t* count32p = countp;
    static uint32_t fake_zero_count = 0;
    if (!enable) count32p = &fake_zero_count;
    *count32p = 0;
    VL_COVER_INSERT(count32p,  "filename",filenamep,  "lineno",lineno,  "column",column,
        "hier",std::string(name())+hierp,  "page",pagep,  "comment",commentp,  (linescovp[0] ? "linescov" : ""), linescovp);
}
```

The `VL_COVER_INSERT` is defined in `/usr/share/verilator/include/verilated_cov.h`:
```.cpp
#define VL_COVER_INSERT(countp, ...) \
    VL_IF_COVER(VerilatedCov::_inserti(countp); VerilatedCov::_insertf(__FILE__, __LINE__); \
                VerilatedCov::_insertp("hier", name(), __VA_ARGS__))

```


For user coverage, verilator declares the counters like this:

```.cpp
__vlCoverInsert(&(vlSymsp->__Vcoverage[0]), first, "Test1Module.sv", 46, 7, ".Test1Module", "v_user/Test1Module", "cover", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[1]), first, "Test1Module.sv", 50, 7, ".Test1Module", "v_user/Test1Module", "cover", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[2]), first, "Test1Module.sv", 54, 7, ".Test1Module", "v_user/Test1Module", "cover", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[3]), first, "Test1Module.sv", 58, 7, ".Test1Module", "v_user/Test1Module", "cover", "");
```

For line coverage:

```.cpp
__vlCoverInsert(&(vlSymsp->__Vcoverage[0]), first, "TileTester_baseline.sv", 4131, 5, ".TileTester", "v_branch/TileTester", "if", "4131-4132");
__vlCoverInsert(&(vlSymsp->__Vcoverage[1]), first, "TileTester_baseline.sv", 4131, 6, ".TileTester", "v_branch/TileTester", "else", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[2]), first, "TileTester_baseline.sv", 4134, 5, ".TileTester", "v_branch/TileTester", "if", "4134-4135");
__vlCoverInsert(&(vlSymsp->__Vcoverage[3]), first, "TileTester_baseline.sv", 4134, 6, ".TileTester", "v_branch/TileTester", "else", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[4]), first, "TileTester_baseline.sv", 4140, 7, ".TileTester", "v_branch/TileTester", "if", "4140-4141");
```


For toggle coverage:

```.cpp
__vlCoverInsert(&(vlSymsp->__Vcoverage[0]), first, "TileTester_baseline.sv", 3416, 17, "", "v_toggle/Queue_8", "clock", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[1]), first, "TileTester_baseline.sv", 3417, 17, "", "v_toggle/Queue_8", "reset", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[2819]), first, "TileTester_baseline.sv", 3418, 17, "", "v_toggle/Queue_8", "io_enq_ready", "");
__vlCoverInsert(&(vlSymsp->__Vcoverage[2820]), first, "TileTester_baseline.sv", 3419, 17, "", "v_toggle/Queue_8", "io_enq_valid", "");
```

## Toggle Coverage Investigation

Using `TileTester_BmarkTestsmedian.riscv/toggle_native`.

Number of 32-bit cover counters in `VTileTester__Syms.h`:
```.cpp
// COVERAGE
uint32_t __Vcoverage[4682];
```

Calls to `__vlCoverInsert` (using `rg --no-ignore-vcs "__vlCoverInsert" -wc`):
```
VTileTester.h:1
VTileTester_Cache.h:1
VTileTester_Queue_8__Slow.cpp:346
VTileTester_Queue_8.h:1
VTileTester__Slow.cpp:1
VTileTester_Cache__2__Slow.cpp:2366
VTileTester__2__Slow.cpp:7944
VTileTester_Cache__Slow.cpp:1
```

_Question: why are there more calls to `__vlCoverInsert` than counters (4682 vs. 10656)?_


### Duplicate Counters

Multiple counters are registered as different entries.
It seems like Verilator might be doing some sort of deduplication.

Example:
```
2502:VTileTester_Queue_8__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3424, 17, "", "v_toggle/Queue_8", "io_deq_bits_data[59]", "");
2633:VTileTester_Queue_8__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3437, 15, "", "v_toggle/Queue_8", "ram_data___05FT_7_data[59]", "");
10175:VTileTester__2__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3719, 15, ".TileTester.LatencyPipe_1", "v_toggle/LatencyPipe_1", "Queue_6_io_deq_bits_data[59]", "");
10244:VTileTester__2__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3725, 15, ".TileTester.LatencyPipe_1", "v_toggle/LatencyPipe_1", "Queue_7_io_enq_bits_data[59]", "");
10380:VTileTester__2__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3532, 17, ".TileTester.LatencyPipe_1.Queue_7", "v_toggle/Queue_15", "io_enq_bits_data[59]", "");
10642:VTileTester__2__Slow.cpp:    __vlCoverInsert(&(vlSymsp->__Vcoverage[2947]), first, "TileTester_baseline.sv", 3550, 15, ".TileTester.LatencyPipe_1.Queue_7", "v_toggle/Queue_15", "ram_data___05FT_3_data[59]", "");
```

This counter is only incremented in two places:
```
VTileTester__Slow.cpp
9192:        ++(vlSymsp->__Vcoverage[2947]);

VTileTester__1.cpp
12132:        ++(vlSymsp->__Vcoverage[2947]);
```

The increment in `VTileTester__Slow.cpp` happens in the `VTileTester::_settle__TOP__1` function.
The increment in `VTileTester__1.cpp` happens in the `VTileTester::_sequent__TOP__12` function.


### Hierarchy / Signal Investigation

- `LatencyPipe_1.Queue_7` is an instance of `Queue_15`.
- `LatencyPipe_1.Queue_6` is an instance of `Queue_8`.
- `TileTester.LatencyPipe_1.Queue_6_io_deq_bits_data` is directly connected to
  `TileTester.LatencyPipe_1.Queue_7_io_enq_bits_data`.
- `TileTester.LatencyPipe_1.Queue_7_io_enq_bits_data` is connected to the
  `io_enq_bits_data` port of the `Queue_15` module.
- The input `io_enq_bits_data` of `Queue_15` is directly connected to
  `ram_data__T_3_data`.
- `TileTester.LatencyPipe_1.Queue_6_io_deq_bits_data` is connected to the
  `io_deq_bits_data` port of the `Queue_8` module.
- The output `io_deq_bits_data` of `Queue_8` is directly connected to
  `ram_data__T_7_data`.

Thus all six signals alias!




