using Gtk;

namespace Views
{
    class Task
    {
        const string UI_FILE = "src/views/task.ui";

        private Builder builder;
        private Box _box;
        private Label name_label;

        public Box box { get { return _box; } }

        public Task (Models.Task task)
        {
            builder = new Builder ();
            builder.add_from_file (UI_FILE);

            _box = builder.get_object ("Task") as Box;
            name_label = builder.get_object ("name") as Label;

            name_label.label = task.name;
        }
    }
}


// vim: ts=4 sw=4
