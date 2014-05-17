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

        var response = this.recordedAnswers[uri];
        if (response == null) {
            stderr.printf (@"HttpProxyMock: Requested uri '$uri' but the answer was not recorded");
        }

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

void main (string[] args) {
    Test.init (ref args);
    add_task_tests ();
    add_authenticator_tests ();
    add_response_tests ();
    Test.run ();
}

// vim: ts=4 sw=4
