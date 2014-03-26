using Xml;

public class Response : Object
{
    public static Response? factory (string response, string method)
    {
        Xml.Doc* doc = Parser.parse_doc (response);
        if (doc == null) {
            stdout.printf ("Failed to parse the response!");
            return null;
        }

        Xml.Node* root = doc->get_root_element ();

        if (root->get_prop ("stat") != "ok") {
            return null;
        }

        Response result = null;

        switch (method) {
            case "rtm.auth.getFrob":
                result = new Frob(root->children);
                break;
            case "rtm.auth.getToken":
                result = new Token(root->children);
                break;
        }

        delete doc;

        return result;
    }
}

// vim: ts=4 sw=4
