using Gtk;

namespace Views
{
    public class TaskListListItem : Object
    {
        const string UI_FILE = "src/views/task_list.ui";

        private Models.TaskList model { get; set; }

        public EventBox box { get; private set; }
        public Box task_list_box { get; private set; }
        private Label name_label { get; set; }
        private NotificationArea notification_area { get; set; }

        public TaskListListItem (Models.TaskList task_list, Box _task_list_box, NotificationArea _notification_area)
        {
            model = task_list;
            task_list_box = _task_list_box;
            notification_area = _notification_area;

            var builder = new Builder ();

            try {
                builder.add_from_file (UI_FILE);
            } catch (GLib.Error e) {
                stderr.printf ("Could not load UI: %s\n", e.message);
            }

            name_label = builder.get_object ("Name") as Label;
            box = builder.get_object ("TaskList") as EventBox;

            name_label.label = task_list.name;
        }
    }
}

// vim: ts=4 sw=4
