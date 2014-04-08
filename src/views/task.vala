using Gtk;

namespace Views
{
    class Task
    {
        const string UI_FILE = "src/views/task.ui";

        private Builder builder;
        private Viewport _viewport;
        private Label name_label;

        public Viewport viewport { get { return _viewport; } }

        public Task (Models.Task task)
        {
            builder = new Builder ();
            builder.add_from_file (UI_FILE);

            name_label = builder.get_object ("name") as Label;
            _viewport = builder.get_object ("Task") as Viewport;

            name_label.label = task.name;
        }
    }
}


// vim: ts=4 sw=4
