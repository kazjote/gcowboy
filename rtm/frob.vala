using Xml;

namespace Rtm
{
    public class Frob : Object
    {
        private string _frob;

        public string frob { get { return _frob; } }

        public Frob (Xml.Node* frob_child)
        {
            this._frob = frob_child->get_content ();
        }
    }
}

// vim: ts=4 sw=4
