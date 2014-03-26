public class HttpProxy : Object, HttpProxyInterface
{
    public string request (string uri)
    {
        var session = new Soup.SessionSync ();
        var message = new Soup.Message ("GET", uri);

        // send the HTTP request and wait for response
        // stderr.printf (@"Request: $uri\n\n");
        session.send_message (message);

        var response = (string) message.response_body.data;

        // stderr.printf (@"Response: $response\n\n");

        // output the XML result to stdout
        return response;
    }
}

// vim: ts=4 sw=4
