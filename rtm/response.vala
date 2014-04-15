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
        private List<TaskSerie> _task_series;

        public Stat stat { get { return _stat; } }
        public Token token { get { return _token; } }
        public Frob frob { get { return _frob; } }
        public List<TaskList> task_lists { get { return _task_lists; } }
        public List<TaskSerie> task_series { get { return _task_series; } }
        public Timeline timeline { get; set; }

        public Response (string body)
        {
            response_body = body;
            _task_series = new List<TaskSerie> ();
            _task_lists = new List<TaskList> ();
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
                case "timeline":
                    this.timeline = new Timeline (element);
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
                case "tasks":
                    for (Xml.Node* list_iter = element->children; list_iter != null; list_iter = list_iter->next) {
                        if (list_iter->name != "list") continue;

                        var list_id = int.parse (list_iter->get_prop ("id"));

                        for (Xml.Node* serie_iter = list_iter->children; serie_iter != null; serie_iter = serie_iter->next) {
                            if (serie_iter->name != "taskseries") continue;

                            _task_series.append (new TaskSerie (list_id, serie_iter));
                        }
                    }
                    break;
            }
        }
    }
}

// vim: ts=4 sw=4
