using Gtk;

namespace Views
{
    class NewTask : Object
    {
        private Entry entry { get; set; }
        private NotificationArea notification_area { get; set; }
        private Models.TaskRepository repository { get; set; }

        public NewTask (Entry _entry, Models.TaskRepository _repository, NotificationArea _notification_area)
        {
            entry = _entry;
            notification_area = _notification_area;
            repository = _repository;

            repository.finished_adding.connect (() => {
                var text = shorten (entry.text, 40);
                notification_area.set_notification (@"Task '$text' has been added");
                entry.sensitive = true;
                entry.text = "";
            });

            entry.activate.connect (() => {
                entry.sensitive = false;
                repository.add_task (entry.text);
            });
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
