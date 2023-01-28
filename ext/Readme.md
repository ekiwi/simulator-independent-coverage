# AFL

We provide a fork of the AFL fuzzer with a small custom
modification.

AFL was forked at the following commit:
```
commit 61037103ae3722c8060ff7082994836a794f978e
Author: u1f383 <cc85nod@gmail.com>
Date:   Tue Jun 8 22:59:48 2021 +0800

    Fix a typo filename comparison in the fuzzer (#139)
    
    * Fix wrong default README filename fron 'README.txt' to 'README.testcases'
    
    * Update afl_driver.cpp url of llvm-project

```

Our change adds a UNIX time stamp to AFL generated inputs in order to be able
to plot coverage over time accurately.:

```{.diff}
diff --git a/afl-fuzz.c b/afl-fuzz.c
index 46a216c..377ce4e 100644
--- a/afl-fuzz.c
+++ b/afl-fuzz.c
@@ -3035,7 +3035,10 @@ static void pivot_inputs(void) {
       u8* use_name = strstr(rsl, ",orig:");
 
       if (use_name) use_name += 6; else use_name = rsl;
-      nfn = alloc_printf("%s/queue/id:%06u,orig:%s", out_dir, id, use_name);
+
+      //TODO: Added these to the filename
+      const u64 unix_time = get_cur_time();
+      nfn = alloc_printf("%s/queue/id:%06u,orig:%s,%lld", out_dir, id, use_name, unix_time);
 
 #else
 
@@ -3101,6 +3104,11 @@ static u8* describe_op(u8 hnb) {
   }
 
   if (hnb == 2) strcat(ret, ",+cov");
+  
+  // append unix time
+  const u64 unix_time = get_cur_time();
+  sprintf(ret + strlen(ret), ",%lld", unix_time);
+  
 
   return ret;

```


# Verilator

We obtained the source code of Verilator version 4.036 like this:
```
wget https://github.com/verilator/verilator/archive/refs/tags/v4.034.tar.gz
```

We then added a small manual patch in order to make it compile with a more
modern BISON version:

```{.diff}
diff --git a/ext/verilator-4.034-src/src/verilog.y b/ext/verilator-4.034-src/src/verilog.y
index d612356..565ede1 100644
--- a/ext/verilator-4.034-src/src/verilog.y
+++ b/ext/verilator-4.034-src/src/verilog.y
@@ -236,6 +236,19 @@ static void UNSUPREAL(FileLine* fileline) {
 class AstSenTree;
 %}
 
+// Bison 3.0 and newer
+BISONPRE_VERSION(3.0,%define parse.error verbose)
+
+
+// We run bison with the -d argument. This tells it to generate a
+// header file with token names. Old versions of bison pasted the
+// contents of that file into the generated source as well; newer
+// versions just include it.
+//
+// Since we run bison through ../bisonpre, it doesn't know the correct
+// header file name, so we need to tell it.
+BISONPRE_VERSION(3.7,%define api.header.include {"V3ParseBison.h"})
+
 // When writing Bison patterns we use yTOKEN instead of "token",
 // so Bison will error out on unknown "token"s.

```
