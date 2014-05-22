using Gtk;

namespace Views
{
    public class NotificationAreaView : Object
    {
        private InfoBar infobar { get; set; }
        private Label label { get; set; }

        public NotificationAreaView (InfoBar _infobar)
        {
            infobar = _infobar;

            label = new Label ("Notification Area");

            infobar.get_content_area ().add (label);
        }

        public void set_notification (string notification)
        {
            label.label = notification;
            infobar.show_all ();
        }
    }
}
// vim: ts=4 sw=4
