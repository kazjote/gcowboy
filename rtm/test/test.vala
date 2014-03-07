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

void add_rtm_tests () {

    Test.add_func ("/rtm/get_lits", () => {
        var proxy = new HttpProxyMock();

        proxy.recordAnswer (
            "http://api.rememberthemilk.com/services/rest/?method=rtm.auth.getFrob",
            "{'rsp': {'frob': 'abcd'} }");


        var rtm = new Rtm("apikey", "secret", proxy);

        var authenticate_url = "";

        rtm.authentication.connect((t, url) => {
            authenticate_url = url;
        });

        rtm.get_lists();

        // Digest::MD5.hexdigest('secretapi_keyapikeypermsread,write')
        assert (authenticate_url == "http://www.rememberthemilk.com/services/auth/?api_key=apikey&frob=abcd&perms=read,write&api_sig=74156eef9f5454d55556e8d3de077dc1");

    });
}

void main (string[] args) {
    Test.init (ref args);
    add_rtm_tests ();
    Test.run ();
}

// vim: ts=4 sw=4
