using Xml;

public class Token : Response
{
    private string _token;

    public string token
    {
        get { return _token; }
    }

    public Token (Xml.Node* auth)
    {
        while (auth->name != "auth" && auth->next != null) {
            auth = auth->next;
        }

        Xml.Node* auth_child = auth->children;

        if (auth_child != null) {
            while (auth_child->name != "token" && auth_child->next != null) {
                auth_child = auth_child->next;
            }

            this._token = auth_child->get_content ();
        } else {
            stderr.printf ("Invalid Token response!");
        }
    }
}

// vim: ts=4 sw=4
