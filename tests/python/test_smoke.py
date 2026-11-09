def test_lua51_runtime_available():
    from lupa.lua51 import LuaRuntime

    rt = LuaRuntime()
    assert rt.eval("_VERSION") == "Lua 5.1"
