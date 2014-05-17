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
        private Label _url_title;
        private LinkButton _url_label;
        private Label _time_title;
        private Label _time_label;
        private Label name_label;
        private Arrow _arrow;
        private Button _complete_button;
        private Models.Task model;

        public EventBox box { get { return _box; } }

        public signal void complete_requested ();

        public Task (Models.Task _model)
        {
            model = _model;

            builder = new Builder ();
            try {
                builder.add_from_file (UI_FILE);
            } catch (GLib.Error e) {
                stderr.printf ("Could not load UI: %s\n", e.message);
            }

            name_label = builder.get_object ("name") as Label;
            _box = builder.get_object ("Task") as EventBox;
            _viewport = builder.get_object ("TaskViewport") as Viewport;
            _details = builder.get_object ("Details") as Viewport;
            _url_title = builder.get_object ("UrlTitle") as Label;
            _url_label = builder.get_object ("UrlLabel") as LinkButton;
            _time_label = builder.get_object ("DueLabel") as Label;
            _time_title = builder.get_object ("DueTitle") as Label;
            _arrow = builder.get_object ("Arrow") as Arrow;
            _complete_button = builder.get_object ("Complete") as Button;

            switch (model.priority) {
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

            _complete_button.clicked.connect (() => {
                _complete_button.sensitive = false;
                complete_requested ();
            });

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

            if (model.url == "") {
                _url_label.hide ();
                _url_title.hide ();
            } else {
                _url_label.label = shorten (model.url, 25);
                _url_label.uri = model.url;

                _url_label.show ();
                _url_title.show ();
            }

            if (model.due != null) {
                var local_due = model.due.to_local ();
                _time_label.label = local_due.format ("%x");

                _time_label.show ();
                _time_title.show ();
            } else {
                _time_label.hide ();
                _time_title.hide ();
            }

            name_label.label = shorten (model.name, 40);
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
