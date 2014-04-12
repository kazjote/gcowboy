using Gtk;

namespace Views
{
    class Task
    {
        const string UI_FILE = "src/views/task.ui";

        private Builder builder;
        private EventBox _box;
        private Viewport _viewport;
        private Viewport _details;
        private LinkButton _url_label;
        private Label _time_label;
        private Label name_label;
        private Arrow _arrow;

        public EventBox box { get { return _box; } }

        public Task (Models.Task task)
        {
            builder = new Builder ();
            builder.add_from_file (UI_FILE);

            name_label = builder.get_object ("name") as Label;
            _box = builder.get_object ("Task") as EventBox;
            _viewport = builder.get_object ("TaskViewport") as Viewport;
            _details = builder.get_object ("Details") as Viewport;
            _url_label = builder.get_object ("Url") as LinkButton;
            _time_label = builder.get_object ("Time") as Label;
            _arrow = builder.get_object ("Arrow") as Arrow;

            switch (task.priority) {
                case Models.Priority.HIGHEST:
                    _viewport.get_style_context ().add_class ("priority-highest");
                    break;
                case Models.Priority.MEDIUM:
                    _viewport.get_style_context ().add_class ("priority-medium");
                    break;
                case Models.Priority.LOWEST:
                    _viewport.get_style_context ().add_class ("priority-lowest");
                    break;
                default:
                    _viewport.get_style_context ().add_class ("priority-unknown");
                    break;
            }

            _box.enter_notify_event.connect ((widget, event) => {
                _viewport.get_style_context ().add_class ("hovered");
                return true;
            });

            _box.leave_notify_event.connect ((widget, event) => {
                _viewport.get_style_context ().remove_class ("hovered");
                return true;
            });

            _box.button_press_event.connect ((widget, event) => {
                if (_details.is_visible ()) {
                    _details.hide ();
                    _arrow.arrow_type = ArrowType.LEFT;
                } else {
                    _details.show ();
                    _arrow.arrow_type = ArrowType.DOWN;
                }

                return true;
            });

            _details.hide ();

            if (task.url == "") {
                _url_label.hide ();
            } else {
                _url_label.label = shorten (task.url, 25);
                _url_label.uri = task.url;
            }
            _time_label.label = task.created;

            name_label.label = shorten (task.name, 40);
        }

        private string shorten (string caption, int max_length) {
            if (caption.length > max_length) {
                return caption.substring(0, max_length - 3) + "...";
            } else {
                return caption;
            }
        }
    }
}


// vim: ts=4 sw=4
