using Xml;

namespace Rtm
{

    public enum Stat
    {
        OK,
        FAIL
    }

    public class Response : Object
    {
        private Stat _stat;
        private string response_body;
        private Token _token;
        private Frob _frob;
        private List<TaskList> _task_lists;

        public Stat stat { get { return _stat; } }
        public Token token { get { return _token; } }
        public Frob frob { get { return _frob; } }
        public List<TaskList> task_lists { get { return _task_lists; } }

        public Response (string body)
        {
            response_body = body;
        }

        public bool process ()
        {
            Xml.Doc* doc = Parser.parse_doc (response_body);
            if (doc == null) {
                stdout.printf ("Failed to parse the response!");
                return false;
            }

            Xml.Node* root = doc->get_root_element ();

            switch (root->get_prop ("stat")) {
                case "ok":
                    _stat = Stat.OK;
                    break;
                case "fail":
                    _stat = Stat.FAIL;
                    break;
            }

            for (Xml.Node* iter = root->children; iter != null; iter = iter->next) {
                process_element (iter);
            }

            return true;
        }

        private void process_element (Xml.Node* element)
        {
            switch (element->name) {
                case "frob":
                    this._frob = new Frob (element);
                    break;
                case "auth":
                    this._token = new Token (element);
                    break;
                case "lists":
                    _task_lists = new List<TaskList> ();

                    for (Xml.Node* iter = element->children; iter != null; iter = iter->next) {
                        _task_lists.append (new TaskList (iter));
                    }
                    break;
            }
        }
    }
}

// vim: ts=4 sw=4
