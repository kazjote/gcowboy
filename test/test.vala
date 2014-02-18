/*
   rtm = new Rtm(apikey, httpProxy);

   rtm.authenticate();
   rtm.getTasks();
*/

using Gee;

class HttpProxyMock : Object, HttpProxyInterface
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
        var rtm = new Rtm("apikey", "secret", proxy);

        rtm.authenticate ();

        // Digest::MD5.hexdigest('secretapi_keyapikeypermsread,write')
        assert (proxy.getRecordedQueries ().
                      contains ("http://www.rememberthemilk.com/services/auth/?api_key=apikey&perms=read,write&api_sig=74156eef9f5454d55556e8d3de077dc1"));
    });
}

void main (string[] args) {
    Test.init (ref args);
    add_foo_tests ();
    Test.run ();
}

// vim: ts=4 sw=4
