module rpcserver;

class RPCServer
{
    string enhance(string input)
    {
        import core.thread;
        import std.datetime;
        import vibe.core.log;
        logDebug("sleeping 5 sec");
        Thread.sleep(dur!"seconds"(5));
        logDebug("woke up");
        return "8===========" ~ input;
    }
}
