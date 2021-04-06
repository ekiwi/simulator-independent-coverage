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


Toggle coverage seems to do something special.
