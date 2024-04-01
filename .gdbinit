python
import sys 
sys.path.insert(0, '/usr/share/gcc/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)

def RectangleHook(item, field):
    if field:
        if field == '[width]':  
            # item['...'] looks up a field in the struct, returned as a gdb.Value
            # int(...) converts the gdb.Value to an int so we can do arithmetic on it
            # gdb.Value(...) converts the result back to a gdb.Value
            return gdb.Value(int(item['right']) - item['left'])
        if field == '[height]': 
            # do something similar for the height
            return gdb.Value(int(item['bottom']) - item['top'])
    else:
        print('[width]')         # add the width custom field
        print('[height]')        # add the height custom field
        _gf_fields_recurse(item) # add the fields actually in the struct

gf_hooks = { 'Rectangle': RectangleHook } # create the hook dictionary
end

set breakpoint pending on
set disassembly-flavor intel
