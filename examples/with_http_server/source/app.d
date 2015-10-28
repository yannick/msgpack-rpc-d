import vibe.d;
import msgpackrpc;

void test(HTTPServerRequest req, HTTPServerResponse res)
{
    string enhanceme = req.query.get("enhanceme", "D");
    auto client = new TCPClient(Endpoint(18800, "127.0.0.1"));
    import msgpackrpc.client : Future;
    logDebug("Call Async Operation\n\n");
    Future f = client.callAsync("enhance", enhanceme);
    logDebug("\n\nCalled Async Operation");
    string enhanced = f.get!string();


    res.writeBody("enhanced Result: " ~ enhanced ~ "\n");
}

static void main()
{

    setLogLevel(LogLevel.trace);

    auto router = new URLRouter;
    router.get("/", &test);

    //set webserver config
    auto settings = new HTTPServerSettings;
    settings.port = 9090;
    settings.bindAddresses = ["0.0.0.0"];
    settings.options = settings.options | HTTPServerOption.parseCookies | HTTPServerOption.parseQueryString;
    listenHTTP(settings, router);

    //start a rpc server
    import rpcserver;

    auto rpcapi = new TCPServer!(RPCServer)(new RPCServer);
    rpcapi.listen(Endpoint(18800, "127.0.0.1"));

    lowerPrivileges();
    runEventLoop();

}
