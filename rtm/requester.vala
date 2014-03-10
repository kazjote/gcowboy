public class Requester : Object
{
    class Parameter : Object
    {
        public string key;
        public string val;

        public Parameter (string key, string val)
        {
            this.key = key;
            this.val = val;
        }
    }

    private HttpProxyInterface proxy;
    private string secret;
    private List<Parameter> parameters;

    public Requester (HttpProxyInterface proxy, string secret)
    {
        this.proxy = proxy;
        this.secret = secret;
        this.parameters = new List<Parameter> ();
    }

    public void add_parameter (string key, string value)
    {
        parameters.append (new Parameter (key, value));
    }

    public string create_signed_query ()
    {
        parameters.sort ((a,b) => {
            if (a.key == b.key) return 0;

            return a.key > b.key ? 1 : -1;
        });

        string to_sign = "";

        parameters.foreach ((parameter) => {
            to_sign += parameter.key + parameter.val;
        });

        to_sign = this.secret + to_sign;

        var checksum = new Checksum (ChecksumType.MD5);

        print (to_sign + "\n");

        var to_sign_array = (uchar[]) to_sign.to_utf8 ();

        checksum.update (to_sign_array, to_sign_array.length);
        var signature = checksum.get_string ();

        var query = "";
        parameters.foreach ((parameter) => {
            query += parameter.key + "=" + parameter.val + "&";
        });

        query += "api_sig=" + signature;

        return query;
    }
}

// vim: ts=4 sw=4
