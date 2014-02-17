/*
   rtm = new Rtm(apikey, httpProxy);

   rtm.authenticate();
   rtm.getTasks();
*/

using Gee;

class HttpProxyMock : HttpProxyInterface
{

    ArrayList<string> recordedQueries;
    HashMap<string, string> recordedAnswers;

    public HttpProxyMock ()
    {
        this.recordedQueries = new ArrayList<string>();
        this.recordedAnswers = new HashMap<string, string>();
    }

    public string request (string uri)
    {
        this.recordedQueries.add(uri);
        return this.recordedAnswers[uri];
    }

    public ArrayList<string> getRecordedQueries ()
    {
        return this.recordedQueries;
    }

    public void recordAnswer (string uri, string response)
    {
        this.recordedAnswers[uri] = response;
    }
}

void add_foo_tests () {
    Test.add_func ("/vala/test", () => {
        assert ("foo" + "bar" == "foobar");
    });

    Test.add_func ("/rtm/authenticate", () => {
        var proxy = new HttpProxyMock();
        var rtm = new Rtm("apikey", proxy);

        assert (proxy.getRecordedQueries().contains("http://"));
    });
}

void main (string[] args) {
    Test.init (ref args);
    add_foo_tests ();
    Test.run ();
}

// vim: ts=4 sw=4
