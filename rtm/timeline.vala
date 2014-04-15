using Xml;

namespace Rtm
{
    public class Timeline : Object
    {

        public string timeline { get; private set; }

        public Timeline (Xml.Node* node)
        {
            this.timeline = node->get_content ();
        }
    }
}

// vim: ts=4 sw=4
